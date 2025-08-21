#!/bin/bash

# GitHub SSH Key Generator Script for macOS
# This script helps generate and set up SSH keys for GitHub authentication on macOS
# 
# Usage: ./github-ssh.sh [--help]
#
# Features:
# - Detects existing SSH keys
# - Generates new Ed25519 keys with custom names
# - Sets up SSH config for GitHub with Keychain integration
# - Automatic clipboard copying with pbcopy
# - macOS Keychain integration
# - Tests SSH connection to GitHub

set -e  # Exit on any error

# Show usage information
show_help() {
    echo "GitHub SSH Key Setup Script for macOS"
    echo ""
    echo "This script will help you:"
    echo "  • Check for existing SSH keys"
    echo "  • Generate new Ed25519 SSH keys for GitHub"
    echo "  • Configure SSH with macOS Keychain integration"
    echo "  • Copy keys to clipboard with pbcopy"
    echo "  • Test the connection to GitHub"
    echo ""
    echo "Usage: $0 [--help]"
    echo ""
    echo "Options:"
    echo "  --help    Show this help message"
    echo ""
    echo "Requirements:"
    echo "  • macOS with standard SSH tools"
    echo "  • Internet connection for GitHub"
    echo ""
    echo "The script will guide you through the process interactively."
    exit 0
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ ${1}${NC}"
}

print_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ ${1}${NC}"
}

