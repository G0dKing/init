#!/bin/bash

initialize() {
    local source=$1
    local is_wsl=0
    local dirs=(
        "$source/tools"
        "$source/init"
        "$source/init/wsl"
    )

    if grep -qEi '(Microsoft|WSL)' /proc/version; then
        is_wsl=1
    fi

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            for file in "$dir"/*.{sh,conf,config}; do
                [ -r "$file" ] && [ -f "$file" ] && . "$file"
            done
        elif [ "$dir" == "$source/init/wsl" ] && [ "$is_wsl" -eq 1 ]; then
            for file in "$dir"/*.{sh,conf,config}; do
                [ -r "$file" ] && [ -f "$file" ] && . "$file"
            done
        fi
    done
}


