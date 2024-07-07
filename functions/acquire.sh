#!/bin/bash

acquire() {
    local user=$(whoami)
    local target=$1

    if [ -z "$target" ] || [ "$target" == "." ]; then
        target=$(pwd)
    fi

    if [ ! -e "$target" ]; then
        echo "${red}Error${nc}: The file or directory does not exist."
        return 1
    fi

    sudo chown -R "$user":"$user" "$target"
    sudo chmod 755 -R "$target"
    echo
    echo -e "   ${green}SUCCESS${nc}: ${yellow}Permissions for ${red}$target${yellow} have been set.${nc}"
    echo
}
