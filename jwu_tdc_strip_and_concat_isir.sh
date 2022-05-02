#!/bin/bash
#This script will strip header and footer records for files associated with ISIR
#load and concatenate into the .tap file.  Basically, this is to mimic the
#functionality of filecat.exe in Windows.
#
#Parameter $1 is meant to be the aid year associated with the process.
#Parameter $2 is meant to be the TDClient path (no slash at the end)
#Parameter $3 is meant to be the $DATA_HOME/finaid path (no slash at the end)
#example execution:
#./tdc_strip_and_concat_isir.sh 1718 /appworx/Tdbs1/TDClient /global/apwx/Tusrlibs/finaid
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 

DTE_YMD=`date +%F`
FILES="$TDA_DIR/incoming/*op*.tdc"
NEWFILE="$TDA_DIR/incoming/${FOURDIGIT}isir_comb_${DTE_YMD}.tdc"
#echo $NEWFILE

#make sure the .tap file doesn't exist before creating
#if the date folder doesn't exist, then create it
if [ -f $NEWFILE ]; then
  # Control will enter here if $NEWFILE exists.
  rm $NEWFILE
fi

NUMBEROFFILES="$(find $TDA_DIR/incoming -maxdepth 1 -name '*.tdc' -type f -print| wc -l)"

if [ $NUMBEROFFILES != '0' ]; then

  for f in $FILES
  do
    echo "Processing $f file..."
    # take action on each file. $f stores current file name
    sed '1d;$d' $f >> $NEWFILE
  done

else

  echo -n "" > $NEWFILE

fi

#move the .tap file to the dataload folder
mv -f $NEWFILE $BANNER_HOME/dataload/finaid/.

#cleanup incoming directory, no need to keep numbered files. Can reuse same 'base' file each time ASoper 2.26.2021
# 
#rm -f $TDA_DIR/incoming/*.tdc
mv  $TDA_DIR/incoming/*.tdc

