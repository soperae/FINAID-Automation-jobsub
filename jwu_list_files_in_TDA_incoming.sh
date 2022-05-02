#! /bin/sh
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 

cd $TDA_DIR/incoming
ISIR_FILES=`ls i*.tdc`
echo $ISIR_FILES

#re="^([^-]+)-(.*)$"
re="^([^ ]+)-(.*)$"
[[ $ISIR_FILES =~ $re ]] && var1="${BASH_REMATCH[1]}" && var2="${BASH_REMATCH[2]}"
echo $var1
echo $var2
