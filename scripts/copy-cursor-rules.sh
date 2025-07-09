#!/bin/bash

# Cursor Rules Copy Tool 📋
# Copies all cursor rules from .cursor/rules to current directory or specified target

set -euo pipefail

# Colors for pretty output 🎨
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script configuration
readonly SCRIPT_NAME="copy-cursor-rules"
readonly VERSION="1.0.0"

# Help text
show_help() {
    cat << EOF
${BLUE}Cursor Rules Copy Tool${NC} 📋 v${VERSION}

${YELLOW}USAGE:${NC}
    ${SCRIPT_NAME} [OPTIONS] [TARGET_DIR]

${YELLOW}DESCRIPTION:${NC}
    Copies all cursor rules (.mdc files) from .cursor/rules directory 
    to the specified target directory or current working directory.

${YELLOW}OPTIONS:${NC}
    -h, --help          Show this help message
    -v, --version       Show version information
    -f, --flatten       Copy all rules to a flat structure (no subdirectories)
    -q, --quiet         Suppress output messages
    --dry-run          Show what would be copied without actually copying

${YELLOW}ARGUMENTS:${NC}
    TARGET_DIR          Target directory to copy rules to (default: current directory)

${YELLOW}EXAMPLES:${NC}
    ${SCRIPT_NAME}                    # Copy rules to current directory
    ${SCRIPT_NAME} ~/my-project       # Copy rules to specified directory
    ${SCRIPT_NAME} --flatten          # Copy all rules to current dir without subdirs
    ${SCRIPT_NAME} --dry-run          # Preview what would be copied

${YELLOW}EXIT CODES:${NC}
    0    Success
    1    General error
    2    Invalid arguments
    3    Source directory not found
    4    Permission denied

EOF
}

# Logging functions
log_info() {
    [[ "${QUIET:-0}" == "0" ]] && echo -e "${GREEN}ℹ️  ${1}${NC}" >&2
}

log_warn() {
    [[ "${QUIET:-0}" == "0" ]] && echo -e "${YELLOW}⚠️  ${1}${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ ${1}${NC}" >&2
}

log_success() {
    [[ "${QUIET:-0}" == "0" ]] && echo -e "${GREEN}✅ ${1}${NC}" >&2
}

# Find the .cursor/rules directory
find_rules_dir() {
    local current_dir="$(pwd)"
    local search_dir="$current_dir"
    
    # Search upwards for .cursor/rules directory
    while [[ "$search_dir" != "/" ]]; do
        if [[ -d "$search_dir/.cursor/rules" ]]; then
            echo "$search_dir/.cursor/rules"
            return 0
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    # If not found in current path hierarchy, check if we're in a rules directory
    if [[ "$current_dir" =~ .cursor/rules ]]; then
        # Extract the base path to .cursor/rules
        local rules_path="${current_dir%%.cursor/rules*}.cursor/rules"
        if [[ -d "$rules_path" ]]; then
            echo "$rules_path"
            return 0
        fi
    fi
    
    return 1
}

# Copy files with directory structure preserved
copy_with_structure() {
    local source_dir="$1"
    local target_dir="$2"
    local dry_run="${3:-0}"
    
    log_info "Copying rules with directory structure preserved..."
    
    # Find all .mdc files and README.md files
    while IFS= read -r -d '' file; do
        local rel_path="${file#$source_dir/}"
        local target_path="$target_dir/$rel_path"
        local target_dir_path="$(dirname "$target_path")"
        
        if [[ "$dry_run" == "1" ]]; then
            echo "Would copy: $rel_path"
        else
            # Create target directory if it doesn't exist
            mkdir -p "$target_dir_path"
            
            # Copy the file
            if cp "$file" "$target_path"; then
                log_info "Copied: $rel_path"
            else
                log_error "Failed to copy: $rel_path"
                return 1
            fi
        fi
    done < <(find "$source_dir" \( -name "*.mdc" -o -name "README.md" \) -type f -print0)
}

