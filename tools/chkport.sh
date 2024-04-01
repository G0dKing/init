#!/bin/bash
# ~/bin/chkport.sh

chkport_tools() {
        echo "Installing Dependencies..."
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y net-tools
        return 0
}

chkport() {
    if  [ $# -ne 1 ]; then
        echo "Usage: chkport [PORT_NUMBER]"
        return 1
    fi

    if ! command -v netstat &> /dev/null; then
        chkport_tools
    fi

    clear
    local target=$1

    if [ "$uid" -ne 0 ]; then
        sudo netstat -tulnp | grep :$target
    else
        netstat -tulnp | grep :$target
    fi
    return 0
}
