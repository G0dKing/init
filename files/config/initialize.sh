#!/bin/bash
# initialize.sh | v. 1.0 | 11.24.24

# Automates the intialization of the G0DKING shell environment
# To use, source this file, then call the functions in ~/.bashrc

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
    source /etc/os-release
    export ID=$ID

    export gk=g0dking
    alias python='/usr/bin/python3.12'

    local env_dir=$HOME/g0dking
    local config_dir=$env_dir/files/config
    local functions_dir=$env_dir/functions
    local check_tools=$HOME/g0dking/files/config/check_tools.sh

    source $check_tools
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

finish_init() {
    if [ $USER == "root" ]; then
        color=$red
    else
        color=$blue
    fi

    echo
    echo -e "Logging in as: ${color}$USER${nc}"
    echo -e "${green}SUCCESS${nc}"
    echo
    echo -e "Press Enter"
    read -r
    clear
}

title_env() {
    echo -e "${red}G0DKING SHELL"
    echo -e "${yellow}ver. 12.0${nc}"
    echo -e "${purple}Alex Pariah${nc}"
    echo
}

load_env() {
    init_env
    set_env
    finish_init
}

apply() {
    title_env
    echo -n "Check for updates? (y/N): "
    read -r choice
    choice=${choice:-n}

    case $choice in
    [yY])
        env_update
        load_env
        initial_load_output
        ;;
    [nN]|"")
        load_env
        ;;
	*)
        load_env
        ;;
    esac
}