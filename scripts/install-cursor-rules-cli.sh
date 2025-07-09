#!/bin/bash

# Cursor Rules CLI Installation Script 🚀
# Installs the copy-cursor-rules CLI tool to system PATH

set -euo pipefail

# Colors for pretty output 🎨
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script configuration
readonly SCRIPT_NAME="install-cursor-rules-cli"
readonly VERSION="1.0.0"
readonly CLI_TOOL_NAME="copy-cursor-rules"

# Default installation paths (in order of preference)
readonly DEFAULT_INSTALL_PATHS=(
    "/usr/local/bin"
    "$HOME/.local/bin"
    "$HOME/bin"
)

# Help text
show_help() {
    cat << EOF
${BLUE}Cursor Rules CLI Installation Script${NC} 🚀 v${VERSION}

${YELLOW}USAGE:${NC}
    ${SCRIPT_NAME} [OPTIONS] [INSTALL_PATH]

${YELLOW}DESCRIPTION:${NC}
    Installs the copy-cursor-rules CLI tool to system PATH so you can use it 
    from anywhere in your terminal.

${YELLOW}OPTIONS:${NC}
    -h, --help          Show this help message
    -v, --version       Show version information
    -f, --force         Force installation even if tool already exists
    -u, --uninstall     Uninstall the CLI tool instead of installing
    --dry-run          Show what would be done without actually doing it
    --list-paths       List potential installation paths

${YELLOW}ARGUMENTS:${NC}
    INSTALL_PATH        Custom installation path (must be in PATH)

${YELLOW}EXAMPLES:${NC}
    ${SCRIPT_NAME}                    # Install to default location
    ${SCRIPT_NAME} /usr/local/bin     # Install to specific location
    ${SCRIPT_NAME} --dry-run          # Preview installation
    ${SCRIPT_NAME} --uninstall        # Remove installation
    ${SCRIPT_NAME} --list-paths       # Show potential install locations

${YELLOW}NOTES:${NC}
    • Script will try default paths in order: /usr/local/bin, ~/.local/bin, ~/bin
    • You may need sudo for system-wide installation (/usr/local/bin)
    • Make sure the install path is in your \$PATH environment variable

${YELLOW}EXIT CODES:${NC}
    0    Success
    1    General error
    2    Invalid arguments
    3    Source file not found
    4    Permission denied
    5    Install path not in PATH

EOF
}

# Logging functions
log_info() {
    echo -e "${GREEN}ℹ️  ${1}${NC}" >&2
}

log_warn() {
    echo -e "${YELLOW}⚠️  ${1}${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ ${1}${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ ${1}${NC}" >&2
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a path is in PATH environment variable
path_in_env() {
    local check_path="$1"
    local normalized_path="$(realpath "$check_path" 2>/dev/null || echo "$check_path")"
    
    echo "$PATH" | tr ':' '\n' | while read -r path_entry; do
        local normalized_entry="$(realpath "$path_entry" 2>/dev/null || echo "$path_entry")"
        if [[ "$normalized_entry" == "$normalized_path" ]]; then
            return 0
        fi
    done
    
    return 1
}

# Find the source CLI script
find_source_script() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local source_script="$script_dir/${CLI_TOOL_NAME}.sh"
    
    if [[ -f "$source_script" ]]; then
        echo "$source_script"
        return 0
    fi
    
    # Try relative paths
    local alt_paths=(
        "./${CLI_TOOL_NAME}.sh"
        "../scripts/${CLI_TOOL_NAME}.sh"
        "./scripts/${CLI_TOOL_NAME}.sh"
    )
    
    for path in "${alt_paths[@]}"; do
        if [[ -f "$path" ]]; then
            echo "$(realpath "$path")"
            return 0
        fi
    done
    
    return 1
}

# Find the best installation path
find_install_path() {
    for path in "${DEFAULT_INSTALL_PATHS[@]}"; do
        # Expand tilde
        local expanded_path="${path/#\~/$HOME}"
        
        # Check if directory exists and is writable
        if [[ -d "$expanded_path" && -w "$expanded_path" ]]; then
            # Check if it's in PATH
            if path_in_env "$expanded_path"; then
                echo "$expanded_path"
                return 0
            else
                log_warn "Directory $expanded_path exists but is not in PATH"
            fi
        elif [[ ! -d "$expanded_path" ]]; then
            # Try to create the directory
            if mkdir -p "$expanded_path" 2>/dev/null; then
                if path_in_env "$expanded_path"; then
                    echo "$expanded_path"
                    return 0
                else
                    log_warn "Created directory $expanded_path but it's not in PATH"
                fi
            fi
        fi
    done
    
    return 1
}

# List potential installation paths
list_paths() {
    echo -e "${BLUE}Potential installation paths:${NC}"
    echo
    
    for path in "${DEFAULT_INSTALL_PATHS[@]}"; do
        local expanded_path="${path/#\~/$HOME}"
        local status=""
        local in_path=""
        
        if [[ -d "$expanded_path" ]]; then
            if [[ -w "$expanded_path" ]]; then
                status="${GREEN}✓ exists, writable${NC}"
            else
                status="${YELLOW}⚠ exists, not writable${NC}"
            fi
        else
            status="${RED}✗ does not exist${NC}"
        fi
        
        if path_in_env "$expanded_path"; then
            in_path="${GREEN}✓ in PATH${NC}"
        else
            in_path="${RED}✗ not in PATH${NC}"
        fi
        
        printf "  %-25s %s | %s\n" "$path" "$status" "$in_path"
    done
    
    echo
    echo -e "${YELLOW}Current PATH:${NC}"
    echo "$PATH" | tr ':' '\n' | sed 's/^/  /'
}

