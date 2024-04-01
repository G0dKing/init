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
        echo "Error: Missing dependencies - ${missing[*]}" >&2
        for instr in "${install_instructions[@]}"; do
            echo "$instr" >&2
        done
        exit 1
    fi
}

is_wsl() {
    grep -qiE 'microsoft' /proc/version 2>/dev/null
}

get_public_ip() {
    local public_ip services=("https://ifconfig.me" "https://api.ipify.org" "https://ipinfo.io/ip")
    for service in "${services[@]}"; do
        if command -v curl &>/dev/null; then
            public_ip=$(curl --max-time 10 -s "$service" || echo "error")
        else
            public_ip=$(wget --timeout=10 -qO- "$service" || echo "error")
        fi
        if [[ $public_ip != "error" && ! -z "$public_ip" ]]; then
            echo "Public IPv4: $public_ip"
            return
        fi
    done
    echo "Public IPv4: <FAILED>"
}

get_public_ipv6() {
    local public_ipv6 services=("https://api64.ipify.org?format=json")
    for service in "${services[@]}"; do
        if command -v curl &>/dev/null; then
            public_ipv6=$(curl --max-time 10 -s "$service" | grep -oP '(?<="ip":")[^"]*')
        elif command -v wget &>/dev/null; then
            public_ipv6=$(wget --timeout=10 -qO- "$service" | grep -oP '(?<="ip":")[^"]*')
        fi
        # Basic check to see if the fetched address is an IPv6 address
        if [[ ! -z "$public_ipv6" && "$public_ipv6" =~ : ]]; then
            echo "Public IPv6: $public_ipv6"
            return
        fi
    done
    echo "Public IPv6: <FAILED>"
}

get_local_and_ipv6() {
    local interface local_ip

    if is_wsl; then
        interface=$(ip -4 route list match 0/0 | awk '{print $5}' 2>/dev/null)
        local_ip=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' 2>/dev/null || echo "<FAILED>")
        echo "Local (LAN) IPv4: $local_ip"
        # In WSL, use external service to fetch IPv6
        get_public_ipv6
    else
        interfaces=($(ip link | awk '/state UP/ {print $2}' | sed 's/://'))
        if [ ${#interfaces[@]} -eq 1 ]; then
            interface=${interfaces[0]}
        else
            echo "Multiple active interfaces detected. Please select one:"
            select intf in "${interfaces[@]}" "Cancel"; do
                if [[ $intf == "Cancel" ]]; then
                    echo "Interface selection cancelled."
                    return
                fi
                interface=$intf
                break
            done
        fi
        local_ip=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' 2>/dev/null || echo "<FAILED>")
        echo "Local (LAN) IPv4: $local_ip"
        # For non-WSL environments, attempt local IPv6 retrieval first
        ipv6=$(ip -6 addr show "$interface" | grep -oP '(?<=inet6\s)[\da-f:]+(?=/)' | grep -vE '^fe80|^::1' | awk 'NR==1' || echo "<FAILED>")
        if [[ $ipv6 == "<FAILED>" ]]; then
            get_public_ipv6
        else
            echo "Public IPv6: $ipv6"
        fi
    fi
}

fetch_ip() {
    echo "Retrieving IP information..."
    get_public_ip
    get_local_and_ipv6
}

ipinfo() {
    ipinfo_check_dependencies
    fetch_ip
}
