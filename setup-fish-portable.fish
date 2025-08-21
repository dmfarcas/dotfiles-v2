#!/usr/bin/env fish

# Portable Fish Configuration Setup Script
# Run this script on a new Mac to set up your fish configuration

echo "🐟 Setting up portable fish configuration..."

# Detect system architecture and set homebrew path accordingly
if test (uname -m) = "arm64"
    set BREW_PATH "/opt/homebrew/bin"
    echo "📱 Detected Apple Silicon Mac - using /opt/homebrew"
else
    set BREW_PATH "/usr/local/bin"
    echo "💻 Detected Intel Mac - using /usr/local"
end

# Function to check if a command exists
function command_exists
    command -v $argv[1] >/dev/null 2>&1
end

# Install Homebrew if not present
if not command_exists brew
    echo "🍺 Installing Homebrew..."
    /bin/bash -c (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    
    # Add to PATH for current session
    fish_add_path $BREW_PATH
else
    echo "✅ Homebrew already installed"
end

# Essential packages to install
set packages jq git-delta zoxide eza fzf gh bat

echo "📦 Installing essential packages..."
for package in $packages
    if not command_exists $package
        echo "Installing $package..."
        brew install $package
    else
        echo "✅ $package already installed"
    end
end

# Install fisher (fish plugin manager) if not present
if not command_exists fisher
    echo "🎣 Installing Fisher (fish plugin manager)..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
else
    echo "✅ Fisher already installed"
end

# Essential fish plugins
set plugins jorgebucaran/autopair.fish PatrickF1/fzf.fish jethrokuan/fzf

echo "🔌 Installing fish plugins..."
for plugin in $plugins
    echo "Installing $plugin..."
    fisher install $plugin
end

echo "🎉 Portable fish setup complete!"
echo "💡 You may need to restart your terminal or run 'source ~/.config/fish/config.fish'"
