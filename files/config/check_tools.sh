#!/bin/bash

#check_tools.sh

_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

_miniconda() {
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/seed/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/seed/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/home/seed/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/seed/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}

ssh_github() {
    eval "$(ssh-agent -s)" >&/dev/null
    ssh-add ~/.ssh/id_ed25519 >&/dev/null
}

