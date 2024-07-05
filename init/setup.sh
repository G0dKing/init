#!/bin/bash

chk_if_run() {
    local chkfile=$HOME/.init_complete
    if [[ -f "$chkfile" ]]; then
        echo "NOTE: The initialization script has already been run on this system. To re-run, delete '.init_complete' in the user's home directory."
        return 1
    else
        _setup
    fi
}

setup_repo() {
if [[ ! -d "$dir" ]]; then
    local dir="$HOME/g0dking"
    local repo="https://github.com/g0dking/init.git"
    local cmd="git clone $repo"
    cd $HOME
    echo -n "Repository not found. Cloning..."
    exec $cmd &>/dev/null &
    wait
    sudo chown -R $USER:$USER init
    sudo chmod -R 755 init
    cp -r init g0dking
    rm -rf init
    echo "Success."
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
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    tput civis 
    while ps -p "$pid" > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    tput cnorm
    printf "    \b\b\b\b"
}

setup_packages() {
    local packages=(
        aria2
        certbot
        curl
        dos2unix
        fzf
        git
        grep
        htop
        jq
        nano
        neofetch
        net-tools
        nginx
        python3-certbot-nginx
        python3-full
        ssh
        tar
        thefuck
        tree
        unzip
        vim
        wget
    )

    echo "Installing packages..."
    echo

    for package in "${packages[@]}"; do
        if ! command -v $package &>/dev/null; then
            printf "Installing...    | $package/r"
            sudo apt install -y $package &>/dev/null &
            spinner $!
            wait $!
            printf "\rInstalled    | $package\n"
        else
            printf "\rInstalled    | $package\n"
        fi
    done
    echo
    echo "Successfully installed packages."
    echo
}

setup_nvm() {
    local url=https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh

    echo -n "Installing Node Version Manager..."
    if ! command -v "nvm" &>/dev/null; then
        curl -o- $url &>/dev/null | bash &>/dev/null >&2 &
        spinner $!
        wait
        echo "Success."
    else
        echo "Node Version Manager is already installed."
    fi
}

setup_conda() {
    if ! command -v "conda" &>/dev/null; then
        echo -n "Installing MiniConda..."
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3-latest-Linux-x86_64.sh &>/dev/null &
        spinner $!
        wait
        bash Miniconda3-latest-Linux-x86_64.sh -b &>/dev/null &
        spinner $!
        wait
        rm -f Miniconda3-latest-Linux-x86_64.sh
        echo "Success."
     else
        echo "MiniConda is already installed."
     fi
}

setup_bun() {
    if ! command -v "bun" &>/dev/null; then
        echo -n "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash &>/dev/null &
        spinner $!
        wait
        echo "Success."
    else
        echo "Bun is already installed."
    fi
}

setup_rust() {
    echo -n "Installing Rust..."
    if ! command -v "rustrc" &>/dev/null; then        
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &>/dev/null &
        spinner $!
        wait
        echo "Success."
    else
        echo "Rust is already installed."
    fi
    sleep 3
}

setup_wsl() {
    if grep -Ei '(Microsoft|WSL)' /proc/version > /dev/null 2>&1; then
        setup_wsl_conf
    fi
}

setup_shell() {
    echo -n "Checking for updates..."
    sudo apt update &>/dev/null &
    spinner $!
    wait
    echo "Success."
    echo
}

setup_permissions() {
    local dir=$HOME/g0dking
    local file=$dir/init/dot.bashrc
    local active_file=$HOME/.bashrc
    local config=$dir/init/nanorc
    local active_config=/etc/nanorc

    sudo chown -R $USER:$USER "$dir" || echo "Error: Could not modify permissions." && return 1    
    sudo cp $file $active_file || echo "Error: Could not copy .bashrc file." && return 1
    sudo cp $config $active_config || echo "Error: Could not copy nanorc file." && return 1
}

execute() {
    setup_shell
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
    local chkfile=$HOME/.init_complete
    clear
    echo "Initializing..."
    sleep 3
    execute
    sleep 5
    clear
    echo "Operation Complete"
    sleep 2
    echo "The configuration has been successfully applied. The shell session will now reload."
    sleep 5
    touch $chkfile
    clear
    exec bash
}

yn_prompt() {
    local prompt="$1"
    local valid=0
    while [ $valid -eq 0 ]; do
        read -p "$prompt (y/n): " -r
        echo
        if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
            local valid=1
            chk_if_run
        elif [[ $REPLY =~ ^[Nn][Oo]?$ ]]; then
            clear
            return 1
        else
            echo "Error: Selection invalid. Please enter [y]es or [n]o."
        fi
    done
}

setup() {
    yn_prompt "Re-initialize the environment and install custom functions?"
}
