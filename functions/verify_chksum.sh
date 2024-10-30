#!/bin/bash

# Verify SHA-256 Checksums

verify_chksum() {
    local sha=$1
    local file=$2

    if [ "$@" -ne 2 ]; then
        echo -e "${red}Error${nc}: Invalid arguments. USAGE: `verify_chksum [CHECKSUM] [PATH_TO_FILE]`"
        return 1
    fi

    if [ ! -e "$file" ]; then
        echo -e "${red}Error${nc}: File not found."
        return 1
    fi

    echo "${sha} ${file}" | shasum -a 256 --check 
}
