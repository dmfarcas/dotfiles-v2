#!/bin/bash

# Linux Dotfiles Installation Script (Ubuntu/Debian)
# Sets up development environment with zsh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status()  { echo -e "${GREEN}[ok]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[warn]${NC} $1"; }
print_error()   { echo -e "${RED}[err]${NC} $1"; }
print_section() { echo -e "\n${BLUE}==> $1${NC}"; }

backup_existing() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
        print_warning "Backing up $target to $backup"
        mv "$target" "$backup"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    mkdir -p "$(dirname "$target")"
    backup_existing "$target"
    ln -sf "$source" "$target"
    print_status "Linked $source -> $target"
}

echo "Setting up dotfiles (Linux/zsh)..."

# ===== APT packages =====
print_section "Installing packages via apt"
sudo apt-get update -qq

apt_packages=(
    zsh
    fzf
    bat
    ripgrep
    fd-find
    jq
    zsh-autosuggestions
    zsh-syntax-highlighting
    curl
    git
    unzip
    tmux
    gcc
    build-essential
)

for pkg in "${apt_packages[@]}"; do
    if dpkg -s "$pkg" &>/dev/null; then
        print_status "$pkg already installed"
    else
        echo "Installing $pkg..."
        if sudo apt-get install -y "$pkg" &>/dev/null; then
            print_status "$pkg installed"
        else
            print_error "Failed to install $pkg"
        fi
    fi
done

# ===== eza (not in Ubuntu apt, install from GitHub) =====
print_section "Installing eza"
if command -v eza &>/dev/null; then
    print_status "eza already installed"
else
    EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | jq -r '.tag_name')
    if [ -n "$EZA_VERSION" ] && [ "$EZA_VERSION" != "null" ]; then
        ARCH=$(dpkg --print-architecture)
        curl -sLo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz"
        tar -xzf /tmp/eza.tar.gz -C /tmp
        sudo mv /tmp/eza /usr/local/bin/eza
        rm -f /tmp/eza.tar.gz
        print_status "eza installed"
    else
        print_error "Could not determine eza version - install manually"
    fi
fi

# ===== zoxide =====
print_section "Installing zoxide"
if command -v zoxide &>/dev/null; then
    print_status "zoxide already installed"
else
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    print_status "zoxide installed"
fi

# ===== git-delta =====
print_section "Installing git-delta"
if command -v delta &>/dev/null; then
    print_status "git-delta already installed"
else
    DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq -r '.tag_name')
    if [ -n "$DELTA_VERSION" ] && [ "$DELTA_VERSION" != "null" ]; then
        curl -sLo /tmp/delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
        sudo dpkg -i /tmp/delta.deb &>/dev/null && print_status "git-delta installed" || print_error "Failed to install git-delta"
        rm -f /tmp/delta.deb
    else
        print_error "Could not determine git-delta version"
    fi
fi

# ===== Neovim 0.11+ =====
print_section "Installing Neovim"
NVIM_MIN_MINOR=11
if command -v nvim &>/dev/null; then
    NVIM_VERSION=$(nvim --version | head -1 | grep -oP '\d+\.\d+')
    NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
    if [ "${NVIM_MINOR:-0}" -ge "$NVIM_MIN_MINOR" ]; then
        print_status "nvim $(nvim --version | head -1) already installed"
    else
        print_warning "nvim version too old ($NVIM_VERSION), upgrading..."
        INSTALL_NVIM=true
    fi
else
    INSTALL_NVIM=true
fi

if [ "${INSTALL_NVIM:-false}" = true ]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    # Remove old apt nvim if present
    sudo rm -f /usr/bin/nvim
    rm -f nvim-linux-x86_64.tar.gz
    print_status "nvim $(nvim --version | head -1) installed"
fi

# ===== Micro editor =====
print_section "Installing micro"
if command -v micro &>/dev/null; then
    print_status "micro already installed"
else
    curl -sL https://getmic.ro | bash
    sudo mv micro /usr/local/bin/micro
    print_status "micro installed"
fi

# ===== GitHub CLI =====
print_section "Installing GitHub CLI"
if command -v gh &>/dev/null; then
    print_status "gh already installed"
else
    curl -sS https://webi.sh/gh | bash &>/dev/null && print_status "gh installed" || print_error "Failed to install gh"
fi

# ===== NVM =====
print_section "Installing nvm"
if [ -d "$HOME/.nvm" ]; then
    print_status "nvm already installed"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    print_status "nvm installed"
fi

# Source nvm and install Node LTS
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    if ! command -v node &>/dev/null; then
        # Disable nounset temporarily - nvm has internal unbound variable issues
        set +u
        nvm install --lts
        nvm use --lts
        set -u
        print_status "Node.js $(node --version) installed"
    else
        print_status "Node.js already installed: $(node --version)"
    fi
fi

# ===== Starship =====
print_section "Installing Starship prompt"
if command -v starship &>/dev/null; then
    print_status "Starship already installed"
else
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin
    print_status "Starship installed"
fi

# ===== Oh My Zsh =====
print_section "Installing Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_status "Oh My Zsh already installed"
else
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_status "Oh My Zsh installed"
fi

# ===== Symlinks =====
print_section "Creating symlinks"

# Zsh config
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Tmux config
if [ -f "$DOTFILES_DIR/tmux/tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/tmux" "$CONFIG_DIR/tmux"
fi

# Neovim config
if [ -d "$DOTFILES_DIR/nvim" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
fi

# GitHub CLI config
if [ -d "$DOTFILES_DIR/gh" ]; then
    create_symlink "$DOTFILES_DIR/gh" "$CONFIG_DIR/gh"
fi

# ===== Set zsh as default shell =====
print_section "Setting zsh as default shell"
ZSH_PATH=$(which zsh)
if [ "$SHELL" = "$ZSH_PATH" ]; then
    print_status "zsh already default shell"
else
    if grep -q "$ZSH_PATH" /etc/shells; then
        chsh -s "$ZSH_PATH"
        print_status "zsh set as default shell"
    else
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
        chsh -s "$ZSH_PATH"
        print_status "zsh added to /etc/shells and set as default"
    fi
fi

echo ""
echo -e "${GREEN}Done! Restart your terminal or run: exec zsh${NC}"