# Install the CLI tool
install_cli() {
    local source_script="$1"
    local install_path="$2"
    local force="${3:-0}"
    local dry_run="${4:-0}"
    
    local target_file="$install_path/$CLI_TOOL_NAME"
    
    # Check if already installed
    if [[ -f "$target_file" && "$force" == "0" ]]; then
        log_error "CLI tool already installed at: $target_file"
        log_info "Use --force to overwrite or --uninstall to remove"
        return 1
    fi
    
    if [[ "$dry_run" == "1" ]]; then
        log_info "Would copy $source_script -> $target_file"
        log_info "Would make executable: $target_file"
        return 0
    fi
    
    # Copy the script
    log_info "Installing CLI tool to: $target_file"
    if ! cp "$source_script" "$target_file"; then
        log_error "Failed to copy script to $target_file"
        return 1
    fi
    
    # Make executable
    if ! chmod +x "$target_file"; then
        log_error "Failed to make script executable"
        rm -f "$target_file" # Clean up on failure
        return 1
    fi
    
    log_success "CLI tool installed successfully!"
    log_info "You can now use: $CLI_TOOL_NAME --help"
    
    # Verify installation
    if command_exists "$CLI_TOOL_NAME"; then
        log_success "Verification: $CLI_TOOL_NAME is now available in PATH"
    else
        log_warn "Installation complete but $CLI_TOOL_NAME not found in PATH"
        log_warn "You may need to restart your terminal or run: source ~/.bashrc"
    fi
}

# Uninstall the CLI tool
uninstall_cli() {
    local dry_run="${1:-0}"
    local found=0
    
    # Look for installations in all potential paths
    for path in "${DEFAULT_INSTALL_PATHS[@]}"; do
        local expanded_path="${path/#\~/$HOME}"
        local target_file="$expanded_path/$CLI_TOOL_NAME"
        
        if [[ -f "$target_file" ]]; then
            found=1
            if [[ "$dry_run" == "1" ]]; then
                log_info "Would remove: $target_file"
            else
                log_info "Removing: $target_file"
                if rm -f "$target_file"; then
                    log_success "Removed: $target_file"
                else
                    log_error "Failed to remove: $target_file"
                fi
            fi
        fi
    done
    
    # Also check if it's available via which
    if command_exists "$CLI_TOOL_NAME"; then
        local which_path="$(which "$CLI_TOOL_NAME")"
        if [[ "$dry_run" == "1" ]]; then
            log_info "Would remove: $which_path"
        else
            log_info "Removing: $which_path"
            if rm -f "$which_path"; then
                log_success "Removed: $which_path"
            else
                log_error "Failed to remove: $which_path"
            fi
        fi
        found=1
    fi
    
    if [[ "$found" == "0" ]]; then
        log_warn "No installation found to remove"
        return 1
    fi
    
    if [[ "$dry_run" == "0" ]]; then
        log_success "Uninstallation complete"
    fi
}

# Main function
main() {
    local install_path=""
    local force=0
    local dry_run=0
    local uninstall=0
    local list_paths_flag=0
    
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
            -f|--force)
                force=1
                shift
                ;;
            -u|--uninstall)
                uninstall=1
                shift
                ;;
            --dry-run)
                dry_run=1
                shift
                ;;
            --list-paths)
                list_paths_flag=1
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                echo "Use --help for usage information."
                exit 2
                ;;
            *)
                install_path="$1"
                shift
                ;;
        esac
    done
    
    # Handle special flags
    if [[ "$list_paths_flag" == "1" ]]; then
        list_paths
        exit 0
    fi
    
    if [[ "$uninstall" == "1" ]]; then
        uninstall_cli "$dry_run"
        exit $?
    fi
    
    # Find source script
    log_info "Looking for source CLI script..."
    local source_script
    if ! source_script="$(find_source_script)"; then
        log_error "Could not find source script: ${CLI_TOOL_NAME}.sh"
        log_error "Make sure you're running this from the project directory"
        exit 3
    fi
    
    log_success "Found source script: $source_script"
    
    # Determine install path
    if [[ -n "$install_path" ]]; then
        # User specified a path
        install_path="${install_path/#\~/$HOME}"  # Expand tilde
        
        if [[ ! -d "$install_path" ]]; then
            log_error "Install path does not exist: $install_path"
            exit 4
        fi
        
        if [[ ! -w "$install_path" ]]; then
            log_error "No write permission for: $install_path"
            exit 4
        fi
        
        if ! path_in_env "$install_path"; then
            log_warn "Warning: $install_path is not in PATH"
            log_warn "The installed tool may not be accessible from command line"
        fi
    else
        # Find best install path automatically
        log_info "Finding best installation path..."
        if ! install_path="$(find_install_path)"; then
            log_error "Could not find a suitable installation path"
            log_error "Please specify a custom path or run --list-paths for options"
            exit 5
        fi
    fi
    
    log_info "Install path: $install_path"
    
    # Perform installation
    install_cli "$source_script" "$install_path" "$force" "$dry_run"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 