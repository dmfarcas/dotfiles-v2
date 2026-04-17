#!/bin/bash

# Dotfiles Installation Script
# Automatically sets up development environment on macOS with zsh

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

# Function to run command with error handling
run_with_error_handling() {
    local description="$1"
    shift
    
    if "$@"; then
        print_status "$description"
        return 0
    else
        print_error "Failed: $description - skipping and continuing..."
        return 1
    fi
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
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        # Add to PATH for current session
        export PATH="$(dirname "$BREW_PATH"):$PATH"
        print_status "Homebrew installed successfully"
    else
        print_error "Failed to install Homebrew - skipping package installations"
        HOMEBREW_FAILED=true
    fi
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
    "nmap"
    "ripgrep"
    "fd"
    "nvm"
    "tmux"
    "neovim"
    "glow"
    "zellij"
    "starship"
)

echo "📦 Installing essential packages..."
if [ "$HOMEBREW_FAILED" = true ]; then
    print_warning "Skipping package installation due to Homebrew failure"
else
    for package in "${packages[@]}"; do
        if brew list "$package" &>/dev/null; then
            print_status "$package already installed"
        else
            echo "Installing $package..."
            if ! brew install "$package"; then
                print_error "Failed to install $package - continuing with next package"
            else
                print_status "$package installed successfully"
            fi
        fi
    done
fi

# Install VS Code if not present
if [ "$HOMEBREW_FAILED" = true ]; then
    print_warning "Skipping VS Code installation due to Homebrew failure"
elif ! brew list --cask visual-studio-code &>/dev/null; then
    echo "💻 Installing Visual Studio Code..."
    if brew install --cask visual-studio-code; then
        print_status "VS Code installed"
    else
        print_error "Failed to install VS Code - skipping VS Code setup"
        VSCODE_FAILED=true
    fi
else
    print_status "VS Code already installed"
fi

# Ensure VS Code command line tool is available
if [ "$VSCODE_FAILED" != true ] && ! command -v code &> /dev/null; then
    echo "🔧 Setting up VS Code command line tool..."
    
    # Check if VS Code app exists
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        # Add symlink to make 'code' command available
        if sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code; then
            print_status "VS Code command line tool configured"
        else
            print_error "Failed to set up VS Code command line tool - you may need to do this manually"
        fi
    else
        print_warning "VS Code app not found in /Applications - you may need to manually install the command line tools"
        echo "You can do this by opening VS Code and running 'Shell Command: Install code command in PATH' from the command palette"
    fi
elif [ "$VSCODE_FAILED" != true ]; then
    print_status "VS Code command line tool already available"
fi

# Install Homerow if not present
if [ "$HOMEBREW_FAILED" = true ]; then
    print_warning "Skipping Homerow installation due to Homebrew failure"
elif ! brew list --cask homerow &>/dev/null; then
    echo "⌨️  Installing Homerow..."
    if brew install --cask homerow; then
        print_status "Homerow installed"
    else
        print_error "Failed to install Homerow - continuing with script"
    fi
else
    print_status "Homerow already installed"
fi

# Install Ghostty if not present
if [ "$HOMEBREW_FAILED" = true ]; then
    print_warning "Skipping Ghostty installation due to Homebrew failure"
elif ! brew list --cask ghostty &>/dev/null; then
    echo "👻 Installing Ghostty terminal..."
    if brew install --cask ghostty; then
        print_status "Ghostty installed"
    else
        print_error "Failed to install Ghostty - continuing with script"
    fi
else
    print_status "Ghostty already installed"
fi

# Additional GUI applications (casks)
echo "📱 Installing additional applications..."

gui_apps=(
    # Browsers
    "brave-browser"
    "firefox"
    "google-chrome"
    
    # Development
    "iterm2"
    "android-studio"
    "mongodb-compass"
    
    # Design/Media
    "figma"
    "vlc"
    
    # Communication
    "slack"
    
    # Productivity
    "obsidian"
    
    # Utilities
    "virtualbox"
)

