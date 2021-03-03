#!/bin/bash
#This script will move the incoming file name from the TDClient
#incoming directory to the financial aid dataload directory in
#support of the RLRDUxx process.  See the Banner FA Handbook
#for reasons why this has to be done with a special copy command.
#Expected parameters:
#$1 - File name
#$2 - Financial aid dataload directory path (no slash at the end)
#$3 - TDClient directory (no slash at the end) N/A  A.Soper 02.16.2021
FILENAME=$1
. $HOME/set_TDA_parameters.sh 
#FIRSTEIGHT=${FILENAME:0:8}
#NEWFILE="$FIRSTEIGHT.dat"
#echo $FIRSTEIGHT
#echo $NEWFILE
for i in `ls $TDA_DIR/incoming/*op*`
do

unix2dos $i

#mv -f $1 $BANNER_HOME/dataload/finaid/$NEWFILE
cp -p $i $BANNER_HOME/dataload/finaid/.
done
