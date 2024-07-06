# G0dKing || ~/.bashrc || 7.2.24

[[ $- != *i* ]]
export g0dking=$HOME/g0dking

# General
alias c='clear'
alias mkdir='mkdir -p'
alias la='ls -a'
alias ll='ls'
alias cp='cp -r'
alias rm='rm -rf'

# Network Variables
export pdanet_host_ip=192.168.49.232
export pdanet_gateway=192.168.49.1
export pdanet_proxy_port=8000
export pdanet_proxy="${pdanet_gateway}:${pdanet_proxy_port}"


# Functions

# Initialize Environment
source $HOME/g0dking/init/colors.sh
source $HOME/g0dking/init/prompt.sh

init_env() {
    # Set Vars
    local is_wsl=0
    local dirs=(
        "$g0dking/tools"
        "$g0dking/init"
        "$g0dking/init/wsl"
    )
    # Check if WSL
    if grep -qEi '(Microsoft|WSL)' /proc/version; then
        is_wsl=1
    fi
    # Source Functions
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            for file in "$dir"/*.{sh,conf,config}; do
                [ -r "$file" ] && [ -f "$file" ] && . "$file"
            done
        elif [ "$dir" == "$g0dking/init/wsl" ] && [ "$is_wsl" -eq 1 ]; then
            for file in "$dir"/*.{sh,conf}; do
                [ -r "$file" ] && [ -f "$file" ] && . "$file"
            done
        fi
    done
}
init_env

# Secrets
secrets() {
    local env=$HOME/.env
    if [[ -f "$env" ]]; then
        set -a; source "$env"; set +a
    fi
}
secrets

setup_dns() {
    local file="/etc/resolv.conf"
    local domains=(
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
    )

    if [[ ! -f "$file" ]]; then
        sudo touch $file
    fi

    for dns in "${domains[@]}"; do
        if ! grep -q "nameserver ${dns}" "$file"; then
            echo "nameserver ${dns}" | sudo tee -a "$file" >/dev/null
        fi
    done
}

# List Users
list_users() {
    awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd
}


clone() {
    local repo=$1
    local url="https://github.com"
    local name="G0dKing"
    local cmd="git clone $url/$name/$repo.git"
    exec $cmd
}
