#!/bin/bash

set -euo pipefail

# Configuration
CONFIG_FILE="$HOME/.init_config"
LOG_FILE="$HOME/.init_log"
REPO_URL="https://github.com/g0dking/init.git"
NVM_VERSION="v0.39.7"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# Load configuration if exists
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

error() {
    log "ERROR: $1"
    exit 1
}

chk_if_run() {
    local chkfile="/root/.init_complete"
    if [[ -f "$chkfile" ]]; then
        log "NOTE: The initialization script has already been run on this system."
        log "To re-run, delete '.init_complete' in the root user's home directory."
        return 1
    else
        _setup
    fi
}

setup_repo() {
    local dir="$HOME/g0dking"
    if [[ ! -d "$dir" ]]; then
        log "Repository not found. Cloning..."
        cd "$HOME" || error "Unable to change to home directory"
        if ! git clone "$REPO_URL" &>/dev/null; then
            error "Failed to clone repository"
        fi
        sudo chown -R "$USER:$USER" init
        sudo chmod -R 755 init
        cp -r init g0dking
        rm -rf init
        log "Repository setup successful."
    fi
}

setup_wsl_conf() {
    local wsl_conf="/etc/wsl.conf"
    if [[ ! -f "$wsl_conf" ]]; then
        sudo touch "$wsl_conf"
    fi

    sudo bash -c 'cat <<EOF >> /etc/wsl.conf
[boot]
systemd = true

[network]
generateResolvConf = false
EOF'
    log "WSL configuration updated."
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    tput civis
    while ps -p "$pid" > /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    tput cnorm
    printf "    \b\b\b\b"
}

setup_packages() {
    local packages=(
        aria2 certbot curl dos2unix fzf git grep htop jq nano neofetch
        net-tools nginx python3-certbot-nginx python3-full ssh tar thefuck
        tree unzip vim wget iptables nmap proxychains4 tor
    )

    log "Updating package lists..."
    sudo apt update &>/dev/null || error "Failed to update package lists"

    log "Installing packages..."
    sudo apt install -y "${packages[@]}" &>/dev/null || error "Failed to install packages"

    log "Successfully installed packages."
}

setup_nvm() {
    if ! command -v nvm &>/dev/null; then
        log "Installing Node Version Manager..."
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash &>/dev/null || error "Failed to install NVM"
        log "Node Version Manager installed successfully."
    else
        log "Node Version Manager is already installed."
    fi
}

setup_conda() {
    if ! command -v conda &>/dev/null; then
        log "Installing MiniConda..."
        wget "$MINICONDA_URL" -O miniconda.sh &>/dev/null || error "Failed to download MiniConda"
        bash miniconda.sh -b &>/dev/null || error "Failed to install MiniConda"
        rm -f miniconda.sh
        log "MiniConda installed successfully."
    else
        log "MiniConda is already installed."
    fi
}

setup_bun() {
    if ! command -v bun &>/dev/null; then
        log "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash &>/dev/null || error "Failed to install Bun"
        log "Bun installed successfully."
    else
        log "Bun is already installed."
    fi
}

setup_rust() {
    if ! command -v rustc &>/dev/null; then
        log "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &>/dev/null || error "Failed to install Rust"
        log "Rust installed successfully."
    else
        log "Rust is already installed."
    fi
}

setup_wsl() {
    if grep -qi microsoft /proc/version || grep -qi wsl /proc/version; then
        setup_wsl_conf
    fi
}

setup_permissions() {
    local dir="$HOME/g0dking"
    local file="$dir/init/dot.bashrc"
    local active_file="$HOME/.bashrc"
    local config="$dir/init/nanorc"
    local active_config="/etc/nanorc"

    sudo chown -R "$USER:$USER" "$dir" || error "Could not modify permissions"
    sudo cp "$file" "$active_file" || error "Could not copy .bashrc file"
    sudo cp "$config" "$active_config" || error "Could not copy nanorc file"
    log "Permissions and configurations updated."
}

cleanup() {
    log "Performing cleanup..."
}


execute() {
    setup_wsl
    setup_packages
    setup_repo
    setup_permissions
    setup_nvm
    setup_conda
    setup_bun
    setup_rust
}

_setup() {
    local chkfile="/root/.init_complete"
    clear
    log "Initializing..."
    sleep 3
    execute
    sleep 5
    clear
    log "Operation Complete"
    sleep 2
    log "The configuration has been successfully applied. The shell session will now reload."
    sleep 5
    sudo touch "$chkfile"
    clear
    exec bash
}

yn_prompt() {
    local prompt="$1"
    local valid=0
    while [[ $valid -eq 0 ]]; do
        read -rp "$prompt (y/n): " reply
        echo
        case "$reply" in
            [Yy]|[Yy][Ee][Ss]) valid=1; return 0 ;;
            [Nn]|[Nn][Oo]) return 1 ;;
            *) echo "Error: Invalid selection. Please enter [y]es or [n]o." ;;
        esac
    done
}

setup() {
    if yn_prompt "Apply custom configurations to shell (cannot be reversed)?"; then
        chk_if_run
    else
        log "Operation cancelled."
        exit 0
    fi
}
