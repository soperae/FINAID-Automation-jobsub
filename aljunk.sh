#! /bin/sh
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 

RECIPIENT=asoper@jwu.edu
CC_RECIPIENT=albert.soper@jwu.edu

l_uid=$( cat $BANNER_HOME/p_usr )
l_pwd=$( cat $BANNER_HOME/p_system2 )
l_job=$0
l_prog=$1
l_prnt=$2
FOURDIGIT=$3
TWODIGIT=${FOURDIGIT:2:2}
echo $FOURDIGIT '/' $TWODIGIT
echo "RCR${TWODIGIT}" ' / ' $l_uid
echo $BANNER_HOME

PSWD=junk
BANUID=al

      case $PSWD in
         /) UIPW=$PSWD
            echo 'SLASH';;
         *) UIPW=$BANUID/$PSWD
            echo 'STAR';;
      esac

echo $UIPW

echo $RECIPIENT
echo $CC_RECIPIENT
DTE_YMD=`date +%F`

echo $DTE_YMD

#echo "TDA ALJUNK FINAID ${TDA_ENV}" | mailx  -s "TDA RCRTPxx ALJUNK ${TDA_ENV}" -c ${CC_RECIPIENT} ${RECIPIENT}
echo `date` > $TDA_DIR/incoming/aljunk.tst

