#!/bin/bash

# pfwsl.sh | ver. 1.0 | 11.16.24

# WSL-2 and Win10/11 Port Forwarding Utility

pfwsl() {
    local script=/mnt/c/tools/pfwsl/bin/pfwsl.ps1
    local psexe=/mnt/c/Windows/System32/powershell.exe

    powershell.exe -file $script

}