print_error() {
    echo -e "${RED}✗ ${1}${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to validate email format
validate_email() {
    local email="$1"
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to secure SSH directory permissions
secure_ssh_directory() {
    local ssh_dir="$HOME/.ssh"
    
    # Create .ssh directory if it doesn't exist
    mkdir -p "$ssh_dir"
    
    # Set proper permissions
    chmod 700 "$ssh_dir"
    
    # Secure any existing key files
    if ls "$ssh_dir"/*.pub >/dev/null 2>&1; then
        chmod 644 "$ssh_dir"/*.pub
    fi
    if ls "$ssh_dir"/id_* >/dev/null 2>&1; then
        chmod 600 "$ssh_dir"/id_*
    fi
}

# Function to check dependencies (macOS-specific)
check_dependencies() {
    print_info "Checking macOS dependencies..."

    local missing_deps=()

    # Check for essential SSH tools
    if ! command_exists ssh-keygen; then
        missing_deps+=("ssh-keygen (install with: brew install openssh)")
    fi

    if ! command_exists ssh-add; then
        missing_deps+=("ssh-add (install with: brew install openssh)")
    fi

    if ! command_exists ssh; then
        missing_deps+=("ssh (install with: brew install openssh)")
    fi

    # Check for text processing tools
    if ! command_exists grep; then
        missing_deps+=("grep (should be available on macOS)")
    fi

    if ! command_exists sed; then
        missing_deps+=("sed (should be available on macOS)")
    fi

    # Check for macOS clipboard utility
    if ! command_exists pbcopy; then
        missing_deps+=("pbcopy (should be available on macOS)")
    fi

    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_success "All dependencies are available"
        return 0
    else
        print_error "Missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        print_info "Please install the missing dependencies and run this script again."
        exit 1
    fi
}

# Function to check for existing SSH keys and handle user choice
check_and_handle_existing_keys() {
    print_info "Checking for existing SSH keys..."
    
    local ssh_dir="$HOME/.ssh"
    local existing_keys=()
    
    if [ -d "$ssh_dir" ]; then
        # Common SSH key names
        local key_types=("id_rsa" "id_ecdsa" "id_ed25519")
        
        for key_type in "${key_types[@]}"; do
            if [ -f "$ssh_dir/$key_type" ] && [ -f "$ssh_dir/$key_type.pub" ]; then
                existing_keys+=("$key_type")
            fi
        done
    fi
    
    # If no existing keys found, return to continue with new key generation
    if [ ${#existing_keys[@]} -eq 0 ]; then
        print_info "No existing SSH keys found."
        return 1  # Signal to generate new key
    fi
    
    # Handle existing keys
    while true; do
        print_warning "Found existing SSH keys:"
        echo ""
        for i in "${!existing_keys[@]}"; do
            local key="${existing_keys[$i]}"
            local pub_key_path="$ssh_dir/$key.pub"
            local key_info=$(ssh-keygen -l -f "$pub_key_path" 2>/dev/null || echo "Unable to read key info")
            echo "  $((i+1)). $key ($key_info)"
        done
        
        echo ""
        echo "What would you like to do?"
        echo "1) Use an existing key"
        echo "2) Generate a new key"
        echo "3) Exit"
        
        read -p "Enter your choice (1-3): " choice
        case $choice in
            1)
                select_existing_key "${existing_keys[@]}"
                return 0  # Successfully used existing key
                ;;
            2)
                return 1  # Signal to generate new key
                ;;
            3)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

# Function to select and copy existing key
select_existing_key() {
    local existing_keys=("$@")
    
    echo ""
    print_info "Select a key to use:"
    for i in "${!existing_keys[@]}"; do
        echo "  $((i+1)). ${existing_keys[$i]}"
    done
    
    while true; do
        read -p "Enter key number (1-${#existing_keys[@]}): " key_num
        if [[ "$key_num" =~ ^[0-9]+$ ]] && [ "$key_num" -ge 1 ] && [ "$key_num" -le "${#existing_keys[@]}" ]; then
            local selected_key="${existing_keys[$((key_num-1))]}"
            local pub_key_path="$HOME/.ssh/$selected_key.pub"
            
            print_info "Selected key: $selected_key"
            copy_key_to_clipboard "$pub_key_path"
            create_ssh_config "$selected_key"
            wait_for_github_setup
            test_ssh_connection
            exit 0
        else
            print_error "Invalid selection. Please enter a number between 1 and ${#existing_keys[@]}."
        fi
    done
}

# Function to get user input securely
get_user_input() {
    local prompt="$1"
    local is_password="$2"
    local input=""
    
    if [ "$is_password" = "true" ]; then
        while true; do
            read -p "$prompt: "$'\n' -s input
            if [ -z "$input" ]; then
                print_warning "Password cannot be empty. Please try again."
                continue
            fi
            read -p "Confirm password: "$'\n' -s confirm_input
            if [ "$input" = "$confirm_input" ]; then
                break
            else
                print_error "Passwords don't match. Please try again."
            fi
        done
    else
        read -p "$prompt: " input
    fi
    
    echo "$input"
}

# Function to generate new SSH key
generate_new_key() {
    echo ""
    print_info "Generating a new SSH key..."
    
    # Get email with validation
    local email
    while true; do
        email=$(get_user_input "Enter your GitHub email address" false)
        
        if [ -z "$email" ]; then
            print_error "Email address is required."
            continue
        fi
        
        if validate_email "$email"; then
            break
        else
            print_error "Invalid email format. Please enter a valid email address."
        fi
    done
    
    # Get key name
    local key_name
    while true; do
        read -p "Enter a name for your SSH key (default: id_ed25519): " key_name
        
        # Use default if empty
        if [ -z "$key_name" ]; then
            key_name="id_ed25519"
        fi
        
        # Validate key name (no spaces, special characters that could cause issues)
        if [[ "$key_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            break
        else
            print_error "Key name can only contain letters, numbers, underscores, and hyphens."
        fi
    done
    
    local key_path="$HOME/.ssh/$key_name"
    
    # Get passphrase
    print_info "Enter a passphrase for your SSH key (recommended for security):"
    local passphrase
    passphrase=$(get_user_input "Enter passphrase" true)
    
    # Check if key already exists
    if [ -f "$key_path" ]; then
        print_warning "Key $key_name already exists!"
        read -p "Do you want to overwrite it? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            print_info "Exiting without creating new key."
            exit 0
        fi
    fi
    
    # Secure SSH directory and permissions
    secure_ssh_directory
    
    # Generate the key
    print_info "Generating Ed25519 SSH key..."
    if [ -n "$passphrase" ]; then
        if ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N "$passphrase" >/dev/null 2>&1; then
            print_success "SSH key generated successfully!"
        else
            print_error "Failed to generate SSH key."
            exit 1
        fi
    else
        if ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N "" >/dev/null 2>&1; then
            print_success "SSH key generated successfully!"
        else
            print_error "Failed to generate SSH key."
            exit 1
        fi
    fi
    
    # Set proper permissions on the new key files
    chmod 600 "$key_path"
    chmod 644 "$key_path.pub"
    
    # Add key to ssh-agent
    add_key_to_agent "$key_path"
    
    copy_key_to_clipboard "$key_path.pub"
    create_ssh_config "$key_name"
}

# Function to add key to SSH agent with macOS Keychain integration
add_key_to_agent() {
    local key_path="$1"
    
    print_info "Adding key to ssh-agent and macOS Keychain..."
    
    # Start ssh-agent if not running
    if [ -z "$SSH_AGENT_PID" ]; then
        eval "$(ssh-agent -s)" >/dev/null 2>&1
    fi
    
    # Add key with macOS Keychain integration
    if ssh-add --apple-use-keychain "$key_path" >/dev/null 2>&1; then
        print_success "Key added to ssh-agent and macOS Keychain"
    else
        print_warning "Failed to add to Keychain, trying without Keychain..."
        if ssh-add "$key_path" >/dev/null 2>&1; then
            print_success "Key added to ssh-agent (without Keychain)"
        else
            print_error "Failed to add key to ssh-agent"
        fi
    fi
}

# Function to create or update SSH config
create_ssh_config() {
    local key_name="$1"
    local ssh_config="$HOME/.ssh/config"
    local key_path="$HOME/.ssh/$key_name"
    
    print_info "Setting up SSH config..."
    
    # Create SSH config if it doesn't exist
    if [ ! -f "$ssh_config" ]; then
        print_info "Creating SSH config file..."
        touch "$ssh_config"
        chmod 600 "$ssh_config"
    fi
    
    # Check if GitHub host already exists in config
    if grep -q "Host github.com" "$ssh_config"; then
        print_warning "GitHub host already exists in SSH config."
        read -p "Do you want to update it to use the new key? (y/N): " update_config
        if [[ "$update_config" =~ ^[Yy]$ ]]; then
            # Remove existing GitHub host configuration
            sed -i.bak '/Host github.com/,/^$/d' "$ssh_config" 2>/dev/null || true
        else
            print_info "Skipping SSH config update."
            return 0
        fi
    fi
    
    # Add GitHub host configuration with macOS optimizations
    {
        echo ""
        echo "Host github.com"
        echo "  HostName github.com"
        echo "  AddKeysToAgent yes"
        echo "  UseKeychain yes"
        echo "  IdentityFile $key_path"
    } >> "$ssh_config"
    
    print_success "SSH config updated successfully!"
    print_info "Added GitHub host configuration using key: $key_name"
}

# Function to copy key to clipboard (macOS)
copy_key_to_clipboard() {
    local pub_key_path="$1"
    
    if cat "$pub_key_path" | pbcopy; then
        print_success "Public key copied to clipboard!"
    else
        print_warning "Failed to copy to clipboard, but here's your public key:"
        echo ""
        cat "$pub_key_path"
        echo ""
    fi
    
    print_info "Add this key to your GitHub account at: https://github.com/settings/ssh/new"
}

# Function to wait for GitHub setup confirmation
wait_for_github_setup() {
    echo ""
    print_info "Please add the SSH key to your GitHub account:"
    echo "1. Go to https://github.com/settings/ssh/new"
    echo "2. Paste the key from your clipboard"
    echo "3. Give it a descriptive title"
    echo "4. Click 'Add SSH key'"
    echo ""
    
    while true; do
        read -p "Have you added the key to GitHub? (y/N): " added
        if [[ "$added" =~ ^[Yy]$ ]]; then
            break
        else
            print_info "Please add the key to GitHub before continuing."
        fi
    done
}

# Function to test SSH connection
test_ssh_connection() {
    print_info "Testing SSH connection to GitHub..."
    echo ""
    
    # Test the connection
    ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1 | while read line; do
        echo "  $line"
    done
    
    local exit_code=${PIPESTATUS[0]}
    
    if [ $exit_code -eq 1 ] || [ $exit_code -eq 0 ]; then
        # Exit code 1 is actually success for GitHub SSH test
        print_success "SSH connection to GitHub successful!"
        print_info "You can now use SSH to interact with GitHub repositories."
    else
        print_error "SSH connection failed. Please check your key setup."
        print_info "You may need to:"
        echo "  - Verify the key was added to GitHub correctly"
        echo "  - Check your network connection"
        echo "  - Try running: ssh -T git@github.com"
    fi
}

# Main function
main() {
    # Handle command line arguments
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_help
    fi
    
    echo "=================================="
    echo "  GitHub SSH Key Setup Script"
    echo "=================================="
    echo ""
    
    # Check dependencies
    check_dependencies
    
    # Check for existing keys and handle user choice
    if check_and_handle_existing_keys; then
        # User chose to use existing key, function handled everything
        exit 0
    fi
    # User chose to generate new key or no existing keys found, continue below
    
    # Generate new key
    generate_new_key
    wait_for_github_setup
    test_ssh_connection
    
    print_success "Setup complete! Your SSH key is ready to use with GitHub."
    
    # Show macOS-specific summary
    echo ""
    echo "=================================="
    echo "  macOS Setup Summary"
    echo "=================================="
    print_success "SSH key generated and configured"
    print_success "Key added to ssh-agent and macOS Keychain"
    print_success "SSH config updated with Keychain integration"
    print_success "Key copied to clipboard with pbcopy"
    print_success "GitHub connection tested"
    echo ""
    print_info "You can now clone repositories using SSH:"
    echo "  git clone git@github.com:username/repository.git"
    echo ""
    print_info "Your key will automatically load from Keychain on future uses!"
}

# Run main function
main "$@"
