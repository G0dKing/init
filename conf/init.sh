#!/bin/bash

# Initialization Script for Debian-Based Linux Shells
# ver. 4.0.4

init_prime() {
    scriptdir=scripts
    configdir=config

    clear
    echo "Initializing..."
    wait 3

    if ! dpkg-query -l "curl" &> /dev/null; then
       sudo apt update &
       sudo apt install curl &
    fi
    
    if ! dpkg-query -l "nvm" &> /dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$HOME/.bashrc"
    fi
    
    sudo chmod -R 755 .
    sudo chown $user:$user -R .
    cp -r $scriptdir $HOME
    sudo cat $configdir/nanorc > /etc/nanorc
    sudo cat $configdir/resolv.conf > /etc/resolv.conf
    cat $configdir/bashrc > $HOME/.bashrc
    cd ..
    rm -r conf

    clear
    echo "Initialization complete. Press Enter to reload the shell."
    read -r
    
    clear
    cd $HOME
    exec bash
    return 0
}

init_prime

