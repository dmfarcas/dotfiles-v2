# ===== OS Detection & Paths =====
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - setup Homebrew
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    IS_MACOS=true
else
    # Linux
    export PATH="$HOME/.local/bin:$PATH"
    IS_LINUX=true
fi

# ===== Tmux/Zellij auto-attach =====
if [ -n "$SSH_CONNECTION" ]; then
    # Prefer zellij on Linux, tmux on macOS
    if [[ "$IS_LINUX" == true ]] && command -v zellij &>/dev/null && [ -z "$ZELLIJ" ]; then
        zellij attach main 2>/dev/null || zellij -s main
    elif command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
        tmux attach -t main 2>/dev/null || tmux new -s main
    fi
fi

# ===== Display cheatsheet (macOS only for now) =====
if [[ "$IS_MACOS" == true ]] && [ -f "$HOME/Projects/dotfiles-v2/cheatsheet.md" ] && command -v glow &>/dev/null; then
    glow "$HOME/Projects/dotfiles-v2/cheatsheet.md"
fi

# ===== Oh My Zsh =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # using starship
plugins=(git vi-mode zoxide)
source $ZSH/oh-my-zsh.sh

# ===== Fix bracketed paste issues in tmux (vi-mode + Claude Code) =====
unset zle_bracketed_paste

# ===== Aliases =====
alias claude="claude --dangerously-skip-permissions"
alias zox="zoxide"
alias z="zoxide"
alias ls="eza --icons"
alias ll="eza -la --icons"
alias cat="bat --style=plain"
alias md="glow"

# bat is installed as batcat on Ubuntu - create alias if needed
if [[ "$IS_LINUX" == true ]] && command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    alias bat="batcat"
    alias cat="batcat --style=plain"
fi

# fd is installed as fdfind on Ubuntu - create alias if needed
if [[ "$IS_LINUX" == true ]] && command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    alias fd="fdfind"
fi

# ===== FZF =====
if command -v fzf &>/dev/null; then
    if [[ "$IS_MACOS" == true ]]; then
        # Homebrew FZF on macOS
        source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" 2>/dev/null || true
        source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2>/dev/null || true
    else
        # System FZF on Linux
        source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
        source /usr/share/fzf/key-bindings.zsh 2>/dev/null || true
    fi
fi

# ===== NVM =====
export NVM_DIR="$HOME/.nvm"
if [[ "$IS_MACOS" == true ]] && [ -d "$(brew --prefix)/opt/nvm" ]; then
    # Homebrew NVM on macOS
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
else
    # Standard NVM location
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# ===== Zsh plugins (installed via apt on Linux) =====
if [[ "$IS_LINUX" == true ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true
fi

# ===== Starship prompt =====
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi
