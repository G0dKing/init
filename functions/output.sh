#!/bin/bash
# output.sh | v. 1.0 | 11.24.24

# Functions to simplify user feedback while scripting

err=""


error() {
   local err_msg="$1"
   echo -e "${red}ERROR${nc}: $error_msg" >&2
}

success() {
    echo -e "${green}SUCCESS${nc}"
}

check() {
    if [ $? -eq 0 ]; then
        success
    else
        local error_msg="${1:-$err:-"FAIL"}"
        error "$error_msg"
    fi
}

capture_stderr() {
    err=$(cat)
}

trap 'capture_stderr' ERR
