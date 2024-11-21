#!/bin/bash
# dlgd.sh | v. 1.0 | 11.20.24

dlgd() {
    FILE_ID="$1"
    FILE_NAME="$2"

    CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies \
        --no-check-certificate "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O- | \
        sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')
    
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" \
        -O ${FILE_NAME} && rm -rf /tmp/cookies.txt
}
