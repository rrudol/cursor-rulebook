#!/bin/bash

# Cursor Rules Validation Script 🔍
# Validates rule syntax, formatting, and best practices

set -e
# Disable pipefail to handle broken pipes gracefully
set +o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="$(dirname "$SCRIPT_DIR")/.cursor/rules"
EXIT_CODE=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}🔍 Cursor Rules Validation${NC}"
    echo -e "${BLUE}=========================${NC}"
    echo ""
}

print_summary() {
    local total_files=$1
    local errors=$2
    local warnings=$3
    
    echo ""
    echo -e "${BLUE}📊 Validation Summary${NC}"
    echo -e "${BLUE}===================${NC}"
    echo -e "Total files checked: ${PURPLE}$total_files${NC}"
    echo -e "Errors found: ${RED}$errors${NC}"
    echo -e "Warnings found: ${YELLOW}$warnings${NC}"
    
    if [[ $errors -eq 0 && $warnings -eq 0 ]]; then
        echo -e "${GREEN}✅ All rules are valid!${NC}"
    elif [[ $errors -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  All rules are syntactically valid but have warnings${NC}"
    else
        echo -e "${RED}❌ Some rules have errors that need fixing${NC}"
    fi
}

error_count=0
warning_count=0
file_count=0

validate_yaml_frontmatter() {
    local file="$1"
    local content
    
    # Extract frontmatter (between first two --- lines)
    content=$(awk '/^---$/{if(++count==2) exit} count>=1' "$file" | sed '1d;$d')
    
    if [[ -z "$content" ]]; then
        echo -e "${RED}❌ Missing frontmatter${NC}"
        ((error_count++))
        return 1
    fi
    
    # Validate YAML syntax using Python
    if command -v python3 &> /dev/null; then
        local yaml_check_result
        yaml_check_result=$(echo "$content" | python3 -c "
import sys
try:
    import yaml
    yaml.safe_load(sys.stdin.read())
    print('✅ Valid YAML frontmatter')
except ImportError:
    print('⚠️  PyYAML not available - skipping YAML syntax check')
    sys.exit(2)
except yaml.YAMLError as e:
    print(f'❌ YAML syntax error: {e}')
    sys.exit(1)
except Exception as e:
    print(f'❌ Error parsing YAML: {e}')
    sys.exit(1)
" 2>&1)
        local yaml_exit_code=$?
        echo "$yaml_check_result"
        
        if [[ $yaml_exit_code -eq 1 ]]; then
            ((error_count++))
            return 1
        elif [[ $yaml_exit_code -eq 2 ]]; then
            ((warning_count++))
        fi
    else
        echo -e "${YELLOW}⚠️  Python not available - skipping YAML syntax check${NC}"
        ((warning_count++))
    fi
    
    # Check required fields
    local has_description=$(echo "$content" | grep -c "^description:" || true)
    local has_globs=$(echo "$content" | grep -c "^globs:" || true)
    local has_alwaysApply=$(echo "$content" | grep -c "^alwaysApply:" || true)
    
    if [[ $has_description -eq 0 ]]; then
        echo -e "${RED}❌ Missing required field: description${NC}"
        ((error_count++))
    fi
    
    if [[ $has_globs -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Missing globs field (optional but recommended)${NC}"
        ((warning_count++))
    fi
    
    if [[ $has_alwaysApply -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Missing alwaysApply field (optional but recommended)${NC}"
        ((warning_count++))
    fi
    
    return 0
}

validate_markdown_structure() {
    local file="$1"
    local content
    
    # Remove frontmatter for markdown analysis
    content=$(awk '/^---$/{if(++count==2) next} count>=2' "$file")
    
    # Check for title (first non-empty line should be # Title)
    local first_line=$(echo "$content" | grep -v '^[[:space:]]*$' | head -1 2>/dev/null || true)
    if [[ ! "$first_line" =~ ^#[[:space:]] ]]; then
        echo -e "${RED}❌ Missing or invalid title (should start with '# ')${NC}"
        ((error_count++))
    fi
    
    # Check for common required sections
    local has_motivation=$(echo "$content" | grep -ic "## Motivation" || true)
    local has_examples=$(echo "$content" | grep -ic "## Examples\|### ✅\|### ❌" || true)
    
    if [[ $has_motivation -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No Motivation section found (recommended for rule clarity)${NC}"
        ((warning_count++))
    fi
    
    if [[ $has_examples -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No Examples section found (recommended for rule understanding)${NC}"
        ((warning_count++))
    fi
    
    # Check for emoji in title
    if [[ "$first_line" =~ [[:space:]][🤖🌍🛠️🎯⚡🧠🔥💡🚀✨] ]]; then
        echo -e "${GREEN}✅ Title includes category emoji${NC}"
    else
        echo -e "${YELLOW}⚠️  Title missing category emoji (🤖🌍🛠️ recommended)${NC}"
        ((warning_count++))
    fi
}

validate_file_naming() {
    local file="$1"
    local basename=$(basename "$file" .mdc)
    
    # Check kebab-case naming
    if [[ "$basename" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]] || [[ "$basename" =~ ^[a-z][a-z0-9]*$ ]]; then
        echo -e "${GREEN}✅ File name follows kebab-case convention${NC}"
    else
        echo -e "${YELLOW}⚠️  File name should use kebab-case: $basename${NC}"
        ((warning_count++))
    fi
    
    # Check file extension
    if [[ "$file" == *.mdc ]]; then
        echo -e "${GREEN}✅ Correct .mdc file extension${NC}"
    else
        echo -e "${RED}❌ Rule files should use .mdc extension${NC}"
        ((error_count++))
    fi
}

validate_content_quality() {
    local file="$1"
    local content=$(cat "$file")
    
    # Check for placeholder content (excluding code blocks)
    # Remove code blocks first, then check for placeholders
    local content_no_code=$(echo "$content" | sed '/```/,/```/d')
    local placeholders=$(echo "$content_no_code" | grep -c "\[TODO\]\|\[PLACEHOLDER\]\|\[FIXME\]\|\[.*\.\.\.\]" || true)
    if [[ $placeholders -gt 0 ]]; then
        echo -e "${RED}❌ Found $placeholders placeholder(s) - replace with actual content${NC}"
        ((error_count++))
    fi
    
    # Check line length (warn if any line > 120 chars)
    local long_lines=$(awk 'length($0) > 120 {count++} END {print count+0}' "$file")
    if [[ $long_lines -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  Found $long_lines line(s) longer than 120 characters${NC}"
        ((warning_count++))
    fi
    
    # Check for common typos
    local typos=$(echo "$content" | grep -ic "recieve\|occured\|seperate\|accomodate" || true)
    if [[ $typos -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  Possible typos detected (check spelling)${NC}"
        ((warning_count++))
    fi
}

validate_rule_file() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo -e "${PURPLE}📄 Validating: $filename${NC}"
    echo "----------------------------------------"
    
    # File existence and readability
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}❌ File not found or not readable${NC}"
        ((error_count++))
        return 1
    fi
    
    # Basic file checks
    validate_file_naming "$file"
    
    # Frontmatter validation
    echo -e "${BLUE}🔧 Checking frontmatter...${NC}"
    if ! validate_yaml_frontmatter "$file"; then
        echo -e "${RED}❌ Frontmatter validation failed${NC}"
    fi
    
    # Markdown structure validation
    echo -e "${BLUE}📝 Checking markdown structure...${NC}"
    validate_markdown_structure "$file"
    
    # Content quality checks
    echo -e "${BLUE}🎯 Checking content quality...${NC}"
    validate_content_quality "$file"
    
    ((file_count++))
    echo ""
}

main() {
    print_header
    
    if [[ ! -d "$RULES_DIR" ]]; then
        echo -e "${RED}❌ Rules directory not found: $RULES_DIR${NC}"
        exit 1
    fi
    
    # Find all .mdc files
    local rule_files=()
    while IFS= read -r -d '' file; do
        rule_files+=("$file")
    done < <(find "$RULES_DIR" -name "*.mdc" -type f -print0)
    
    if [[ ${#rule_files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No .mdc files found in $RULES_DIR${NC}"
        exit 0
    fi
    
    echo -e "Found ${PURPLE}${#rule_files[@]}${NC} rule file(s) to validate"
    echo ""
    
    # Validate each file
    for file in "${rule_files[@]}"; do
        validate_rule_file "$file"
    done
    
    # Print summary
    print_summary "$file_count" "$error_count" "$warning_count"
    
    # Set exit code based on errors
    if [[ $error_count -gt 0 ]]; then
        EXIT_CODE=1
    fi
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --strict      Treat warnings as errors"
        echo ""
        echo "Examples:"
        echo "  $0            # Validate all rules"
        echo "  $0 --strict   # Validate with warnings as errors"
        exit 0
        ;;
    --strict)
        STRICT_MODE=1
        ;;
esac

# Run main validation
main

# Handle strict mode
if [[ "${STRICT_MODE:-0}" -eq 1 && $warning_count -gt 0 ]]; then
    echo -e "${RED}❌ Strict mode: treating warnings as errors${NC}"
    EXIT_CODE=1
fi

exit $EXIT_CODE 