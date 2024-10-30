#!/bin/bash
# Install Latest Version of Miniconda

install_conda() {
    local link="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    local msg="${red}Error${nc}: Something went wrong. Check network connection or permissions."

    curl -o- $link | sh || echo -e "$msg"
}
