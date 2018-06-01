toggle_caps_esc_mapping () {
    if [ "$CAPS" == "ESC" ]; then
        dconf write /org/gnome/desktop/input-sources/xkb-options "['']";
        unset CAPS
    else
        export CAPS="ESC";
        dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']";
    fi
}

alias tmux='tmux -2'
alias capsremap=toggle_caps_esc_mapping
alias date_time_str="echo `date +%Y_%m_%d__%H_%M_%S`"
alias d="tree -L 3 -I '*.pyc|__pycache__' --dirsfirst"
