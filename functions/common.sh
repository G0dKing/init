#!/bin/bash

# Common Functions

export origin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chk_if_root() {
    local uid=$(id -u)
    if [[ "$uid" -ne 0 ]]; then
        echo "Error: Access denied. Try again as root."
        return 1
    fi
}

error() {
    local msg=$1
    if [[ -z "$msg" ]]; then
        local err_msg="An unknown error has occurred. Exiting."
    else
        local err_msg="Error: ${msg}"
    fi
    echo "$err_msg" >&2
    return 1
}

log_error() {
    local script=$0
    local err_msg=$1
    local date="$(date + %Y-%m-%d %H:%M:%S)"
    local log_dir="$origin_dir"/.logs
    local log_file="$log_dir"/.logs/error.log

    if [[ ! -f $log_dir ]]; then
        mkdir -p $log_dir
        touch $log_file
        echo "$script - OUTPUT LOG" >> $log_file
        echo "--------------------------" >> $log_file
        echo "" >> $log_file
        echo "START" >> $log_file
        echo "--------------------------" >> $log_file
    fi

    echo "/$red/Error/$nc/: $err_msg" >&2
    echo "Error: $err_msg1 -- $date" >> "$log_file"
    return 1
}

new_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') : $message"
}

new_backup() {
    local file="$1"

    local backup_dir=$origin_dir/.backups/$file

    if [ ! -d "$backup_dir" ]; then
        mkdir -p $backup_dir
    fi

    if [ -f "$file" ]; then
        cp "$file" "${file}.$(date +'%Y%m%d%H%M%S').bak"
    fi
}

# Usage: yes_no ["STRING"]
yes_no() {
    local prompt="$1"
    local valid=0
    while [ $valid -eq 0 ]; do
        read -p "$prompt (y/n): " -r
        echo
        if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
            local valid=1
            echo "yes"
        elif [[ $REPLY =~ ^[Nn][Oo]?$ ]]; then
            echo "no"
            return 1
        else
            echo "Error: Selection invalid. Please enter [y]es or [n]o."
        fi
    done
}

chk_if_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
}

chk_if_email() {
    local chars="$1"
    if [[ "$chars" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Valid characters."
    else
        echo "Invalid characters."
        exit 1
    fi
}

get_path() {
    local rel_path="$1"
    echo "$(cd "$(dirname "$rel_path")"; pwd -P)/$(basename "$rel_path")"
}

chk_if_cmd() {
    [ ! command -v "$1" ] >/dev/null 2>&1
}

chk_cmd() {
    local cmd=$1
    local name=$2
    local err_msg=$3

    if ! command -v "$cmd" &>/dev/null; then
        echo "$name is not installed. Installing..."
        sudo apt install -y "$cmd" || error "$err_msg"
    else
        echo "$name is already installed."
    fi
}

list_users() {
    awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd
}
