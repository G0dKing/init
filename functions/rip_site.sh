#!/bin/bash

rip_site() {
     local site=$1
     local cmd='wget --mirror --page-requisites --adjust-extension --span-hosts --convert-links --execute robots=off --wait=2 --random-wait --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --no-parent'

     if ! command "wget" &>/dev/null; then
          sudo apt install wget
     fi

     if [[ -z "$site" ]]; then
          echo "Error: Must pass target website as argument."
          echo "Example Usage: $(rip_site https://example.com)"
          return 1
     else
          eval $cmd $site
     fi
}
