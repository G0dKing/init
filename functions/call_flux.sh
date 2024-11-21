#!/bin/bash

call_flux() {
    local endpoint="https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev"
    local token=$HF_TOKEN
    local prompt=$1
    local output="${2:-img.jpg}"
    local ref=$3
    local encoded_ref=""

    if [ -z "$prompt" ]; then
        error "Must include prompt as argument."
        exit 1
    fi

    if [ -n "$ref" ]; then
        encoded_ref=$(base64 -w 0 "$ref")
    fi

    if [ -n "$encoded_ref" ]; then
        payload="{
            \"inputs\": \"$prompt\",
            \"image\": \"$encoded_ref\"
        }"
    else
        payload="{
            \"inputs\": \"$prompt\"
        }"
    fi

    echo -e "Generating image..."

    curl -X POST "$endpoint" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        --output "$output" \
        --progress-bar

    if [ $? -ne 0 ]; then
        error "The API call failed. Check your connection and try again."
        exit 1
    fi

    echo -e "Image generation complete."
    return 0
}
