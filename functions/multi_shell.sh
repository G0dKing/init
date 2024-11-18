#!/bin/bash

# multi_shell.sh | v 1.0 | 11.14.24


multi_shell() {
    tmux new -s $1

}

tmux_cmd() {
    echo -e "Prefix: Ctrl-B"
    echo -e "      % : split vertically"
    echo -e "      c : new window"
    echo -e "      p : previous window"
    echo -e "      n : next window"
    echo -e "    0-9 : switch to window by number"
    echo -e "      & : force quit"
}
