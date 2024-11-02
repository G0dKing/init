#!/bin/bash

# new_cmd | v.1.0 | 10.30.2024

# Add custom commands to a persistent configuration file across systems.
# Usage: new_cmd [NAME] [SYNTAX] | [-FLAG (-d, -h)] [DESCRIPTION]

# Main Function
new_cmd() {
    local cmd_name="$1"
    local cmd_syntax="$2"
    local flag="$3"
    local cmd_info=""
    local cmd_index="$HOME/g0dking/files/config/cmd_index"
	local help_msg="Usage: new_cmd [NAME] [SYNTAX] | [-FLAG (-d, -h)] [DESCRIPTION]"

	# Validate 'Error' Function
	if ! declare -f error > /dev/null; then
        error() {
            echo -e "${red}Local Error${nc}: $1" >/dev/stderr
            return 1
        }
    fi

    # Prompt User Input if No Arguments
    if [ $# -eq 0 ]; then
        echo -e "${yellow}Enter a name for the alias:${nc}"
        read cmd_name
        echo -e "${yellow}Enter the command executed by this alias:"
        read cmd_syntax
        echo -e "${yellow}Enter a description for the alias:"
        read cmd_info
        echo
    fi

    # Validate Variables
    if [ -z "$cmd_name" ]; then
        error "Must include the name of the alias."
        return 1
    fi

    if [ -z "$cmd_syntax" ]; then
        error "Must include the syntax of the aliased command."
        return 1
    fi

    # Check Flags
    case "$flag" in
        "-d") cmd_info="$4" ;;
		"-h") echo -e "$help_msg" ;;
		"") ;;
        *) error "The specified flag is not valid." && return 1 ;;
    esac

    # Generate Label
    local cmd_label="# ${cmd_info:-$cmd_name}"

	if [ ! -f "$cmd_index" ]; then
		error "The command index cannot be found. Ensure it exists within the correct directory, then try again."
		return 1
	fi

	# Apply the Changes, and Refresh
	{
        printf "%s\n" "$cmd_label"
        printf "alias %s='%s'\n" "$cmd_name" "$cmd_syntax"
        echo
    } >> "$cmd_index" || { error "Could not update the command index. No changes were made."; return 1; }

    if ! source "$cmd_index"; then
        error "Could not source the command index. Manually reload the shell to apply changes."
		echo
        return 0
    fi

    echo -e "${yellow}Custom alias ${blue}${cmd_name}${yellow} has been added to the command index!${nc}"
}
