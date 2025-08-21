# Portable Fish Configuration

This setup allows you to easily transfer your fish shell configuration between different Macs (Intel and Apple Silicon).

## Files Included

- `config.fish` - Main fish configuration with portable homebrew detection
- `setup-fish-portable.fish` - Automated setup script for new machines
- `sync-fish-config.fish` - Backup and restore tool

## Quick Setup on New Mac

### Option 1: Automated Setup

1. Copy `setup-fish-portable.fish` to your new Mac
2. Make it executable: `chmod +x setup-fish-portable.fish`
3. Run: `./setup-fish-portable.fish`

### Option 2: Full Configuration Transfer

1. On your current Mac, create a backup:

   ```fish
   ./sync-fish-config.fish backup
   ```

2. Copy the generated `fish-config-backup-*.tar.gz` file to your new Mac

3. On the new Mac:
   ```fish
   tar -xzf fish-config-backup-*.tar.gz
   cd fish-config
   ./restore.fish
   ```

## Features

### Portable Homebrew Detection

- Automatically detects Apple Silicon vs Intel Mac
- Sets correct homebrew paths (`/opt/homebrew` vs `/usr/local`)

### Essential Tools Installed

- `jq` - JSON processor
- `git-delta` - Better git diffs
- `zoxide` - Smart directory jumping
- `eza` - Modern ls replacement
- `fzf` - Fuzzy finder
- `gh` - GitHub CLI
- `bat` - Better cat with syntax highlighting

### Useful Aliases

- `zox` → `zoxide`
- `ls` → `eza --icons`
- `cat` → `bat --style=plain`

### Key Bindings

- `Ctrl+R` - FZF history search

## Manual Installation Steps

If you prefer manual setup:

1. Install Homebrew (if not installed)
2. Install essential packages: `brew install jq git-delta zoxide eza fzf gh bat`
3. Install Fisher: `curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher`
4. Install plugins: `fisher install jorgebucaran/autopair.fish PatrickF1/fzf.fish`
5. Copy your `config.fish` to `~/.config/fish/config.fish`

## Troubleshooting

- If commands aren't found, restart your terminal
- If homebrew path issues, run: `source ~/.config/fish/config.fish`
- For permission issues, ensure scripts are executable with `chmod +x`
