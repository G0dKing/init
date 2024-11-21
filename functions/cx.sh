#!/bin/bash
#cx.sh | v. 1.0 | 11.17.24

# Copy/paste between WSL and Windows

cx() {
    local win=/mnt/c/Windows/System32

    if [ -z "$1" ]; then
        error "Specify file to copy"
        return 1
    fi

    if ! echo "$PATH" | grep -qE "(^|:)${win}(:|$)"; then
        if [ -d "$win" ]; then
            export PATH=$PATH:"$win"
        else
            error "Only available in WSL"
            return 1
        fi
    fi

    cat $1 | clip.exe
}
