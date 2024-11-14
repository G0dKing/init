#!/bin/bash

# | ~/.bashrc | v. 11.0 | 11.13.24 | Ubuntu - WSL2

# G0dking Shell Functions

error() {
    echo -e "${red}Error${nc}: $1" >/dev/stderr
    return 1
}

env_update() {
    env_dir=$HOME/g0dking

    clear
    echo -e "${red}G0DKING SHELL ENVIRONMENT${nc}"
    echo -e "${purple}Alex Pariah${nc}"
    echo
    echo -e "${yellow}Initializing...${nc}"
    echo

    echo -e "${yellow}Checking for updates...${nc}"
    sudo apt update >&/dev/null || error "Could not update package repository."
    echo -e "${green}SUCCESS${nc}"
    echo
    echo -e "${yellow}Upgrading packages..."
    sudo apt full-upgrade -y >&/dev/null || error "Could not upgrade packages."
    echo -e "${green}SUCCESS${nc}"
    echo

    if [ -d "$env_dir" ]; then
        cd $env_dir
        echo -e "${yellow}Syncing environment..."
        git pull >&/dev/null || error "Could not update environment configuration."
        echo -e "${green}SUCCESS${nc}"
        echo
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

    env_update
    source $index || error "Failed to load command index."

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

<<<<<<< HEAD
    echo
    echo -e "${red}Initializing ${purple}G0DKING${red} Shell${nc}"
    sleep 0.2

    echo
    echo -e "${cyan}Loading:${nc}"
=======
    echo -e "${yellow}Applying configurations...${nc}"
    sleep 0.3
>>>>>>> 66843f672551c8dc266de2f18a649b3582c0fe75

    for var in ${vars[@]}; do
        if [[ ! -z "$set_dns_complete" ]]; then
            echo -e "    ${bold_blue}${var}${nc}"
            sleep 0.5
        fi
    done

    echo -e "${green}SUCCESS${nc}"
    echo
<<<<<<< HEAD
    echo -e "${cyan}Available Services:${nc}"
=======
    echo -e "${yellow}Loading tools & services..."
    sleep 0.3
>>>>>>> 66843f672551c8dc266de2f18a649b3582c0fe75

    if command -v nvm >&/dev/null; then
        echo -e "${bold_blue}    Node Version Manager${nc}"
        sleep 0.5
    fi

    if command -v conda >&/dev/null; then
        echo -e "${bold_blue}    Miniconda${nc}"
        sleep 0.5
    fi

    if command -v gh >&/dev/null; then
        echo -e "${bold_blue}    GitHub CLI${nc}"
        sleep 0.5
    fi

    echo -e "${green}SUCCESS${nc}"
    echo
    sleep 2
    clear
    echo -e "${yellow}Initialization Complete. Starting new shell...${nc}"
    sleep 3
    clear
}

start_init
set_colors
set_prompt
set_secrets
set_dns
_nvm
_miniconda
ssh_github
initial_load_output
