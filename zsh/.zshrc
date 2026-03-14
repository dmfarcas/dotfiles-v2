# ===== History =====
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# ===== Vi mode =====
bindkey -v
export KEYTIMEOUT=1

# ===== Path =====
export PATH="$HOME/.local/bin:$PATH"

# ===== Aliases =====
alias zox="zoxide"
alias ls="eza --icons"
alias ll="eza -la --icons"
alias cat="bat --style=plain"

# bat is installed as batcat on Ubuntu - create alias if needed
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    alias bat="batcat"
    alias cat="batcat --style=plain"
fi

# fd is installed as fdfind on Ubuntu - create alias if needed
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    alias fd="fdfind"
fi

# ===== Git shortcuts =====
alias gst="git status"

# ===== FZF =====
if command -v fzf &>/dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
    source /usr/share/fzf/key-bindings.zsh 2>/dev/null || true
    # Ctrl+R for fuzzy history search
    bindkey '^R' fzf-history-widget
fi

# ===== Zoxide (smart cd) =====
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ===== NVM =====
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ===== Zsh plugins (installed via apt) =====
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true

# ===== Prompt =====
# Simple prompt with git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f%F{yellow}${vcs_info_msg_0_}%f %# '
