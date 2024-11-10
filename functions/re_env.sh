#!/bin/bash

# re_env.sh | v. 1.0 | 11.9.24
# Simplify dev-environment management for python

re_env() {
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi

    source venv/bin/activate
}
