#!/bin/bash
# ~/scripts/x.sh
# ver 1.0.1

# Simple tool to move directories without duplicating it.
# Usage: 'x <TARGET_DIR> <DESTINATION>'

x() {
    dir=$1
    dest=$2

   if [ ! -d $dir ]; then
    echo "Error: Invalid Target."
    return 1
   fi
   if [ $# -ne 2 ]; then
    echo "Error: Must provide argument. USAGE: 'x DIR FILEPATH'"
    return 1
   fi

  sudo cp -r $dir $dest
  sudo rm -rf $dir

  return 0
}
