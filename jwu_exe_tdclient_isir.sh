#This script will execute tdclientc and download all necessary files for an ISIR
#load.
#Expected parameters:
#$1=four digit aid year (1314)
#$2=the TDClient path (no slash at the end)

#Derive the two digit aid year
##FOURDIGIT=$1
#TWODIGIT=${FOURDIGIT:2:2}
#echo $TWODIGIT
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 
#clean incoming directory before downloading
#rm -f $TDA_DIR/incoming/*op*.tdc

#build command file
echo 'transfer=(name=RECVCLASS_ISIR1  RECEIVECLASS=IDSA'$TWODIGIT'OP    receive=./incoming/idsa'$TWODIGIT'op.tdc  UNCOMP=Y  APPEND=Y  AUTOEXT=3)
transfer=(name=RECVCLASS_ISIR2  RECEIVECLASS=IGSA'$TWODIGIT'OP    receive=./incoming/igsa'$TWODIGIT'op.tdc  UNCOMP=Y  APPEND=Y  AUTOEXT=3)
transfer=(name=RECVCLASS_ISIR3  RECEIVECLASS=ISRF'$TWODIGIT'OP    receive=./incoming/isrf'$TWODIGIT'op.tdc  UNCOMP=Y  APPEND=Y  AUTOEXT=3)
transfer=(name=RECVCLASS_ISIR4  RECEIVECLASS=IGSG'$TWODIGIT'OP    receive=./incoming/igsg'$TWODIGIT'op.tdc  UNCOMP=Y  APPEND=Y  AUTOEXT=3)
transfer=(name=RECVCLASS_ISIR5  RECEIVECLASS=IDAP'$TWODIGIT'OP    receive=./incoming/idap'$TWODIGIT'op.tdc  UNCOMP=Y  APPEND=Y  AUTOEXT=3)
transfer=(name=RECVCLASS_ISIR6  RECEIVECLASS=IGCO'$TWODIGIT'OP    receive=./incoming/igco'$TWODIGIT'op.tdc  UNCOMP=Y  APPEND=Y  AUTOEXT=3)
save' > $TDA_DIR/maint/recvclass_ISIR.c

#Addition of tdclient path necessary for each execution since it is being reset
#by other methods.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TDA_DIR

#Change directory to area of execution
# already here 2.16.2021 A.Soper
# cd $TDA_DIR

#Execute TDClient naming the desired command file
./tdclientc "network=saigportal${TDA_ENV}" RESPLOG="./temp/resplog.txt" CMDFILE="./maint/recvclass_ISIR.c" RESET

