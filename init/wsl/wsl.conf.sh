#!/bin/bash

# WSL Environment Configuration

# >>> Add Windows Locations to PATH <<<
export PATH=$PATH:/mnt/c/Windows/System32
export PATH=$PATH:/mnt/c/ffmpeg/bin
export PATH=$PATH:/mnt/c/Python312
export PATH=$PATH:/mnt/c/ProgramData/chocolately/bin
export PATH=$PATH:/mnt/c/Users/Administrator
export PATH=$PATH:/mnt/c/Users/Administrator/.ssh
export PATH=$PATH:/mnt.c/Users/Administrator/Desktop

# >>> WSL Navigation <<<
# >>> Volumes <<<
export win_c=/mnt/c
export win_f=/mnt/f
export win_g=/mnt/g
alias cc='cd $win_c'
alias ff='cd $win_f'
alias gg='cd $win_g'

# >>> /c/ <<<
export win_desktop="/mnt/c/Users/Administrator/Desktop"
export win_dl="/mnt/c/Users/Administrator/Downloads"
export win_user="/mnt/c/Users/Administrator"
export win_ssh='/mnt/c/Users/Administrator/.ssh'
export win_sys='/mnt/c/Windows/System32'
alias c0='cd $win_sys'
alias c1='cd $win_user'
alias c2='cd $win_desktop'
alias c3='cd $win_dl'
alias c4='cd $win_ssh'

# >>> /g/ <<<
export win_dev="/mnt/g/.dev"
export win_sites="/mnt/g/.dev/sites"
export win_active='/mnt/g/.dev/projects/current'
alias g0='$win_active'
alias g1='$win_dev'
alias g2='$win_sites'

# >>> Enable Shared Clipboard
winClip() {
    local target=$1
    local copy_=copy
    local paste_=paste
    local cmd2="powershell.exe /c Get-Clipboard"

    alias "${paste_}"="${cmd2}"
}

winClip

# >>> Functions to List Shortcuts <<<
_shortcut_list() {
    local shortcuts=(
        "WSL Shortcuts"
        ""
        "/ Volumes /"
        "Drive C: cc"
        "Drive F: ff"
        "Drive G: gg"
        ""
        "/ Drive C: /"
        "System32: c0"
        "User: c1"
        "Desktop: c2"
        "Downloads: c3"
        "SSH: c4"
        ""
        "/ Drive G: /"
        "Active Projects: g0"
        "Developer Directory: g1"
        "Website Directory: g2"
    )
    for shortcut in "${shortcuts[@]}"; do
        echo "$shortcut"
    done
}

show_wsl() {
    clear
    _shortcut_list
}
