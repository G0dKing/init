#!/bin/bash

swap_all() {

    local exact_match=false
    local dir=""
    local pattern=""

    while getopts ":e" opt; do
        case $opt in
            e)
                exact_match=true
                ;;
            \?)
                error "Invalid option: -$OPTARG"
                ;;
        esac
    done

    shift $((OPTIND-1))

    dir="${1:-$(pwd)}"
    pattern="$2"

    process_file() {
        local file="$1"
        local line_number=0
        local match_found=false
        local int=1

        while IFS= read -r line; do
            ((line_number++))
            if $exact_match; then
                if [[ $line =~ (^|[[:space:]])"$pattern"($|[[:space:]]) ]]; then
                    match_found=true
                    context="${line:${BASH_REMATCH[1]:+${#BASH_REMATCH[1]}}:${#pattern}}"
                    preview="${line:${BASH_REMATCH[1]:+${#BASH_REMATCH[1]}}:50}"
                    echo -e "Matches found:
                    echo "$int | ${green}$file${nc}, line ${yellow}$line_number${nc}, ${red}$preview${nc}..."
                    int=${int++}
                fi
            else
                if [[ $line =~ $pattern ]]; then
                    match_found=true
                    context="${BASH_REMATCH[0]}"
                    start_index=$((${BASH_REMATCH[1]} - 25 < 0 ? 0 : ${BASH_REMATCH[1]} - 25))
                    preview="${line:$start_index:50}"
                    echo -e "Matches found:
                    echo "$int | ${red}$file${nc}, line ${yellow}$line_number${nc}, (${red}$preview${nc}...)"
                    int=${int++}
                fi
            fi
        done < "$file"

        if $match_found; then
            return 0
        else
            return 1
        fi
    }

    local matches_found=false
    while IFS= read -r -d '' file; do
        if process_file "$file"; then
            matches_found=true
        fi
    done < <(find "$dir" -type f -print0)

    if ! $matches_found; then
        echo -e "${red}No matches found.${nc}"
        return 0
    fi

    read -p "Swap with: " replace_pattern

    if [ -z "$replace_pattern" ]; then
        echo
        return 0
    fi

    while IFS= read -r -d '' file; do
        if $exact_match; then
            sed -i "s/\b$pattern\b/$replace_pattern/g" "$file"
        else
            sed -i "s/$pattern/$replace_pattern/g" "$file"
        fi
    done < <(find "$dir" -type f -print0)
}
