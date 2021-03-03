#!/bin/bash
#Expected parameters:
#$1 - Full directory path
NUMBEROFFILES="$(find $1 -maxdepth 1 -type f -print | wc -l)"
echo "Location: $1"
echo "File count: $NUMBEROFFILES"

