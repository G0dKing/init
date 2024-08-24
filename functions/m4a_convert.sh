#!/bin/bash

m4a_convert() {
    local dir=/mnt/c/files
    
    echo    
    echo -e "${yellow}Remuxing all files to .mp3...${nc}"
    
    if $(pwd) !== $dir; then
       cd $dir
    fi

    for f in *.m4a; do
       find . | grep *.m4a | ffmpeg -i "$f" -codec:v copy -codec:a libmp3lame -q:a 2 mp3s/"${f%.m4a}.mp3"    
    done

    echo

    if [ $! -eq 0 ]; then
       echo -e "${green}Success"
       return 0
    else
        echo -e "${red}One or more files could  not be remuxed${nc}"
        return 1
    fi
}
