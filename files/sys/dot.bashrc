#!/bin/bash
# | ~/.bashrc | v. 10.1.1 | 7.8.24


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

    base_dir=/home/seed/g0dking
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
        set_aliases
        set_colors
        set_prompt
        set_secrets
        set_aliases
        set_dns
    )

    for var in ${vars[@]}; do
        local full=$var_complete
        if [[ "$full" == true ]]; then
            echo -e "${blue}${var}$ Initialized${nc}" || error "${var} Failed to Initialize"
        fi
    done

}

#------------
# Execute
#------------
  start_init
  wait
  set_colors
  set_prompt
  set_secrets
  set_aliases
  set_dns
  _nvm
