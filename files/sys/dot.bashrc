#!/bin/bash

# | ~/.bashrc | v. 10.5.0 | 10.31.24 | Ubuntu - WSL2


# G0dking Shell Functions

error() {
        echo -e "${red}Error${nc}: $1" >/dev/stderr
        return 1
}

src_file() {
    source $1 || error "Could not initialize $1."
}

start_init() {
	local index=$HOME/g0dking/files/config/cmd_index

	source $index

    alias c='clear'
    alias up='sudo apt update && sudo apt full-upgrade -y'

	export EDITOR="code"
	export VISUAL="code"

    [[ $- != *i* ]] && return

    base_dir=$HOME/g0dking
    config_dir=$base_dir/files/config
    functions_dir=$base_dir/functions

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
    __conda_setup="$('/home/seed/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
 export PATH="/home/seed/miniconda3/bin:$PATH"
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
        Colors
        Network
        Prompt
        Secrets
    	Variables
    )

    	echo
        echo -e "${red}Initializing ${purple}G0DKING${red} Shell${nc}"
    	for var in ${vars[@]}; do
        	if [[ ! -z "$set_dns_complete" ]]; then
               		echo -e "    ${yellow}${var}${nc}"
    	    		sleep 0.3
		    fi
	    done

        if command -v nvm >&/dev/null; then
            echo
            echo -e "   ${blue}Node Version Manager${nc}"
            sleep 0.3
        fi

        if command -v conda >&/dev/null; then
            echo -e "   ${blue}Miniconda${nc}"
            sleep 0.3
        fi

		local test_cmd="ssh -T git@github.com"
		if command -v "$test_cmd" >&/dev/null; then
			echo -e "   ${blue}GitHub${nc}"
			sleep 0.3
		fi

        echo
	    echo -e "${green}Environment Initialized${nc}"
		echo -e "Logged in as ${yellow}$USER${nc}"
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
_miniconda
ssh_github
initial_load_output


