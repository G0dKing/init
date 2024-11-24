#!/bin/bash

wordruler() {
    local l=0
        for var in "$@"; do
            [[ ${#var} -gt $l ]] && l=${#var}
        done

        echo "$l"
}
