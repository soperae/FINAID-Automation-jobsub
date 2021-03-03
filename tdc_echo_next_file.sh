#!/bin/bash
#Expected parameters
#$1 - Full path to directory location
cd $1
FILE=$(ls -1 | head -n 1)
echo "This is the next file $FILE"

