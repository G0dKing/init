#!/bin/bash

# Common Functions

# Check for root
_chkIfRoot() {
    local uid=$(id -u)
    if [[ "$uid" -ne 0 ]]; then
        echo "Error: Access Denied. Try again as root."
        exit 1
    fi
}

# Error Handling
_error() {
    echo "Error: $1" >&2
    return 1
}

# Logging with Timestamps
_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') : $message"
}

# Check if cmd exists
_chkCmd() {
    command -v "$1" >/dev/null 2>&1
}

# Create backup of file
_backup() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "${file}.$(date +'%Y%m%d%H%M%S').bak"
    fi
}

_yesNo() {
    local prompt="$1"
    local valid=0
    while [ $valid -eq 0 ]; do
        read -p "$prompt (y/n): " -r
        echo
        if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
            valid=1
        elif [[ $REPLY =~ ^[Nn][Oo]?$ ]]; then
            echo "Terminated by user."
            exit 1
        else
            echo "Error: Invalid input. Please enter [y]es or [n]o."
        fi
    done
}

_chkDir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
}

_validEmail() {
    local email="$1"
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Valid email address."
    else
        echo "Invalid email address."
        exit 1
    fi
}

_getPath() {
    local rel_path="$1"
    echo "$(cd "$(dirname "$rel_path")"; pwd -P)/$(basename "$rel_path")"
}


