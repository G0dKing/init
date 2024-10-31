#!/bin/bash

# Easily add a custom alias to the environment, persistent across
# different systems. By default, additions are stored directly within
# this file. Additions can also be made by editing this file directly
# using a text-editor.

# Main Function
new_cmd() {
	# Define Variables
	local cmd_name=$1
	local cmd_syntax=$2
	local flag=$3
	local cmd_info=""
	local cmd_index=$HOME/g0dking/files/config/cmd_index

	# Validate User Inputs
    if [ -z "$cmd_name" ]; then
        error "Must include the name of the alias."
		return 1
    fi

    if [ -z "$cmd_syntax" ]; then
        error "Must include the syntax of the aliased command."
		return 1
    fi

	# Flags
    if [ "$flag" == "-d" ]; then
        cmd_info=$4
 	elif [ -n "$flag" ]; then
        error "The specified flag is not valid."
		return 1
    fi

	# Set Label
	local cmd_label="# ${cmd_info:-$cmd_name}"

	# Update Configuration File
	{
		echo "$cmd_label"
		echo "alias ${cmd_name}='${cmd_syntax}'"
		echo
	} >> $cmd_index || { error "Could not update the command index. No changes were made."; return 1; }

	# Refresh Command Index
	source "$cmd_index" || { error "Could not source the command index. Manually reload the shell to apply changes"; return 0; }

	# Notify User Upon Success
	echo -e "${yellow}Custom alias ${blue}${cmd_name}${yellow} has been added to the command index!${nc}"

}
