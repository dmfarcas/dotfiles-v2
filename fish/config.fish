if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    
    # Portable homebrew path detection
    if test (uname -m) = "arm64"
        # Apple Silicon Mac
        set -Ux fish_user_paths /opt/homebrew/bin $fish_user_paths
    else
        # Intel Mac
        set -Ux fish_user_paths /usr/local/bin $fish_user_paths
    end
end

function code
  set location "$PWD/$argv"
  open -n -b "com.microsoft.VSCode" --args $location
end

# Brew install aliases
alias claude="claude --dangerously-skip-permissions"
alias zox="zoxide"
alias ls="eza --icons"
alias ll="eza -la --icons"
alias cat="bat --style=plain"
alias md="glow"

bind \cr fzf_history

# ===== Starship prompt =====
if command -v starship &>/dev/null
    starship init fish | source
end

# ===== Tmux quick reference =====
echo "tmux  prefix=C-a │ | split-h  - split-v  c new-win  n/p next/prev  x kill │ right-click menu │ mouse on"
