#!/bin/bash

is_wsl() {
    grep -qi Microsoft /proc/version &>/dev/null
}

no_wsl_win_to_unix() {
    local win_path="$1"
    local unix_path=$(echo "$win_path" | sed -e 's/^[A-Za-z]://' -e 's/\\/\//g')
    echo "$unix_path"
    return 0
}

no_wsl_unix_to_win() {
    local target_path="$1"
    if [[ "$target_path" =~ [A-Za-z]:\\ ]]; then
        no_wsl_win_to_unix "$target_path"
    else
        echo "$target_path"
        return 0
    fi
}

win_to_unix() {
    if is_wsl;then
        local path=$1
        if [[ "$path" == /mnt/* ]]; then
            path="${path#/mnt/}"
            path="${path//\//\\}"
            local drive_letter=${path:0:1}
            drive_letter=${drive_letter^^}
            path="$drive_letter:${path:1}"
        elif [[ "$path" == ~* ]]; then
            path="${path/#\~/$HOME}"
            path=$(wslpath -w "$path")
        else
            path=$(wslpath -w "$path")
        fi
        echo "$path"
        return 0
    else
        local path=$1
        no_wsl_win_to_unix "$path"
    fi
}

unix_to_win() {
    if is_wsl; then
        local path=$(wslpath -u "$path")
        echo "$path"
        return 0
    else
        local path=$1
        no_wsl_unix_to_win "$path"
    fi
}

show_help() {
    echo "Usage: xpath [-MODE] [PATH]"
    echo "[MODE]: [-w]: win-unix (default) | [-u]: unix-win"
    echo "[PATH]: Target path to convert. Defaults to current directory."
    return 0
}

set_mode() {
    local target_path=$1
    if [[ "$target_path" =~ [A-Za-z]:\\ ]]; then
        mode="-w"
    else
        mode="-u"
    fi
}

parse_mode() {
    local mode="$1"
    local target_path="$2"

    if [[ "$mode" == "-w" ]]; then
        unix_to_win "$target_path"
    elif [[ "$mode" == "-u" ]]; then
        win_to_unix "$target_path"
    fi
}

xpath_execute() {
    local mode="$1"
    local target_path="$2"

    if [[ -z "$target_path" ]]; then
        target_path=$(pwd)
    fi


    if [[ ! -e "$target_path" ]]; then
        echo "Error: Invalid target. Run 'xpath --help' for usage information."
        return 1
    fi

    if [[ -z "$mode" ]]; then
        set_mode "$target_path"
    fi

    if [[ "$mode" == "--help" ]] || [[ "$mode" == "-h" ]]; then
        show_help
        return 0
    fi

    if [[ $# -eq 0 ]]; then
        set_mode "$target_path"
        target_path=$(pwd)
    fi

    parse_mode "$mode" "$target_path"
}

xpath() {
    xpath_execute "$@"
    return 0
}
