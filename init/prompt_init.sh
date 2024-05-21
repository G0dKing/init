#!/bin/bash

# Applies default colors to shell prompt. To modify, run `setprompt $[COLOR_1] $[COLOR_2] $[EMOJI]`

# Format user prompt
_set_prompt() {
    local c1=$1
    local c2=$2
    local s0=$3

    if [[ "$uid" -eq 0 ]]; then
        PS1="\[$c1\]root$\[$c2\]\[$s0\]|#\[$nc\] "
    else
        PS1="\[$c2\]|$\[$c1\] \u \[$c2\]$|\[$nc\] "
    fi
}

# Load custom color variables
_chkcolors() {
    local script=$g0dking/init/colors_init.sh

    if [[ -f "$script" ]]; then
        . "$script"
        colors_init
    fi
}

# Apply colors to user prompt
setprompt() {
    if [[ "$#" -eq 0 ]]; then
        if [[ "$EUID" -eq 0 ]]; then
            local c1=$red
            local c2=$yellow
            local sym=$sym_skull
        else
            local c1=$purple
            local c2=$green
            local sym=$bio
        fi
    else
        local c1=$1
        local c2=$2
        local sym=$3
    fi
    _chkcolors
    _set_prompt "$green" "$purple" "$sym_nuke"
}

setprompt
