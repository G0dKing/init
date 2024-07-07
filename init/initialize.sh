#!/bin/bash

error() {
	echo -e "${red}Error${nc}: $1" >/dev/stderr
	return 1
}

initialize() {
	local source=${1:-"$HOME"/g0dking}
	local init_dir=$source/init
	local wsl_dir=$init_dir/wsl
	local tools_dir=$source/tools

	local dirs=(
		$init_dir
		$wsl_dir
		$tools_dir
	)

	for file in "${dirs[@]}"/*.{sh,conf,config}; do
		if [ -f "$file" ]; then
		 . $file || error "Could not source $file."
		fi
	done
}
