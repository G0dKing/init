$!/bin/bash
# _setup.sh

_setup() {
    local scripts=$HOME/scripts
    local dir=$scripts/files.config
    local bashrc=$dir/bashrc
    local rc=$HOME/.bashrc
    local nanorc=$dir/nanorc
    local etc="/etc"
    local dock=$dir/docker-service
    local evalbg=$dir/_evalBg.sh
    local here=$(pwd)
    local cmd="sudo apt update && sudo apt upgrade -y"
    local cmd2="bash"

    if [[ "$here" != "$dir" ]]; then
        cd "$dir"
    fi

    clear
    echo "Initializing..."
    wait 3

    if [[ -f "$evalbg" ]]; then
        . "$evalbg"
        _evalBg "${cmd}"
    fi

    sudo chown -R $USER:$USER "${scripts}"
    sudo chmod -R 755 "${scripts}"


    mv "$bashrc" "$HOME" && sudo mv "$nanorc" "$etc" && mv _evalBg.sh "$scripts" && mv "$dock" "$scripts"
    cd "$scripts" && rm -f "$dir"

    clear
    echo "Initialization Complete. Press ENTER to reload session."
    read -r
    clear
    cd $HOME
    eval "${cmd2}"
}
