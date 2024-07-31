#!/bin/bash
# | ~/.bashrc | v. 10.1.2 | 7.10.24

error() {
        echo -e "${red}Error${nc}: $1" >/dev/stderr
        return 1
}

src_file() {
    source $1 || error "Could not initialize $1."
}

start_init() {

    alias c='clear'
    alias up='sudo apt update && sudo apt full-upgrade -y'

    [[ $- != *i* ]] && return

    base_dir=$HOME/g0dking
    wsl_dir=$base_dir/files/wsl
    config_dir=$base_dir/files/config
    functions_dir=$base_dir/functions
        
    dirs=(
         $config_dir
         $wsl_dir
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

initial_load_output() {
    local vars=(
        Aliases
        Colors
        Network
        Prompt
        Secrets
    	Variables
    )

    	echo
        echo -e "${red}Initializing...${nc}"
    	for var in ${vars[@]}; do
        	if [[ ! -z "$set_dns_complete" ]]; then
               		echo -e "    ${yellow}${var}${nc}"
    	    		sleep 0.5        
		    fi
	    done
	    echo
	    echo -e "${green}Complete${nc}"
        sleep 1
        clear
}

start_init
wait
set_colors
set_prompt
set_secrets
set_aliases
set_dns
_nvm
initial_load_output
