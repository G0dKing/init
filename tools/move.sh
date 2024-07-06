#!/bin/bash

move_it() {
    local parent_dir="${1:-$(pwd)}"
    local new_dir="${2:-$(pwd)/links}"

    if [ ! -d "$parent_dir" ]; then
        echo -e "Parent directory does not exist."
        return 1
    fi

    if [ ! -d "$new_dir" ]; then
       sudo mkdir -p "$new_dir"
    fi

    for dir in "$parent_dir"/*/; do
        if [ -d "$dir" ]; then
          sudo mv "$dir" "$new_dir" &>/dev/null &
        fi
    done

    echo -e "All directories have been moved to $new_dir."
}

move_up() {
    local target_dir="${1:-$(pwd)}"
    local parent_dir=$(dirname "$target_dir")

    if [ ! -d "$target_dir" ]; then
        echo "Target directory does not exist."
        return 1
    fi

    for item in "$target_dir"/*; do
       sudo mv "$item" "$parent_dir" &>/dev/null
    done

    echo "All contents have been moved to $parent_dir."
}

move_all() {
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
