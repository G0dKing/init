#!/bin/bash
# nav.conf - WSL

export last=$now
unset now
alias 1='cd $now'
alias 9='cd $last'

export C=/mnt/c
export F=/mnt/f
export G=/mnt/g

export desktop=/mnt/c/Users/Administrator/Desktop
export downloads=/mnt/c/Users/Administrator/Downloads
export user_dir=/mnt/c/Users/Administrator

export site_dir="/mnt/g/.dev/sites"
export comp_dir="/mnt/g/.dev/sites/assets/components"
export asset_dir="/mnt/g/.dev/sites/assets"
export font_dir="/mnt/g/.dev/sites/assets/fonts"

export share_dir="/mnt/g/.share"
