#!/bin/bash

unixify() {
	for file in $scripts/*.sh; do
	    dos2unix $file
	done
}


