#!/bin/bash

# ipinfo.sh

ipinfo_check_dependencies() {
    local missing=()
    local install_instructions=()
    for cmd in ip curl wget; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
            case "$cmd" in
                ip) install_instructions+=("ip: Install 'iproute2' package.") ;;
                curl) install_instructions+=("curl: Install 'curl' package.") ;;
                wget) install_instructions+=("wget: Install 'wget' package.") ;;
            esac
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "Error: Missing dependencies - ${missing[*]}" >&2
        for instr in "${install_instructions[@]}"; do
            echo -e "$instr" >&2
        done
        return 1
    fi
}

is_wsl() {
    grep -qiE 'microsoft' /proc/version 2>/dev/null
}

get_public_ip() {
    local public_ip services=("https://ifconfig.me" "https://api.ipify.org" "https://ipinfo.io/ip")
    for service in "${services[@]}"; do
        if command -v curl &>/dev/null; then
            public_ip=$(curl --max-time 10 -s "$service") || echo "error"
        else
            public_ip=$(wget --timeout=10 -qO- "$service") || echo "error"
        fi

        if [[ $public_ip != "error" && ! -z "$public_ip" ]]; then
            echo -e "Public IPv4: ${yellow}${public_ip}${nc}"
            return
        fi
    done
    echo -e "Public IPv4: $FAIL"
}

get_public_ipv6() {
    local public_ipv6 services=("https://api64.ipify.org?format=json")
    for service in "${services[@]}"; do
        if command -v curl &>/dev/null; then
            public_ipv6=$(curl --max-time 10 -s "$service" | grep -oP '(?<="ip":")[^"]*')
        elif command -v wget &>/dev/null; then
            public_ipv6=$(wget --timeout=10 -qO- "$service" | grep -oP '(?<="ip":")[^"]*')
        fi
        if [[ ! -z "$public_ipv6" && "$public_ipv6" =~ : ]]; then
            echo -e "Public IPv6: ${yellow}${public_ipv6}${nc}"
            echo
            return
        fi
    done
    echo -e "Public IPv6: $FAIL"
    echo
}

get_local_and_ipv6() {
    local interface local_ip
    if is_wsl; then
        interface=$(ip -4 route list match 0/0 | awk '{print $5}' 2>/dev/null)
        local_ip=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' 2>/dev/null || echo "$FAIL")
        echo -e "Local IPv4:  ${yellow}${local_ip}${nc}"
        get_public_ipv6
    else
        interfaces=($(ip link | awk '/state UP/ {print $2}' | sed 's/://'))
        if [ ${#interfaces[@]} -eq 1 ]; then
            interface=${interfaces[0]}
        else
            echo -e "Multiple active interfaces detected. Please select one:"
            select intf in "${interfaces[@]}" "Cancel"; do
                if [[ $intf == "Cancel" ]]; then
                    echo "Interface selection cancelled."
                    return
                fi
                interface=$intf
                break
            done
        fi
        local_ip=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' 2>/dev/null || echo -e "$FAIL")
        echo -e "Local  IPv4: $local_ip"
        # For non-WSL environments, attempt local IPv6 retrieval first
        ipv6=$(ip -6 addr show "$interface" | grep -oP '(?<=inet6\s)[\da-f:]+(?=/)' | grep -vE '^fe80|^::1' | awk 'NR==1' || echo "$FAIL")
        if [[ $ipv6 == "$FAIL" ]]; then
            get_public_ipv6
        else
            echo -e "Public IPv6: ${yellow}${ipv6}${nc}"
            echo
        fi
    fi
}

get_other() {
    gateway_ip=$(ip route | grep default | awk '{print $3}')
    hostname=$(hostname)

    echo -e "Hostname:    ${yellow}${hostname}${nc}"
    echo -e "Gateway IP:  ${yellow}${gateway_ip}${nc}"
}

fetch_ip() {
    echo
    echo -e "${yellow}Retrieving IP information...${nc}"
    echo
    get_other
    get_public_ip
    get_local_and_ipv6

}

ipinfo() {
    local file=$HOME/g0dking/init/colors.sh
    FAIL="${bg_red}UNAVAILABLE${nc}"

    if [[ -z "$bg_red" ]]; then
        . $file
    fi

    ipinfo_check_dependencies
    fetch_ip
}
