#!/bin/bash
# ~/g0dking/shell_init.sh

_init() {
    export user=$USER
    export home=$HOME
    export uid=$(id -u)
    export here=$(pwd)
    export parent=$(cd .. && pwd)
    export email=webmaster@alexpariah.com
    export origin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    alias c='clear'
    alias mkdir='mkdir -p'
    alias rm='rm -rf'
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

    source ~/g0dking/tools/common.sh

    local cmd="up"
    local cmd2="nano $HOME/g0dking/init/shell_init.sh"
    local cmd3="list_common"
    local bash="sudo apt update && sudo apt full-upgrade -y"

    alias "${cmd}"="${bash}"
    alias edit_init="${cmd2}"
    alias common="${cmd3}"

    export complete=1
}

chk_if_run() {
    local complete=$1
    if [[ "$complete" -ne 1 ]]; then
        _init
    fi
}


chk_if_run $complete

