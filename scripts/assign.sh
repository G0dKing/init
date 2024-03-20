#!/bin/bash

# Assign Dynamic Function
nav_func() {
    local nav=$1
    local dir=$2

    eval "$nav() { cd '$dir'; }"
}

# Source Colors from External Script, If Present
nav_colors() {
    local colors=$scripts/colors_init.sh
    if [[ -f "$colors" ]] && [[ -z "$reddest" ]]; then
        . "$colors" || return 1
    fi
}

# Handle Potential Errors and Call Dynamic Function
nav_errors() {
    local nav=$1
    local dir=$2
    # Error 1: Incorrect Number of Arguments (must include exactly two)
    if [[ "$#" -ne 2 ]]; then
        echo "${green}Usage"$nc": '${cyan}assign ${purple}[${yellow}0-99${purple}]${purple} [${yellow}DIR${purple}]$nc'" && return 1
    fi

    # Error 2: Invalid Assignment (must be an integer within the range of 0-99)
    if ! [[ "$nav" =~ ^[0-9]{1,2}$ ]] || [ "$nav" -lt 0 ] || [ "$nav" -gt 99 ]; then
        echo "$reddestError$nc:$yellow Invalid Assignment$nc. Specify an integer in the range of 0-99." && return 1
    fi

    # Error 3: Invalid Target (must point to a valid directory)
    if [[ ! -d "$dir" ]]; then
        echo "$reddestError$nc:$yellow Invalid Target$nc. Must point to a valid directory." && return 1
    fi
    nav_log $nav $dir && return 0
}

nav_output() {
    local nav=$1
    local dir=$2

    nav_func "$nav" "$dir"
    echo "${green}Assigned${nc}'${blue}$dir${nc}'$green to$nc ${red}[${nav}]$nc."
}

# Append Assignment to Persistent Log File
nav_log() {
    local nav=$1
    local dir=$2
    local scripts=$HOME/scripts
    local logdir=$scripts/.logs
    local logfile=$logdir/nav.log

    if [[ ! -d "$logdir" ]]; then
        mkdir -p "$logdir" || return 1
    fi

    if [[ ! -f "$logfile" ]]; then
        echo "Nav Assignment Log" > "$logfile" || return 1
        echo "-------------------" >> "$logfile" || return 1
    fi

    echo "${nav} : ${dir}" >> "$logfile" || return 1
    nav_output "$nav" "$dir"
    return 0
}

# Primary Function Call
assign() {
    local nav=$1
    local dir=$2
    scripts=$HOME/scripts

    nav_colors $nav $dir
    nav_errors $nav $dir
}
