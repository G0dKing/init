#!/bin/bash

# | ~/.bashrc | v. 10.5.0 | 10.31.24 | Ubuntu - WSL2

# G0dking Shell Functions

error() {
    echo -e "${red}Error${nc}: $1" >/dev/stderr
    return 1
}

env_chk() {
    env_dir=$HOME/g0dking
    echo -e "${bold_yellow}Checking for updates..."
    sleep 0.3
    if [ -d "$env_dir" ]; then
        cd $env_dir
        git pull >&/dev/null
        cd $HOME
    fi
}

src_file() {
    source $1 || error "Could not initialize $1."
}

start_init() {

    [[ $- != *i* ]] && return

    local env_dir=$HOME/g0dking
    local index=$HOME/g0dking/files/config/cmd_index
    local config_dir=$env_dir/files/config
    local functions_dir=$env_dir/functions
    alias c='clear'

    env_chk
    source $index

    dirs=(
        $config_dir
        $functions_dir
    )

    for dir in "${dirs[@]}"; do
        for file in $dir/*.{sh,config}; do
            if [[ -e "$file" ]]; then
                src_file "$file"
            fi
        done
    done
}

_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

_miniconda() {

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/seed/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/seed/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/home/seed/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/seed/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

}

ssh_github() {
    eval "$(ssh-agent -s)" >&/dev/null
    ssh-add ~/.ssh/id_ed25519 >&/dev/null
}

initial_load_output() {
    local vars=(
        Aliases
        Shortcuts
        Network
        Themes
        Secrets
        Variables
    )

    echo
    echo -e "${red}Initializing ${purple}G0DKING${red} Shell${nc}"
    sleep 0.2

    echo
    echo -e "${bold_yellow}Loading:${nc}"

    for var in ${vars[@]}; do
        if [[ ! -z "$set_dns_complete" ]]; then
            echo -e "    ${yellow}${var}${nc}"
            sleep 0.3
        fi
    done

    echo
    echo -e "${bold_yellow}Available Services:${nc}"

    if command -v nvm >&/dev/null; then
        echo
        echo -e "${bold_blue}    Node Version Manager${nc}"
        sleep 0.3
    fi

    if command -v conda >&/dev/null; then
        echo -e "${bold_blue}    Miniconda${nc}"
        sleep 0.3
    fi

    if command -v gh >&/dev/null; then
        echo -e "${bold_blue}    GitHub${nc}"
        sleep 0.3
    fi

    echo
    echo -e "${green}SUCCESS${nc}"
    sleep 0.5
    echo -e "Logging in as:     ${red}$USER${nc}"
    sleep 1
    clear
}

start_init
set_colors
set_prompt
set_secrets
set_aliases
set_dns
_nvm
_miniconda
ssh_github
initial_load_output
