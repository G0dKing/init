#!/bin/bash

flux_help_msg() {
    echo -e "${yellow}USAGE:${green} `flux [PROMPT] --[OPTION]`${nc}"
    echo -e "       [-d, --directory]: Append contents of all text-containing files in a given directory to the prompt."
    echo -e "       [-f, --file]: Append contents of a file to the prompt (can be passed multiple times)."
    echo -e "       [-h, --help]: Display usage information."
    echo -e "       [-o, --output]: Specify a path/filename for the generated image."
    echo -e "       [-p, --prompt, *]: Specify prompt for AI model."
    echo -e "       [-r --reference]: Specify the path to an image to include it in the payload as a reference for the AI model."
}

call_flux() {
    model=schnell # dev, pro, pro-ultra, schnell, raw
    endpoint="https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-${model}"
    token=$HF_TOKEN
    prompt="$1"
    ref=""
    output="img.jpg"
    files=()
    dirs=()

    if [ -z "$prompt" ]; then
        error "Must include prompt as argument."
        return 1
    fi

    if [ -z "$token" ]; then
        error "HuggingFace API token not found. Export it as a global variable, then try again."
        return 1
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
        -f| --files)
            shift
            if [[ -f "$1" ]]; then
                files+=("$1")
            else
                error "File not found: $1"
                return 1
            fi
            ;;
        -d| --directory)
            shift
            if [[ -d "$1" ]]; then
                dirs+=("$1"/*.{txt,md,yaml,json)
            else
                error "Directory not found: $1"
                return 1
            fi
            ;;
        -r| --reference)
            shift
            if [[ -f "$1" ]]; then
                ref="$1"
            else
                error "Reference file not found: $1"
                return 1
            fi
            ;;
        -o| --output)
            shift
            output="$1"
            ;;
        -h| --help)
            help_msg
            ;;

        *| -p| --prompt)
            prompt="$1"
            ;;
        esac
        shift
    done

    for file in "${files[@]}"; do
        file_content=$(<"$file")
        prompt="${prompt}\n$(basename "$file"):\n${file_content}"
    done

    for file in "${dirs[@]}"; do
        if [[ -f "$file" ]]; then
            file_content=$(<"$file")
            prompt="${prompt}\n$(basename "$file"):\n${file_content}"
        fi
    done

    auth="Authorization: Bearer $token"

    payload="{\"inputs\": \"$prompt\"}"

    # If reference is provided, encode it
    if [ -n "$ref" ]; then
        encoded_ref=$(base64 -w 0 "$ref" 2>/dev/null)
        if [ $? -ne 0 ]; then
            error "Failed to encode reference file: $ref"
            return 1
        fi
        payload="{\"inputs\": \"$prompt\", \"ref\": \"$encoded_ref\"}"
    fi

    curl -X POST "$endpoint" \
        -H "$auth" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        --output "$output"

    if [ $? -ne 0 ]; then
        error "The API call failed. Check your connection and try again."
        return 1
    fi

    echo -e "${green}Image generated successfully! Saved to ${output}.${nc}"
    return 0
}

flux() {
    prompt="$1"
    echo
    echo -e "${cyan}Generating image...${nc}"
    call_flux "$prompt"
}
