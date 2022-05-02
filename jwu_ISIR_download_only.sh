#! /bin/sh
# jwu_ISIR_import_wrapper.sh 
#  usage:   jwu_ISIR_import_wrapper.sh TEST TEST  2122
#  ASoper 3.2.2021
#
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 
. /opt2/jwu/env
. /opt2/sct/banner/.profile

#export l_uid=jwujobs
export l_uid=$( cat $BANNER_HOME/p_usr )
#export l_uid=general
export l_pwd=$( cat $BANNER_HOME/j_system )
export l_uidpwd=${l_uid}/${l_pwd}
#export l_job=$0
# first parameter
#export l_prog=$1
# second  parameter
#export l_prnt=$2
# third parameter

export FOURDIGIT=$1
export TWODIGIT=${FOURDIGIT:2:2}

#echo ${TWODIGIT} '/'  $l_uid '/'$l_pwd '/' $l_uidpwd
#read x

CC_RECIPIENT=ITApplicationInfrastructure@jwu.edu
#RECIPIENT=Dawn.Blanchette@jwu.edu
RECIPIENT=asoper@jwu.edu

rm -f $TDA_DIR/jwu_ISIR_one_up_num.lst
rm -f $TDA_DIR/incoming/*.tdc
#read x

# create a variable containing name of the sql job
#l_sqljob=`echo $PROG | tr "[A-Z]" "[a-z]"`.sql

# create a variable containing the user ID and password

# download the files
###  THIS WORKS
sh -x $TDA_DIR/jwu_exe_tdclient_isir.sh 
return_code=$?
#  sometimes SAIG doesn't end and close its transmission channel cleanly. a soper 20210607 added workaround for code 221
if [ $return_code -eq 221 ]
then
   return_code=0
fi

NUM_OF_FILES=`ls incoming/*.tdc |wc -l`
#echo $NUM_OF_FILES  "NUM OF FILES"
#read x
if [ $NUM_OF_FILES -eq 0 ]
then
  echo "TDA ${TDA_ENV} DOWNLOAD ZERO FILES: `date`." | mailx  -s "TDA ${TDA_ENV} DOWNLOAD ZERO FILES" -a ${TDA_DIR}/ftplog.txt -a ${TDA_DIR}/TDAdownload.log -c ${CC_RECIPIENT} ${RECIPIENT}
  exit 1
fi
DTE_YMD=`date +%F`
# strip headers and trailer, concatenate, move to $BannerHome/dataload/finaid
if [ $return_code -eq 0 ]
then
  $TDA_DIR/jwu_tdc_strip_and_concat_isir.sh
  return_code=$?
  COMB_FILE=${BANNER_HOME}/dataload/finaid/${FOURDIGIT}isir_comb_${DTE_YMD}.tdc
  if [ -s $COMB_FILE ]
  then
     echo ''
  else
    echo "TDA ${TDA_ENV} CONCAT FILE NO RECORDS: `date`." | mailx  -s "TDA ${TDA_ENV} CONCAT FILE NO RECORDS" -a ${TDA_DIR}/TDAdownload.log -c ${CC_RECIPIENT}  ${RECIPIENT}
    exit 1
  fi
#  echo 'AFTER SIZE CHECK'
#  read x

    if [ $return_code -gt 0 ]
    then
      echo "TDA ${TDA_ENV} CONCATENATE FAILED: `date`." | mailx  -s "TDA ${TDA_ENV} CONCATENATE ERROR" -a ${TDA_DIR}/TDAdownload.log -c ${CC_RECIPIENT} ${RECIPIENT}
    else
      echo "TDA ${TDA_ENV} DOWNLOAD AND CONCATENTATE complete ${COMB_FILE}: `date`." | mailx  -s "TDA ${TDA_ENV} DOWNLOAD AND CONCATENATE COMPLETED" -c ${CC_RECIPIENT}  ${RECIPIENT}
    fi
else
  echo "TDA ${TDA_ENV} DOWNLOAD FAILED: `date`." | mailx  -s "TDA ${TDA_ENV} DOWNLOAD ERROR"  -a ${TDA_DIR}/ftplog.txt -a ${TDA_DIR}/TDAdownload.log -c ${CC_RECIPIENT} ${RECIPIENT}
  exit 1
fi