# Additional CLI tools not in main packages list
additional_cli=(
    "android-platform-tools"  # adb, fastboot
    "mitmproxy"              # HTTP/HTTPS proxy
    "ngrok"                  # Secure tunnels
)

if [ "$HOMEBREW_FAILED" = true ]; then
    print_warning "Skipping GUI apps installation due to Homebrew failure"
else
    for app in "${gui_apps[@]}"; do
        if brew list --cask "$app" &>/dev/null; then
            print_status "$app already installed"
        else
            echo "Installing $app..."
            if ! brew install --cask "$app"; then
                print_error "Failed to install $app - continuing with next app"
            else
                print_status "$app installed successfully"
            fi
        fi
    done
    
    # Install additional CLI tools
    for tool in "${additional_cli[@]}"; do
        if brew list "$tool" &>/dev/null; then
            print_status "$tool already installed"
        else
            echo "Installing $tool..."
            if ! brew install "$tool"; then
                print_error "Failed to install $tool - continuing with next tool"
            else
                print_status "$tool installed successfully"
            fi
        fi
    done
fi

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Create symlinks for configurations
echo "🔗 Creating symlinks..."

# Zsh configuration
if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

# Tmux configuration
if [ -f "$DOTFILES_DIR/tmux/tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/tmux" "$CONFIG_DIR/tmux"
fi

# Neovim configuration  
if [ -d "$DOTFILES_DIR/nvim" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
fi

# GitHub CLI configuration
if [ -d "$DOTFILES_DIR/gh" ]; then
    create_symlink "$DOTFILES_DIR/gh" "$CONFIG_DIR/gh"
fi

# Zellij configuration
if [ -d "$DOTFILES_DIR/zellij" ]; then
    create_symlink "$DOTFILES_DIR/zellij" "$CONFIG_DIR/zellij"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎨 Installing Oh My Zsh..."
    if RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
        print_status "Oh My Zsh installed"
    else
        print_error "Failed to install Oh My Zsh - continuing with script"
    fi
else
    print_status "Oh My Zsh already installed"
fi

# Set zsh as default shell if not already
current_shell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
zsh_path="/bin/zsh"

if [ "$current_shell" != "$zsh_path" ]; then
    echo "⚡ Setting zsh as default shell..."
    
    # Add zsh to /etc/shells if not already there
    if ! grep -q "$zsh_path" /etc/shells; then
        echo "Adding zsh to /etc/shells (requires sudo)..."
        if echo "$zsh_path" | sudo tee -a /etc/shells; then
            print_status "zsh added to /etc/shells"
        else
            print_error "Failed to add zsh to /etc/shells - skipping shell change"
            SHELL_CHANGE_FAILED=true
        fi
    fi
    
    # Change default shell
    if [ "$SHELL_CHANGE_FAILED" != true ]; then
        if chsh -s "$zsh_path"; then
            print_status "zsh set as default shell"
        else
            print_error "Failed to change default shell - you may need to do this manually"
        fi
    fi
else
    print_status "zsh already set as default shell"
fi

# Setup nvm and install latest Node.js
if command -v nvm &> /dev/null; then
    echo "🟢 Setting up nvm and installing latest Node.js..."
    
    # Source nvm for current session
    export NVM_DIR="$(brew --prefix nvm)"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
        
        # Install and use latest LTS Node.js
        if nvm install --lts && nvm use --lts && nvm alias default node; then
            print_status "Node.js $(node --version) installed and set as default"
        else
            print_error "Failed to install Node.js via nvm - you may need to do this manually"
        fi
    else
        print_error "nvm script not found - installation may have failed"
    fi
else
    print_warning "nvm not found in PATH, skipping Node.js setup"
fi

echo ""
echo -e "${GREEN}🎉 Dotfiles installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Customize configurations in $CONFIG_DIR"
echo ""
echo "Enjoy your new development environment! 🚀"
