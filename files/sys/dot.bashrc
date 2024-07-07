#!/bin/bash
# | ~/.bashrc | v. 10.0.3 | 7.6.24

error() {
        echo -e "${red}Error${nc}: $1" >/dev/stderr
        return 1
}

start_init() {
    local source=${1:-"$HOME"/g0dking}
    local scripts_dir="$source"/scripts
    local config_dir="$source"/files/config
    local functions_dir="$source"/functions


    local dirs=(
	    $config_dir
	    $scripts_dir
	    $functions_dir
	)

    for file in "${dirs[@]}"*/.{sh,config}; do
        if [[ -f "$file" ]]; then
	    . $file || error "Could not initialize ${file}."
	    fi
    done

    set_colors
    set_symbols
    set_escape_codes
    set_prompt
    set_secrets
    set_aliases
    set_dns
}

pre_init() {

	alias c='clear'
	alias up='sudo apt update && sudo apt full-upgrade -y'

	[[ $- != *i* ]] && return

	func_dir=$HOME/g0dking
	start_init $func_dir
}

pre_init
