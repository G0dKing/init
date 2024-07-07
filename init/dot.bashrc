#!/bin/bash
# | ~/.bashrc | v. 10.0.2 | 7.6.24

start_init() {
    local source=${1:-"$HOME/g0dking"}
    local init_dir=$source/init

    local files=(
	$init_dir/colors.config 
	$init_dir/prompt.config 
	$init_dir/initialize.sh
	)

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
	    . $file
	else
	    echo "Error: Could not source configuration file '"$file"'. Ensure it is present on the system, then reload the shell."
	    return 1
	fi
    done

    initialize $source
}

pre_init() {

	alias c='clear'
	alias up='sudo apt update && sudo apt full-upgrade -y'

	[[ $- != *i* ]] && return

	func_dir=$HOME/g0dking
	start_init $func_dir
}

pre_init
