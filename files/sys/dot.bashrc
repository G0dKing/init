#!/bin/bash

# | ~/.bashrc | v. 12.0 | 11.17.24 | Ubuntu - WSL2

# G0dking Shell Functions

error() {
    echo -e "${red}Error${nc}: $1" >/dev/stderr
    return 1
}

env_update() {
    env_dir=$HOME/g0dking

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

init_env() {
    [[ $- != *i* ]] && return

    export gk=g0dking
    alias python='/usr/bin/python3.12'

    local env_dir=$HOME/g0dking
    local config_dir=$env_dir/files/config
    local functions_dir=$env_dir/functions

	source $config_dir/cmd_index

    dirs=(
        $config_dir
        $functions_dir
    )

    for dir in "${dirs[@]}"; do
        for file in $dir/*.{sh,config}; do
            if [[ -e "$file" ]]; then
                source "$file" || error "Failed to load $file"
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

    echo -e "Applying configurations...${nc}"
    sleep 0.2

    for var in ${vars[@]}; do
        if [[ ! -z "$set_dns_complete" ]]; then
            echo -e "    ${bold_blue}${var}${nc}"
            sleep 0.3
        fi
    done

    echo -e "${green}SUCCESS${nc}"
    echo
    echo -e "Loading tools & services..."
    sleep 0.3

    if command -v nvm >&/dev/null; then
        echo -e "${bold_blue}    Node Version Manager${nc}"
        sleep 0.3
    fi

    if command -v conda >&/dev/null; then
        echo -e "${bold_blue}    Miniconda${nc}"
        sleep 0.3
    fi

    if command -v gh >&/dev/null; then
        echo -e "${bold_blue}    GitHub CLI${nc}"
        sleep 0.3
    fi

    echo -e "${green}SUCCESS${nc}"
    sleep 0.5
}

set_env() {
	set_colors
	set_prompt
	set_secrets
	set_dns
	_nvm
	_miniconda
	ssh_github
}

usrprompt_env() {
echo -n "Check for updates? (y/N): "
    read -r choice
    choice=${choice:-n}

    case $choice in
    [yY])
		echo
        env_update
        set_env
        initial_load_output
		return 0
        ;;
    [nN]|"")
		echo
		initial_load_output
        return 0
        ;;
	*)
		echo
		initial_load_output
        return 0
        ;;
    esac
}

clear
init_env
set_env
echo -e "${red}G0DKING SHELL"
echo -e "${yellow}ver. 12.0${nc}"
echo -e "${purple}Alex Pariah${nc}"
echo
usrprompt_env
echo

    if [ $USER == "root" ]; then
        color=$red
    else
        color=$purpler
    fi

echo -e "Logging in as: ${color}$USER${nc}"
sleep 3
clear
