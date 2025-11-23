#!/usr/bin/env bash

set -e  # Exit on error

echo "========================================="
echo "Starting system setup..."
echo "========================================="

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_status "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_status "Updating Homebrew..."
brew update

# Install packages from Brewfile
if [ -f "$(dirname "$0")/Brewfile" ]; then
    print_status "Installing packages from Brewfile..."
    brew bundle install --file="$(dirname "$0")/Brewfile"
    print_success "Packages installed from Brewfile"
else
    print_error "Brewfile not found in $(dirname "$0")"
    exit 1
fi

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Clone configuration repositories
print_status "Setting up configuration files..."

# Ghostty config
if [ -d ~/.config/ghostty ]; then
    print_status "Ghostty config already exists, skipping..."
else
    print_status "Cloning Ghostty config..."
    git clone git@github.com:JamesChung/ghostty-config.git ~/.config/ghostty
    print_success "Ghostty config cloned"
fi

# Neovim config
if [ -d ~/.config/nvim ]; then
    print_status "Neovim config already exists, skipping..."
else
    print_status "Cloning Neovim config..."
    git clone git@github.com:JamesChung/nvim-config.git ~/.config/nvim
    print_success "Neovim config cloned"
fi

# Zsh config
if [ -d ~/.zsh ]; then
    print_status "Zsh config already exists, skipping..."
else
    print_status "Cloning Zsh config..."
    git clone git@github.com:JamesChung/zsh.git ~/.zsh
    print_success "Zsh config cloned"
fi

# Symlink configuration files to home directory
print_status "Setting up configuration file symlinks..."

# Function to create symlink for a config file
symlink_config() {
    local filename="$1"
    local source="$HOME/.zsh/$filename"
    local target="$HOME/$filename"

    if [ -f "$source" ]; then
        if [ -L "$target" ]; then
            print_status "~/$filename symlink already exists, skipping..."
        elif [ -f "$target" ]; then
            print_status "Backing up existing ~/$filename to ~/${filename}.backup"
            mv "$target" "${target}.backup"
            print_status "Creating symlink for $filename..."
            ln -s "$source" "$target"
            print_success "$filename symlinked to home directory"
        else
            print_status "Creating symlink for $filename..."
            ln -s "$source" "$target"
            print_success "$filename symlinked to home directory"
        fi
    else
        print_status "$filename not found in ~/.zsh, skipping..."
    fi
}

# Symlink all dotfiles
symlink_config ".gitconfig"
symlink_config ".zprofile"
symlink_config ".zshenv"
symlink_config ".zshrc"

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    print_success "Default shell set to zsh"
else
    print_success "Zsh is already the default shell"
fi

echo ""
echo "========================================="
print_success "Setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Configure any additional settings as needed"
echo ""
