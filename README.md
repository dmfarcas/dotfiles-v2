# 🔧 Dotfiles

My personal configuration files for macOS and Linux development environments.

## 🚀 Quick Setup

**macOS:**
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

**Linux/Ubuntu:**
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./linux-install.sh
```

## 📦 What's Included

### Zsh Shell (`zsh/`)

- **Unified configuration** that works on macOS and Linux
- **Oh My Zsh** framework
- **Starship prompt** for a modern, fast prompt
- **Smart aliases** for common commands
- **Platform-specific optimizations**

### Neovim (`nvim/`)

- **Lazy.nvim** plugin management
- **Custom Lua configuration**
- **Language servers and tools**

### Tmux (`tmux/`)

- **Vim-style key bindings**
- **Mouse support**
- **Custom status bar**
- **Auto-attach on SSH sessions**

### GitHub CLI (`gh/`)

- **GitHub CLI configuration**
- **Custom aliases and settings**

## 🛠 Tools Automatically Installed

The setup scripts will install these essential tools:

**macOS (via Homebrew):**
- `jq`, `git-delta`, `zoxide`, `eza`, `fzf`, `gh`, `bat`
- `nmap`, `ripgrep`, `fd`, `nvm`, `tmux`, `neovim`
- `glow`, `zellij`, `starship`
- VS Code, Homerow, Ghostty

**Linux/Ubuntu (via apt + manual installs):**
- `zsh`, `fzf`, `bat`, `ripgrep`, `fd-find`, `jq`
- `tmux`, `gcc`, `build-essential`, `neovim`, `eza`
- `zoxide`, `git-delta`, `glow`, `zellij`, `starship`
- Oh My Zsh, nvm (with Node LTS)

## ⚡ Zsh Features

### Aliases (both platforms)

- `claude` → `claude --dangerously-skip-permissions`
- `z`, `zox` → `zoxide` (smart directory jumping)
- `ls` → `eza --icons`
- `ll` → `eza -la --icons`
- `cat` → `bat --style=plain`
- `md` → `glow` (markdown viewer)

### Plugins

- **Oh My Zsh**: git, vi-mode, zoxide
- **Starship**: Fast, customizable prompt
- **Linux**: zsh-autosuggestions, zsh-syntax-highlighting

### Auto-attach

- SSH sessions automatically attach to tmux/zellij
- macOS: displays cheatsheet on login

## 📁 Directory Structure

```
dotfiles/
├── zsh/                 # Zsh shell configuration
│   └── .zshrc          # Unified config (macOS + Linux)
├── nvim/                # Neovim configuration
│   ├── init.lua         # Main config
│   └── lua/             # Lua modules
├── tmux/                # Tmux configuration
│   └── tmux.conf       # Tmux settings
├── gh/                  # GitHub CLI config
├── zellij/              # Zellij config
├── fish/                # Legacy Fish config
├── install.sh           # macOS installation script
├── linux-install.sh     # Linux installation script
├── setup-github.sh      # GitHub setup helper
└── README.md           # This file
```

## 🔄 Keeping Updated

```bash
# Pull latest changes
git pull

# Re-run install if needed (macOS)
./install.sh

# Or for Linux
./linux-install.sh
```

## 🌟 Features

- ✅ **Cross-platform**: Works on macOS and Linux
- ✅ **Automated setup**: One command installation
- ✅ **Version controlled**: Track changes to your configs
- ✅ **Modular**: Easy to customize and extend
- ✅ **Documented**: Clear instructions and comments
- ✅ **Zsh-based**: Unified shell experience across platforms

## 🤝 Contributing

Feel free to fork and customize for your own use! If you have improvements or suggestions, pull requests are welcome.

## 📝 License

MIT License - feel free to use however you'd like!
