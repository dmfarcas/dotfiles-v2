#!/bin/bash

# Dotfiles Installation Script
# Automatically sets up development environment on macOS

set -e  # Exit on any error

echo "🚀 Setting up dotfiles..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}📂 Dotfiles directory: $DOTFILES_DIR${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to backup existing config
backup_existing() {
    local target="$1"
    if [ -e "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
        print_warning "Backing up existing $(basename "$target") to $backup"
        mv "$target" "$backup"
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file/directory
    backup_existing "$target"
    
    # Create symlink
    ln -sf "$source" "$target"
    print_status "Linked $(basename "$source")"
}

# Detect system architecture
if [[ $(uname -m) == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
    print_status "Detected Apple Silicon Mac"
else
    BREW_PATH="/usr/local/bin/brew"
    print_status "Detected Intel Mac"
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to PATH for current session
    export PATH="$(dirname "$BREW_PATH"):$PATH"
else
    print_status "Homebrew already installed"
fi

# Essential packages
packages=(
    "jq"
    "git-delta" 
    "zoxide"
    "eza"
    "fzf"
    "gh"
    "bat"
    "fish"
    "nmap"
    "ripgrep"
    "fd"
    "nvm"
)

echo "📦 Installing essential packages..."
for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        print_status "$package already installed"
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Create symlinks for configurations
echo "🔗 Creating symlinks..."

# Fish configuration
if [ -d "$DOTFILES_DIR/fish" ]; then
    create_symlink "$DOTFILES_DIR/fish" "$CONFIG_DIR/fish"
fi

# Neovim configuration  
if [ -d "$DOTFILES_DIR/nvim" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
fi

# GitHub CLI configuration
if [ -d "$DOTFILES_DIR/gh" ]; then
    create_symlink "$DOTFILES_DIR/gh" "$CONFIG_DIR/gh"
fi

# Set fish as default shell if not already
current_shell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
fish_path=$(which fish)

if [ "$current_shell" != "$fish_path" ]; then
    echo "🐟 Setting fish as default shell..."
    
    # Add fish to /etc/shells if not already there
    if ! grep -q "$fish_path" /etc/shells; then
        echo "Adding fish to /etc/shells (requires sudo)..."
        echo "$fish_path" | sudo tee -a /etc/shells
    fi
    
    # Change default shell
    chsh -s "$fish_path"
    print_status "Fish set as default shell"
else
    print_status "Fish already set as default shell"
fi

# Install Fisher and fish plugins (if fish config exists)
if [ -f "$CONFIG_DIR/fish/config.fish" ]; then
    echo "🎣 Setting up fish plugins..."
    
    # Check if plugins are already present in the dotfiles
    if [ -f "$CONFIG_DIR/fish/fish_plugins" ] && [ -f "$CONFIG_DIR/fish/functions/fisher.fish" ]; then
        print_status "Fish plugins already present in dotfiles, skipping Fisher installation"
    else
        # Switch to fish and setup fisher + plugins
        fish -c "
            # Install Fisher if not present
            if not command -v fisher &>/dev/null
                curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
                fisher install jorgebucaran/fisher
            end
            
            # Install plugins from fish_plugins file
            if test -f ~/.config/fish/fish_plugins
                echo 'Installing plugins from fish_plugins file...'
                fisher update
            end
        "
        print_status "Fish plugins setup complete"
    fi
fi

# Setup nvm and install latest Node.js
if command -v nvm &> /dev/null; then
    echo "🟢 Setting up nvm and installing latest Node.js..."
    
    # Source nvm for current session
    export NVM_DIR="$(brew --prefix nvm)"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    
    # Install and use latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default node
    
    print_status "Node.js $(node --version) installed and set as default"
else
    print_warning "nvm not found in PATH, skipping Node.js setup"
fi

echo ""
echo -e "${GREEN}🎉 Dotfiles installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.config/fish/config.fish"
echo "2. Run 'fish' to start using your new shell"
echo "3. Customize configurations in $CONFIG_DIR"
echo ""
echo "Enjoy your new development environment! 🚀"