# Copy files flattened (all in target directory root)
copy_flattened() {
    local source_dir="$1"
    local target_dir="$2"
    local dry_run="${3:-0}"
    
    log_info "Copying rules with flattened structure..."
    
    # Find all .mdc files
    while IFS= read -r -d '' file; do
        local filename="$(basename "$file")"
        local target_path="$target_dir/$filename"
        
        # Handle potential filename conflicts by adding directory prefix
        if [[ -f "$target_path" && "$dry_run" == "0" ]]; then
            local dir_name="$(basename "$(dirname "$file")")"
            local name_without_ext="${filename%.*}"
            local extension="${filename##*.}"
            target_path="$target_dir/${dir_name}-${name_without_ext}.${extension}"
            log_warn "File conflict resolved: $filename -> $(basename "$target_path")"
        fi
        
        if [[ "$dry_run" == "1" ]]; then
            echo "Would copy: $filename -> $(basename "$target_path")"
        else
            if cp "$file" "$target_path"; then
                log_info "Copied: $(basename "$target_path")"
            else
                log_error "Failed to copy: $filename"
                return 1
            fi
        fi
    done < <(find "$source_dir" -name "*.mdc" -type f -print0)
    
    # Copy main README.md if it exists
    if [[ -f "$source_dir/README.md" ]]; then
        if [[ "$dry_run" == "1" ]]; then
            echo "Would copy: README.md"
        else
            if cp "$source_dir/README.md" "$target_dir/cursor-rules-README.md"; then
                log_info "Copied: cursor-rules-README.md"
            fi
        fi
    fi
}

# Main function
main() {
    local target_dir="$(pwd)"
    local flatten=0
    local dry_run=0
    local quiet=0
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                echo "${SCRIPT_NAME} v${VERSION}"
                exit 0
                ;;
            -f|--flatten)
                flatten=1
                shift
                ;;
            -q|--quiet)
                quiet=1
                QUIET=1
                shift
                ;;
            --dry-run)
                dry_run=1
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                echo "Use --help for usage information."
                exit 2
                ;;
            *)
                target_dir="$1"
                shift
                ;;
        esac
    done
    
    # Find the source rules directory
    log_info "Looking for .cursor/rules directory..."
    local source_dir
    if ! source_dir="$(find_rules_dir)"; then
        log_error "Could not find .cursor/rules directory in current path hierarchy"
        log_error "Make sure you're in a project with cursor rules or run from a subdirectory"
        exit 3
    fi
    
    log_success "Found rules directory: $source_dir"
    
    # Validate target directory
    if [[ ! -d "$target_dir" ]]; then
        if [[ "$dry_run" == "1" ]]; then
            log_info "Would create target directory: $target_dir"
        else
            log_info "Creating target directory: $target_dir"
            if ! mkdir -p "$target_dir"; then
                log_error "Failed to create target directory: $target_dir"
                exit 4
            fi
        fi
    fi
    
    # Convert to absolute path
    target_dir="$(cd "$target_dir" && pwd)"
    
    # Check if we have read permission on source
    if [[ ! -r "$source_dir" ]]; then
        log_error "No read permission for source directory: $source_dir"
        exit 4
    fi
    
    # Check if we have write permission on target (unless dry run)
    if [[ "$dry_run" == "0" && ! -w "$target_dir" ]]; then
        log_error "No write permission for target directory: $target_dir"
        exit 4
    fi
    
    log_info "Source: $source_dir"
    log_info "Target: $target_dir"
    
    if [[ "$dry_run" == "1" ]]; then
        log_warn "DRY RUN MODE - No files will actually be copied"
    fi
    
    # Perform the copy operation
    if [[ "$flatten" == "1" ]]; then
        copy_flattened "$source_dir" "$target_dir" "$dry_run"
    else
        copy_with_structure "$source_dir" "$target_dir" "$dry_run"
    fi
    
    if [[ "$dry_run" == "0" ]]; then
        log_success "Rules copied successfully to: $target_dir"
    else
        log_info "Dry run completed"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 