# ===== Zellij auto-attach =====
if command -v zellij &>/dev/null && [ -z "$ZELLIJ" ] && [ -n "$SSH_CONNECTION" ]; then
    zellij attach main 2>/dev/null || zellij -s main
fi

# ===== Path =====
export PATH="$HOME/.local/bin:$PATH"

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
alias ls="eza --icons"
alias ll="eza -la --icons"
alias cat="bat --style=plain"
alias md="glow"

# bat is installed as batcat on Ubuntu - create alias if needed
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    alias bat="batcat"
    alias cat="batcat --style=plain"
fi

# fd is installed as fdfind on Ubuntu - create alias if needed
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    alias fd="fdfind"
fi

# ===== FZF =====
if command -v fzf &>/dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
    source /usr/share/fzf/key-bindings.zsh 2>/dev/null || true
fi

# ===== NVM =====
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ===== Zsh plugins (installed via apt) =====
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true

# ===== Starship prompt =====
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi
