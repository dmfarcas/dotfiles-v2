function fzf_history
    set -l selected (history | fzf --height 40% --reverse --border --preview 'echo {}')
    if test -n "$selected"
        commandline -r $selected
    end
end
