#!/bin/bash

# Dotfiles setup script
# Detects OS and creates symlinks to appropriate config files

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.dotfiles_links"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "osx";;
        *)          echo "unknown";;
    esac
}

# Log a symlink or directory creation
log_link() {
    local type="$1"  # "link" or "dir"
    local path="$2"
    echo "${type}:${path}" >> "$LOG_FILE"
}

# Create symlink with conflict detection
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "WARNING: $target exists and is not a symlink. Skipping to avoid overwriting local file."
        return 0
    elif [[ -L "$target" ]]; then
        local current_target=$(readlink "$target")
        if [[ "$current_target" != "$source" ]]; then
            echo "WARNING: $target is a symlink to $current_target, but should point to $source. Skipping."
            return 0
        else
            echo "OK: $target already correctly linked to $source"
            log_link "link" "$target"
            return 0
        fi
    fi
    
    echo "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
    log_link "link" "$target"
}

# Clean up old symlinks and directories
cleanup_old_links() {
    if [[ ! -f "$LOG_FILE" ]]; then
        return 0
    fi
    
    echo "Checking for old symlinks to clean up..."
    
    # Read current log and create temp file for new log
    local temp_log=$(mktemp)
    local cleaned_count=0
    
    while IFS=: read -r type path; do
        if [[ "$type" == "link" ]]; then
            if [[ -L "$path" ]] && [[ ! -e "$(readlink "$path")" ]]; then
                echo "Removing broken symlink: $path"
                if rm "$path" 2>/dev/null; then
                    cleaned_count=$((cleaned_count + 1))
                fi
            elif [[ -L "$path" ]] && [[ -e "$(readlink "$path")" ]]; then
                # Keep existing valid links in log
                echo "${type}:${path}" >> "$temp_log"
            fi
        elif [[ "$type" == "dir" ]]; then
            if [[ -d "$path" ]] && [[ -z "$(ls -A "$path" 2>/dev/null)" ]]; then
                echo "Removing empty directory: $path"
                if rmdir "$path" 2>/dev/null; then
                    cleaned_count=$((cleaned_count + 1))
                fi
            elif [[ -d "$path" ]]; then
                # Keep existing non-empty dirs in log
                echo "${type}:${path}" >> "$temp_log"
            fi
        fi
    done < "$LOG_FILE"
    
    # Replace log file with cleaned version
    mv "$temp_log" "$LOG_FILE"
    
    if [[ $cleaned_count -gt 0 ]]; then
        echo "Cleaned up $cleaned_count old items"
    fi
}

# Main setup function
setup_dotfiles() {
    local os_type=$(detect_os)
    
    echo "Detected OS: $os_type"
    
    if [[ "$os_type" == "unknown" ]]; then
        echo "Error: Unsupported operating system"
        exit 1
    fi
    
    local config_dir="$SCRIPT_DIR/$os_type"
    
    if [[ ! -d "$config_dir" ]]; then
        echo "Warning: No configuration directory found for $os_type"
        return 0
    fi
    
    # Clean up old links first
    cleanup_old_links
    
    echo "Setting up dotfiles from $config_dir"
    
    # Find all files in the OS-specific directory and create symlinks
    while IFS= read -r -d '' file; do
        # Get relative path from config directory
        local rel_path="${file#$config_dir/}"
        # Remove leading dot if present, then add our own
        rel_path="${rel_path#.}"
        local target_path="$HOME/.$rel_path"
        local target_dir="$(dirname "$target_path")"
        
        # Create target directory if it doesn't exist
        if [[ ! -d "$target_dir" ]]; then
            echo "Creating directory: $target_dir"
            mkdir -p "$target_dir"
            log_link "dir" "$target_dir"
        fi
        
        create_symlink "$file" "$target_path"
        
    done < <(find "$config_dir" -type f -print0)
    
    echo "Dotfiles setup complete!"
}

# Check if being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Being executed directly
    setup_dotfiles
else
    # Being sourced - just define the function
    echo "Dotfiles setup function loaded. Run 'setup_dotfiles' to configure."
fi