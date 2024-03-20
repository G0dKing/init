#!/bin/bash

set_prompt() {
    if [[ "$colors_unsupported" -eq 1 ]]; then
        symbol="@"
        color1=""
        color2=""
    else
        symbol=$3
        color1=$1
        color2=$2
    fi
    PS1="$color2{{$color1\u$color2$symbol$color1 \h$color2}}$nc  "
    return 0
}

prompt_init() {
    if [[ -z "$red" ]]; then
        . ~/scripts/colors_init.sh
        colors_init
    fi
    if [[ ! -z "$color1" ]]; then
        unset color1
        unset color2
        unset symbol
    fi
    if [[ "$uid" -eq 0 ]]; then
        set_prompt $red $purple $sym_nuke
    else
        set_prompt $cyan $green $sym_bio
    fi
    return 0
}
