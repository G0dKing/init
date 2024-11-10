#!/bin/bash

# new_cmd | v.1.5 | 11.10.2024

# Add custom commands to a persistent configuration file across systems.
# Usage: 'new_cmd [ALIAS] [CMD] --[OPTION] [INPUT]'

# Main Function
new_cmd() {

    # Initialization
    local cmd_name="$1"
    local cmd_syntax="$2"
    local cmd_flag="$3"
    local cmd_label="# ${cmd_info:-$cmd_name}"
    local cmd_info=""
    local cmd_index="$HOME/g0dking/files/config/cmd_index"

    # Help Menu
    help_msg() {
        echo "Usage: new_cmd [ALIAS] [COMMAND] | [FLAG] [ARG]"
        echo "[Flags]"
        echo "-------"
        echo "[-e  --edit] = Manually edit index file"
        echo "[-d  --label] = Add description"
        echo "[-h  --help] = Show help menu"
        echo "[-l  --list] = Display command index"
        echo
    }

    # Show Index
    show_index() {
        if [ -f "$cmd_index" ] && [ ! -z "$cmd_index" ]; then
            cat "$cmd_index"
            return 0
        else
            error "Command index file is missing or corrupt."
            return 1
        fi
    }

    # Edit Entry
    edit_entry() {
        nano $cmd_index
    }

    # Prompt for User Input
    if [ $# -eq 0 ]; then
        echo -e "Enter a name for the alias:"
        read cmd_name
        echo -e "Enter the command executed by this alias:"
        read cmd_syntax
        echo -e "(Optional) Enter a description for the alias:"
        read cmd_info
        echo
    fi

    # Validate Arguments
    if [[ "$1" != "-l" ]] && [[ "$1" != "--list" ]]; then

        case "$cmd_flag" in
        "-d" | "--label") cmd_info="$4" ;;
        "-h" | "--help") help_msg ;;
        "-l" | "--list") show_index ;;
        "-e" | "--edit") edit_entry ;;
        "") ;;
        *) error "Invalid argument: $cmd_flag" && return 1 ;;
        esac

        if [ -z "$cmd_name" ]; then
            error "Must specify an alias."
            return 1
        fi

        # Manually Edit Index
        if [ $cmd_name == "-e" ] || [ $cmd_name == "--edit"]; then
            edit_entry
            return 0
        fi

        # Error Checking
        if [ -z "$cmd_syntax" ]; then
            error "Must specify a Bash command."
            return 1
        fi
        if ! command -v "$cmd_syntax" >/dev/null; then
            error "There is a problem with the specified Bash command. Check syntax and try again."
            return 1
        fi

        # Add Entry to Command Index File
        {
            printf "%s\n" "$cmd_label"
            printf "alias %s='%s'\n" "$cmd_name" "$cmd_syntax"
            echo
        } >>"$cmd_index" || {
            error "Failed to update command index."
            return 1
        }

        # Output on Success
        echo -e "${green}Success!"
        echo -e "${blue}${cmd_name}${nc} has been added to the command index."

        if ! source "$cmd_index"; then
            echo "Reload the shell to apply changes."
            echo
        fi

        return 0

    else
        # List Output
        show_index
        return 0
    fi
}
