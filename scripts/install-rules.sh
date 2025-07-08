#!/bin/bash

# Cursor Rules Installation Script 🚀
# Easily copy cursor rules to your project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="$(dirname "$SCRIPT_DIR")/.cursor/rules"
TARGET_DIR="${1:-.cursor/rules}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo -e "${BLUE}Cursor Rules Installation Script${NC}"
    echo ""
    echo "Usage: $0 [target_directory] [options]"
    echo ""
    echo "Options:"
    echo "  --all                Install all rules"
    echo "  --ai-behavior       Install AI behavior rules only"
    echo "  --project-standards Install project standards rules only"
    echo "  --tools             Install tool management rules only"
    echo "  --list              List available rules"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                           # Install all rules to .cursor/rules"
    echo "  $0 /path/to/project          # Install all rules to specific path"
    echo "  $0 --ai-behavior             # Install only AI behavior rules"
    echo "  $0 /path/to/project --tools  # Install tool rules to specific path"
}

list_rules() {
    echo -e "${BLUE}Available Rules:${NC}"
    echo ""
    
    echo -e "${YELLOW}🤖 AI Behavior Rules:${NC}"
    find "$RULES_DIR/categories/ai-behavior" -name "*.mdc" -exec basename {} \; 2>/dev/null | sed 's/^/  - /' || echo "  (none found)"
    
    echo ""
    echo -e "${YELLOW}🌍 Project Standards:${NC}"
    find "$RULES_DIR/categories/project-standards" -name "*.mdc" -exec basename {} \; 2>/dev/null | sed 's/^/  - /' || echo "  (none found)"
    
    echo ""
    echo -e "${YELLOW}🛠️ Tool Management:${NC}"
    find "$RULES_DIR/categories/tools" -name "*.mdc" -exec basename {} \; 2>/dev/null | sed 's/^/  - /' || echo "  (none found)"
}

install_category() {
    local category="$1"
    local source_dir="$RULES_DIR/categories/$category"
    
    if [[ ! -d "$source_dir" ]]; then
        echo -e "${RED}Error: Category '$category' not found${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Installing $category rules to $TARGET_DIR...${NC}"
    
    # Create target directory
    mkdir -p "$TARGET_DIR"
    
    # Copy rules
    find "$source_dir" -name "*.mdc" -exec cp {} "$TARGET_DIR/" \;
    
    local count=$(find "$source_dir" -name "*.mdc" | wc -l)
    echo -e "${GREEN}✓ Installed $count rules from $category category${NC}"
}

install_all() {
    echo -e "${BLUE}Installing all rules to $TARGET_DIR...${NC}"
    
    # Create target directory
    mkdir -p "$TARGET_DIR"
    
    # Copy all rules maintaining structure
    if [[ -d "$RULES_DIR/categories" ]]; then
        find "$RULES_DIR/categories" -name "*.mdc" -exec cp {} "$TARGET_DIR/" \;
    fi
    
    # Copy README if it exists
    if [[ -f "$RULES_DIR/README.md" ]]; then
        cp "$RULES_DIR/README.md" "$TARGET_DIR/"
    fi
    
    local count=$(find "$RULES_DIR/categories" -name "*.mdc" 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ Installed $count rules total${NC}"
}

# Parse arguments
if [[ $# -eq 0 ]]; then
    install_all
    exit 0
fi

case "${!#}" in  # Last argument
    --help)
        print_usage
        exit 0
        ;;
    --list)
        list_rules
        exit 0
        ;;
    --all)
        install_all
        ;;
    --ai-behavior)
        install_category "ai-behavior"
        ;;
    --project-standards)
        install_category "project-standards"
        ;;
    --tools)
        install_category "tools"
        ;;
    *)
        if [[ "${!#}" == --* ]]; then
            echo -e "${RED}Error: Unknown option ${!#}${NC}"
            print_usage
            exit 1
        else
            install_all
        fi
        ;;
esac

echo -e "${GREEN}Installation complete! 🎉${NC}"
echo -e "${BLUE}Don't forget to restart Cursor to load the new rules.${NC}" 