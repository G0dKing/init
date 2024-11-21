#!/bin/bash

# | ~/.bashrc | v. 12.5 | 11.21.24 | Ubuntu - WSL2

# G0dking Shell

# Functions
error() {
    echo -e "${red}Error${nc}: $1" >&/dev/stderr
    return 1
}

success() {
    echo -e "${green}SUCCESS${nc}"
    echo
    sleep 0.5
}

isInstalled() {
    if command -v $1 >&/dev/null; then
       echo -e "${bold_blue}   $2${nc}"
       sleep 0.3
    fi
 }


env_update() {
    env_dir=$HOME/g0dking

    echo -e "Updating package respositories..."
    sudo apt update >&/dev/null && success || error "Could not update package repository."
    echo -e "Upgrading packages..."
    sudo apt full-upgrade -y >&/dev/null && success || error "Could not upgrade packages."

    if [ -d "$env_dir" ]; then
        cd $env_dir
        echo -e "Syncing environment..."
        git add . >&/dev/null
        git commit -m "Synced on Startup" >&/dev/null
        git branch sync >&/dev/null
        git checkout sync >&/dev/null
        git push origin sync >&/dev/null || error "Could not sync with remote repo."
        git pull origin main >&/dev/null && success || error "Could not update environment configuration."
        cd $HOME
    fi
}

init_env() {
    [[ $- != *i* ]] && return

    export gk=g0dking
    local env_dir=$HOME/g0dking
    local config_dir=$env_dir/files/config
    local functions_dir=$env_dir/functions

	source $config_dir/cmd_index
    alias python='/usr/bin/python3.12'

    dirs=(
        $config_dir
        $functions_dir
    )

    for dir in "${dirs[@]}"; do
        for file in $dir/*.{sh,config,conf}; do
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

ssh_init() {
    eval "$(ssh-agent -s)" >&/dev/null
    ssh-add ~/.ssh/id_ed25519 >&/dev/null
    ssh-add ~/.ssh/id_rsa >&/dev/null
}

initial_load_output() {
    local vars=(
        Aliases
        Automations
        Background Processes
        Command Index
        Color Scheme
        Functions
        Global Variables
        Network Configurations
        Scripts
        Secrets
        Symbolic Links
        User Prompt
    )

    echo -e "Applying configurations..."
    sleep 0.2

    for var in ${vars[@]}; do
        if [[ ! -z "$set_dns_complete" ]]; then
            echo -e "    ${bold_blue}${var}${nc}"
            sleep 0.3
        fi
    done

    success

    echo -e "Loading tools & services..."
    sleep 0.3

    isInstalled docker Docker
    isInstalled gh "GitHub CLI"
    isInstalled conda Miniconda
    isInstalled nvm "Node Version Manager"
    isInstalled ollama Ollama
    local py_ver=$(python --version)
    isInstalled python3 $py_ver
}

set_env() {
	set_colors
	set_prompt
	set_secrets
	set_dns
	_nvm
	_miniconda
	ssh_init
}

usrprompt_env() {
echo -n "Check for updates? (y/N): "
    read -r choice
    choice=${choice:-n}

    case $choice in
    [yY])
		echo
        env_update
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
echo -e "${yellow}ver. 12.5${nc}"
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
