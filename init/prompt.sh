#!/bin/bash
# prompt.sh (7.4.24)

set_prompt() {
    local user=$(whoami)

    if [[ "$user" == "root" ]]; then
        color1=$yellow
        color2=$red
        frame1="|#"
        frame2="#|"
        symbol=$sym_skull
    else
        color1=$purple
        color2=$blue
        frame1="|$"
        frame2="$|"
        symbol=""
    fi

    PS1="\[$color1\]$frame1\[$color2\] \u \[$color1\]$frame2\[$nc\]"
}

set_prompt
