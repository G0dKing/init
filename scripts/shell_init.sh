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
    export desktop=/mnt/c/Users/Administrator/Desktop
    export downloads=/mnt/c/Users/Administrator/Downloads
    export documents=/mnt/c/Users/Administrator/Documents
    export sites_dir=/mnt/g/.dev/sites
    export redteam=/mnt/g/.dev/redteam
    export ssd_c='/mnt/c'
    export 'ssd_f'='/mnt/f'
    export 'ssd_g'='/mnt/g'
    export share_dir=/mnt/g/.share
    export win_dir=/mnt/c/Windows
    export sys32=/mnt/c/Windows/System32
    export appdata='/mnt/c/AppData'
    export admin_dir=/mnt/c/Users/Administrator
    export admin='Administrator'
    alias ..='cd ..'
    alias ...='cd .. && cd ..'
    alias 00='cd /'
    alias 0='cd ~'
    alias 1='cd /mnt/g/.dev'
    alias 2='cd /mnt/g/.dev/redteam'
    alias 3='cd /mnt/g/.dev/redteam/xerxes/2'
    alias 4='cd /mnt/g/.dev/sites'
    alias 5='cd /mnt/c'
    alias 6='cd /mnt/c/Users/Administrator/Desktop'
    alias 7='cd /mnt/c/Users/Administrator/Documents'
    alias 8='cd /mnt/c/Users/Administrator/Downloads'
    alias noted='ssh root@172.233.222.53'
    alias noted-link='ssh link@172.233.222.53'
    alias static='ssh root@172.234.207.78'
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
