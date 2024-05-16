#!/bin/bash
# ~/g0dking/shell_init.sh

_init() {
    export user=$USER
    export home=$HOME
    export uid=$(id -u)
    export here=$(pwd)
    export parent=$(cd .. && pwd)
    export email=webmaster@alexpariah.com

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

    source ~/g0dking/init/colors_init.sh
    colors_init

    source ~/g0dking/init/prompt_init.sh
    setprompt

    local cmd="up"
    local cmd2="sudo nano $HOME/g0dking/init/shell_init.sh"
    local bash="sudo apt update && sudo apt full-upgrade -y"

    alias "${cmd}"="${bash}"
    editInit="${cmd2}"
}

check_init() {
    local passvar=$1
    if [[ "$passvar" -ne 1 ]]; then
        _init
        complete=1
    fi
}


initShell() {
    local complete=$1
    local passvar=$complete
    check_init $passvar
}

initShell $complete

