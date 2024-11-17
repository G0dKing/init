#!/bin/bash
# convert_audio.sh | v. 1;0 | 11.16.24

# Convert audio files into different formats
# Usage: 'convert_audio [OLD_FILETYPE] [NEW_FILETYPE] [DIRECTORY]'

convert_audio() {
    local before=$1
    local after=$2
    local dir=$3
    filetypes=("mp3" "aac" "opus" "flac" "wav")

    if [ $# -eq 0 ]; then
        error "Must include arguments"
    elif [ -z "$before" ] || [ -z "$after" ]; then
        error "Must specify before/after formats"
    fi

    if [[ ! "${filetypes[@]}" =~ "${before}" ]] || [[ ! "${filetypes[@]}" =~ "${after}" ]]; then
        error "Error: Invalid audio format"
        return 1
    fi

    if [ ! -d "$dir" ]; then
        mkdir -p $dir
    elif [ -z "$dir" ]; then
        local dir=$(pwd)
    fi

    for file in "$dir"/*.${before}; do
        if [ -f "$file" ]; then
            ffmpeg -i "$file" -q:a 0 "$dir/${file%.$before}.$after"
        else
            error "File not found."
            return 1
        fi
    done
}
