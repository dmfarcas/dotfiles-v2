# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for setting up a complete development environment on macOS (Intel/Apple Silicon) and Linux/Ubuntu. The primary use case is headless SSH/AWS environments operated via tmux.

## Setup Commands

**macOS:**
```bash
./install.sh
```

**Linux/Ubuntu:**
```bash
./linux-install.sh
```

**GitHub repository setup (after install):**
```bash
./setup-github.sh
```

**Fish config backup/restore:**
```bash
fish sync-fish-config.fish backup
fish sync-fish-config.fish restore
```

There are no build, lint, or test commands — this is a dotfiles repo, not a software project.

## Architecture

### Platform Split
- **macOS**: Uses Fish shell + Homebrew + Tide prompt. Configured via `fish/` directory and `install.sh`.
- **Linux/Ubuntu**: Uses Zsh shell + Oh My Zsh + Starship prompt. Configured via `zsh/.zshrc` and `linux-install.sh`.
- Both platforms share: Neovim (`nvim/`), tmux (`tmux/`), and GitHub CLI (`gh/`) configs.

### Symlink Model
The install scripts create symlinks from `~/.config/<tool>` (or `~/.<tool>`) pointing into this repo. Editing files here is the canonical way to change configs — no need to edit symlink targets separately.

### Neovim Plugin System
Uses [Lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. Plugin list is in `nvim/lua/core/plugins.lua`. Plugin-specific configs live in `nvim/lua/plugins/configs/`. Mason manages LSP servers (`nvim/lua/plugins/configs/lsp.lua`).

### Key Aliases (both shells)
- `claude` → `claude --dangerously-skip-permissions`
- `ls` → `eza --icons`
- `cat` → `bat --style=plain`
- `z` / `zox` → zoxide (smart directory jumping)

### Tmux
- Prefix: `Ctrl+A`
- Config: `tmux/tmux.conf`
- Auto-attaches on zsh login (in `.zshrc`): creates or reattaches to `main` session
- The cheatsheet (`cheatsheet.md`) is displayed unconditionally on shell start via `.zshrc`

### .gitignore Intent
`nvim/lazy/` (installed plugins) is ignored — only Lua config files are tracked. `fish/fish_variables` and credential files are also ignored to avoid committing machine-specific state or secrets.
