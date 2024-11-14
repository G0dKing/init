#!/bin/bash

chkport_tools() {
    echo -e "${yellow}Installing Dependencies...${nc}"
    sudo apt update &>/dev/null
    sudo apt install -y net-tools &>/dev/null
    wait
}

chkport_err() {
    local port=$1

    if  [[ -z "$port" ]]; then
        echo -e "${red}ERROR${nc}: Must specify which port to check."
        return 1
    fi
    return 0
}

chkport() {
    local port=$1
    local cmd=$(sudo netstat -tvulnp | grep :"$port")

    if ! command -v netstat &>/dev/null; then
        chkport_tools
    fi

    chkport_err "$port"
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    clear
    echo -e "${yellow}Checking port ${red}$port${yellow}...${nc}"
    echo

    if [[ -z "$cmd" ]]; then
        echo -e "${yellow}Port ${red}$port${yellow} is not currently in use.${nc}"
    else
        echo -e "${green}$cmd${nc}"
    fi
    echo
}
