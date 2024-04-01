#!/bin/bash
# ~/scripts/shell_init.sh

setup_global_vars() {
    export user=$USER
    export home=$HOME
    export uid=$(id -u)
    export here=$(pwd)
    export parent=$(cd .. && pwd)
    export email=webmaster@alexpariah.com
    return 0
}

setup_aliases() {
    alias c='clear'
    alias mkdir='mkdir -p'
    alias rm='rm -r'
    alias cp='cp -r'
    alias echo='echo -e'
    alias ls='ls --color=auto'
    alias ..='cd ..'
    alias ...='cd .. && cd ..'
    alias 00='cd /'
    alias 0='cd ~'
    return 0
}

setup_colors() {
    source ~/scripts/colors_init.sh
    colors_init
    return 0
}

setup_prompt() {
    source ~/scripts/prompt_init.sh
    prompt_init
    return 0
}

check_init() {
    if [[ "$shell_initialized" -eq 1 ]]; then
        return 0
    else
        setup_global_vars
        setup_aliases
        setup_colors
        setup_prompt
    fi
    return 0
}

shell_init() {
    check_init
    shell_initialized=1
    return 0
}

shell_init
