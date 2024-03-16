#!/bin/bash

# mvall.sh
# ver. 1.0.1

# Usage: 1. Source this script by executing: `. mvall.sh`
#        2. Call the function with desired arguments: `mvall [$FILETYPE_1] [$FILETYPE_2] [...] [$DESTINATION]`

# For example: `mvall jpg png webp ~/image_dir` will move all files ending with .jpg, .png, and/or .webp to a directory called `image_dir` in the user's home folder.

mvall() {
    local target="${@: -1}"
    local filetypes=("${@:1:$#-1}")

    if [ -z "$target" ]; then
        echo "Error: Must specify destination."
        return 1
    fi

    if [ ! -d "$target" ]; then
       sudo  mkdir -p "$target"
    fi

    if [ ${#filetypes[@]} -eq 0 ]; then
        echo "Error: Must specify at least one type of file."
        return 1
    fi

    for filetype in "${filetypes[@]}"; do
        for file in *."$filetype"; do
            if [ -f "$file" ]; then
               sudo  mv "$file" "$target"
            else
                echo "Error: No file of that type exists."
            fi
        done
    done
}
