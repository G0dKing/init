#!/bin/bash

# >>> Execute one or more commands as background processes and suppress output
# >>> Usage: `bgRun [CMD_1] [CMD_2] [...]`

bg_run() {
    eval "$@" &>/dev/null & disown;
}
