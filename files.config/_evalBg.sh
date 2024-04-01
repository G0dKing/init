#!/bin/bash

_evalBg() {
    eval "$@" &>/dev/null & disown;
}
