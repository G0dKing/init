#!/bin/bash

call_flux() {
    local endpoint="https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev"
    local token=$HF_TOKEN
    local prompt=$1
    local output="${2:-img.jpg}"

    if [ $# -eq 0 ]; then
        error "Must include prompt as argument."
        exit 1
    fi

    echo -e "Generating image..."

    curl -X POST "$endpoint" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"inputs\": \"$prompt\"}" \
        --output "$output" \
        --progress-bar

    if [ $? -ne 0 ]; then
        error "API call failed." 
        exit 1
    fi

    echo -e "Image generation complete."
    return 0
}
