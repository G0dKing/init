#!/bin/bash
# ~/scripts/acquire.sh
# ver. 1.0.0

# Usage: Source this script in "~/.bashrc" then execute the following command: "acquire [TARGET]"!

acquire() {
    user=$(whoami)
    target=$1
    color1=$green
    color2=$blue
    color3=$red

    if [ $# -eq 0 ]; then
        echo "Error: Unspecified Target. Pass file or directory as argument when running this script."
        return 1
    else
        if [ ! -e "$target" ]; then
            echo "Error: The file or directory does not exist."
            return 1
        else
            sudo chown -R "$user":"$user" "$target"
            sudo chmod 755 -R "$target"
            if [[ "$target" == "." ]]; then
                target=$(pwd)
            fi
            echo "Success: Permissions for $target have been been set to Public, and the Owner set to $user."
        fi
    fi
}
