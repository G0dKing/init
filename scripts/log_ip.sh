#!/bin/bash

# Keeps a log of IP information as it changes over time

_error() {
    echo -e "${red}"
}

source_ipinfo() {
    local file=/home/seed/g0dking/functions/ipinfo.sh
    if [ -e $file ] && [ -f $file ]; then
        source $file
    else
        
    fi
}

