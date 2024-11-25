#!/bin/bash
# check.sh | v. 1.0 | 11.24.24

# Simplifies error handling and user feedback

check() {
    if [ $? -eq 0 ]; then
        echo -e "${green}SUCCESSFUL${nc}"
    else
        local err_output="${2:-}"
        local err="${1:-FAILED}"
        if [ -n "$err_output" ]; then
            local error_msg="${red}Error:${nc} $err_output$"
        else
            local error_msg="${red}Error:${nc} $err"
        echo -e "$error_msg"
        fi
    fi
    echo
}
