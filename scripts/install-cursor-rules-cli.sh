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

# Default installation path
readonly DEFAULT_INSTALL_DIR="$HOME/.local/bin"
readonly SHELL_CONFIG_FILE="$HOME/.zshrc"

# Help text
show_help() {
    cat << EOF
${BLUE}Cursor Rules CLI Installation Script${NC} 🚀 v${VERSION}

${YELLOW}USAGE:${NC}
    ${SCRIPT_NAME} [OPTIONS] [INSTALL_PATH]

${YELLOW}DESCRIPTION:${NC}
    Installs the copy-cursor-rules CLI tool to ~/.local/bin and adds it to your 
    ~/.zshrc file so you can use it from anywhere in your terminal.

${YELLOW}OPTIONS:${NC}
    -h, --help          Show this help message
    -v, --version       Show version information
    -f, --force         Force installation even if tool already exists
    -u, --uninstall     Uninstall the CLI tool and remove from ~/.zshrc
    --dry-run          Show what would be done without actually doing it
    --no-shell-config  Skip modifying ~/.zshrc (manual PATH setup required)

${YELLOW}ARGUMENTS:${NC}
    INSTALL_PATH        Custom installation path (default: ~/.local/bin)

${YELLOW}EXAMPLES:${NC}
    ${SCRIPT_NAME}                    # Install to ~/.local/bin and update ~/.zshrc
    ${SCRIPT_NAME} /usr/local/bin     # Install to specific location
    ${SCRIPT_NAME} --dry-run          # Preview installation
    ${SCRIPT_NAME} --uninstall        # Remove installation and clean ~/.zshrc
    ${SCRIPT_NAME} --no-shell-config  # Install without modifying ~/.zshrc

${YELLOW}NOTES:${NC}
    • Default installation: ~/.local/bin (created if it doesn't exist)
    • Automatically adds directory to PATH in ~/.zshrc
    • Restart terminal or run 'source ~/.zshrc' after installation
    • Safe to run multiple times - won't create duplicate PATH entries

${YELLOW}EXIT CODES:${NC}
    0    Success
    1    General error
    2    Invalid arguments
    3    Source file not found
    4    Permission denied

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

# Check if a path is already in shell config file
path_in_shell_config() {
    local check_path="$1"
    local config_file="$2"
    
    if [[ ! -f "$config_file" ]]; then
        return 1
    fi
    
    # Check for exact path matches in export PATH statements
    grep -q "export PATH.*${check_path}" "$config_file" || \
    grep -q "PATH.*${check_path}" "$config_file"
}

# Add path to shell config file
add_path_to_shell_config() {
    local install_path="$1"
    local config_file="$2"
    local dry_run="${3:-0}"
    
    if path_in_shell_config "$install_path" "$config_file"; then
        log_info "Path already exists in $config_file"
        return 0
    fi
    
    local path_export="export PATH=\"$install_path:\$PATH\""
    
    if [[ "$dry_run" == "1" ]]; then
        log_info "Would add to $config_file: $path_export"
        return 0
    fi
    
    # Create config file if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        touch "$config_file"
    fi
    
    # Add the path export with a comment
    {
        echo ""
        echo "# Added by cursor-rules-cli installer"
        echo "$path_export"
    } >> "$config_file"
    
    log_success "Added $install_path to $config_file"
}

# Remove path from shell config file
remove_path_from_shell_config() {
    local install_path="$1"
    local config_file="$2"
    local dry_run="${3:-0}"
    
    if [[ ! -f "$config_file" ]]; then
        return 0
    fi
    
    if ! path_in_shell_config "$install_path" "$config_file"; then
        log_info "Path not found in $config_file"
        return 0
    fi
    
    if [[ "$dry_run" == "1" ]]; then
        log_info "Would remove path entries from $config_file"
        return 0
    fi
    
    # Create a temporary file to store the cleaned config
    local temp_file="$(mktemp)"
    
    # Remove lines containing the install path and the comment
    grep -v "# Added by cursor-rules-cli installer" "$config_file" | \
    grep -v "export PATH.*${install_path}" | \
    grep -v "PATH.*${install_path}" > "$temp_file"
    
    # Replace the original file
    mv "$temp_file" "$config_file"
    
    log_success "Removed $install_path from $config_file"
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



# Install the CLI tool
install_cli() {
    local source_script="$1"
    local install_path="$2"
    local force="${3:-0}"
    local dry_run="${4:-0}"
    local modify_shell_config="${5:-1}"
    
    local target_file="$install_path/$CLI_TOOL_NAME"
    
    # Check if already installed
    if [[ -f "$target_file" && "$force" == "0" ]]; then
        log_error "CLI tool already installed at: $target_file"
        log_info "Use --force to overwrite or --uninstall to remove"
        return 1
    fi
    
    if [[ "$dry_run" == "1" ]]; then
        log_info "Would create directory: $install_path"
        log_info "Would copy $source_script -> $target_file"
        log_info "Would make executable: $target_file"
        if [[ "$modify_shell_config" == "1" ]]; then
            add_path_to_shell_config "$install_path" "$SHELL_CONFIG_FILE" "1"
        fi
        return 0
    fi
    
    # Create install directory if it doesn't exist
    if [[ ! -d "$install_path" ]]; then
        log_info "Creating directory: $install_path"
        if ! mkdir -p "$install_path"; then
            log_error "Failed to create directory: $install_path"
            return 1
        fi
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
    
    # Modify shell configuration if requested
    if [[ "$modify_shell_config" == "1" ]]; then
        add_path_to_shell_config "$install_path" "$SHELL_CONFIG_FILE" "0"
        log_info "You can now use: $CLI_TOOL_NAME --help"
        log_warn "Restart your terminal or run: source ~/.zshrc"
    else
        log_info "You can now use: $CLI_TOOL_NAME --help (if $install_path is in PATH)"
    fi
}

# Uninstall the CLI tool
uninstall_cli() {
    local dry_run="${1:-0}"
    local install_path="${2:-$DEFAULT_INSTALL_DIR}"
    local found=0
    
    # Expand tilde in install path
    install_path="${install_path/#\~/$HOME}"
    local target_file="$install_path/$CLI_TOOL_NAME"
    
    # Remove the CLI tool file
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
    
    # Also check if it's available via which (in case of multiple installations)
    if command_exists "$CLI_TOOL_NAME"; then
        local which_path="$(which "$CLI_TOOL_NAME")"
        if [[ "$which_path" != "$target_file" ]]; then
            found=1
            if [[ "$dry_run" == "1" ]]; then
                log_info "Would remove: $which_path"
            else
                log_info "Removing additional installation: $which_path"
                if rm -f "$which_path"; then
                    log_success "Removed: $which_path"
                else
                    log_error "Failed to remove: $which_path"
                fi
            fi
        fi
    fi
    
    # Remove from shell configuration
    remove_path_from_shell_config "$install_path" "$SHELL_CONFIG_FILE" "$dry_run"
    
    if [[ "$found" == "0" ]]; then
        log_warn "No installation found to remove"
        # Still try to clean shell config in case it exists
        return 1
    fi
    
    if [[ "$dry_run" == "0" ]]; then
        log_success "Uninstallation complete"
        log_warn "Restart your terminal or run: source ~/.zshrc"
    fi
}

# Main function
main() {
    local install_path="$DEFAULT_INSTALL_DIR"
    local force=0
    local dry_run=0
    local uninstall=0
    local modify_shell_config=1
    
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
            --no-shell-config)
                modify_shell_config=0
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
    
    if [[ "$uninstall" == "1" ]]; then
        uninstall_cli "$dry_run" "$install_path"
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
    
    # Expand tilde in install path
    install_path="${install_path/#\~/$HOME}"
    
    log_info "Install path: $install_path"
    if [[ "$modify_shell_config" == "1" ]]; then
        log_info "Shell config: $SHELL_CONFIG_FILE"
    else
        log_warn "Skipping shell configuration modification"
    fi
    
    # Perform installation
    install_cli "$source_script" "$install_path" "$force" "$dry_run" "$modify_shell_config"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 