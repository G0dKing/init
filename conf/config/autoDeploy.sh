#!/bin/bash

getConf() {
    cd $HOME
    conf_url=https://github.com/G0dKing/conf.git
    uid=$(user -i)

    apt update && apt upgrade -y
    clear
    git clone $conf_url
    cp -r conf/conf $HOME
    cd conf && chmod +x init.sh && ./init.sh
    return 0
}

postConf() {
    if [ "$uid" -ne 0 ]; then
        sudo cp -r $HOME/scripts /root && cp $HOME/.bashrc /root
    fi
}

autoDeploy() {
    getConf
    postConf
}

autoDeploy
