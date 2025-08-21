# 🔧 Dotfiles

My personal configuration files for macOS development environment.

## 🚀 Quick Setup

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the install script
cd ~/dotfiles
./install.sh
```

## 📦 What's Included

### Fish Shell (`fish/`)

- **Portable configuration** that works on both Intel and Apple Silicon Macs
- **Smart aliases** for common commands
- **Essential plugins** via Fisher
- **Custom key bindings** and functions

### Neovim (`nvim/`)

- **Lazy.nvim** plugin management
- **Custom Lua configuration**
- **Language servers and tools**

### GitHub CLI (`gh/`)

- **GitHub CLI configuration**
- **Custom aliases and settings**

## 🛠 Tools Automatically Installed

The setup script will install these essential tools via Homebrew:

- `jq` - JSON processor
- `git-delta` - Better git diffs
- `zoxide` - Smart directory jumping
- `eza` - Modern ls replacement
- `fzf` - Fuzzy finder
- `gh` - GitHub CLI
- `bat` - Better cat with syntax highlighting

## 🐟 Fish Shell Features

### Aliases

- `zox` → `zoxide`
- `ls` → `eza --icons`
- `cat` → `bat --style=plain`

### Key Bindings

- `Ctrl+R` - FZF history search
- Vi mode enabled

### Functions

- `code` - Open current directory in VS Code

## 📁 Directory Structure

```
dotfiles/
├── fish/                 # Fish shell configuration
│   ├── config.fish      # Main configuration
│   ├── functions/       # Custom functions
│   └── completions/     # Auto-completions
├── nvim/                # Neovim configuration
│   ├── init.lua         # Main config
│   └── lua/             # Lua modules
├── gh/                  # GitHub CLI config
├── install.sh           # Installation script
├── setup-fish-portable.fish  # Fish-specific setup
└── README.md           # This file
```

## 🔄 Keeping Updated

```bash
# Pull latest changes
git pull

# Re-run install if needed
./install.sh
```

## 🎯 Manual Installation

If you prefer to install manually:

1. **Install Homebrew** (if not installed)
2. **Install packages**: `brew install jq git-delta zoxide eza fzf gh bat`
3. **Install Fisher**: `curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher`
4. **Install fish plugins**: `fisher install jorgebucaran/autopair.fish PatrickF1/fzf.fish`
5. **Symlink configs**: See `install.sh` for symlink commands

## 🌟 Features

- ✅ **Cross-platform**: Works on both Intel and Apple Silicon Macs
- ✅ **Automated setup**: One command installation
- ✅ **Version controlled**: Track changes to your configs
- ✅ **Modular**: Easy to customize and extend
- ✅ **Documented**: Clear instructions and comments

## 🤝 Contributing

Feel free to fork and customize for your own use! If you have improvements or suggestions, pull requests are welcome.

## 📝 License

MIT License - feel free to use however you'd like!
