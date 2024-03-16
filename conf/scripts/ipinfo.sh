#!/bin/bash

# ~/bin/ipinfo.sh
# ver. 4.0.4

os_detect() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        INTERFACE=$(ip link | awk '/state UP/ {print $2}' | sed 's/://')
        IP_CMD="ip addr show $INTERFACE"
        IP6_CMD="ip -6 addr show $INTERFACE"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        INTERFACE=$(ifconfig | grep -E '^[a-zA-Z]' | awk '{print $1}' | head -n1)
        IP_CMD="ifconfig $INTERFACE"
        IP6_CMD="ifconfig $INTERFACE"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        IP_CMD="ipconfig"
        IP6_CMD="ipconfig"
        WIN=true
    else
        echo "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

ip_check() {
    ip=$(curl -s ipinfo.io/ip) || ip=$(wget -q -O - ipinfo.io/ip) || ip=$(lynx -dump ipinfo.io/ip)
    
    if [[ $WIN == true ]]; then
        ip2=$(ipconfig | awk '/IPv4 Address/ {print $NF}')
        ip3_raw=$(ipconfig | grep -E 'IPv6 Address' | awk '{print $NF}')
    else
        ip2=$($IP_CMD | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
        ip3_raw=$($IP6_CMD | grep 'inet6 ' | awk '{print $2}' | cut -d'/' -f1)
    fi

    ip3=""
    for addr in $ip3_raw; do
        if [[ ! "$addr" =~ ^fe80: && ! "$addr" =~ ^::1 ]]; then
            ip3="$ip3 $addr"
        fi
    done

    ((attempt++))
}

ip_error() {
    if [ "$ip2" == "$ip" ]; then
        ip2=0.0.0.0
    elif [ -z "$ip2" ]; then
        ip2=127.0.0.1
    fi
    if [ "$attempt" -ge 3 ]; then
        clear
        echo "Error: Could not retrieve IP information."
        echo ""
        echo "Press Enter to exit."
        read -r
        clear
        return 1
    fi
    if [ -z "$ip" ]; then
        ip_check
        ip_error
    fi
}

ip_output() {   
    no_color="\033[0m"
    version="4.0.4"
    tput civis    
    echo -e "${reddest}IPINFO v. ${version}${no_color}"
    echo ""
    echo -e "${yellow}IPv4${no_color}"
    echo -e "${cyan}Public${no_color}:          $ip"
    echo -e "${cyan}Private${no_color}:         $ip2"
    echo ""
    echo -e "${yellow}IPv6${no_color}"
    echo -e "${cyan}Public${no_color}:         $ip3"
    echo ""
    echo ""
    echo ""
    echo ""
    echo -e "Press ${reddest}Enter${no_color} to exit."
}
ipinfo() {
    unset ip ip2 ip3 ip3_raw WIN
    local attempt=0
    os_detect
    clear
    ip_check
    ip_error
    ip_output
    read -r
    tput cnorm
    clear
}