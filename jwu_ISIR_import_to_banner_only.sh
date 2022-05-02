#! /bin/sh
# jwu_ISIR_import_to_banner_only.sh 
#  usage:   jwu_ISIR_import_wrapper.sh 2122
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

RECIPIENT=Dawn.Blanchette@jwu.edu
CC_RECIPIENT=asoper@jwu.edu

rm -f ${TDA_DIR}/jwu_ISIR_one_up_num.lst
#read x

# create a variable containing name of the sql job
#l_sqljob=`echo $PROG | tr "[A-Z]" "[a-z]"`.sql

# create a variable containing the user ID and password

# download the files
### ${TDA_DIR}/jwu_exe_tdclient_isir.sh 
# strip headers and trailer, concatenate, move to $BannerHome/dataload/finaid
#NUM_OF_FILES=`ls incoming/*.tdc |wc -l`
#if [ ${NUM_OF_FILES} -eq 0 ]
#then 
#  echo "TDA ${TDA_ENV} DOWNLOAD ZERO FILES: `date`." | mailx  -s "TDA ${TDA_ENV} DOWNLOAD ZERO FILES" -a ${TDA_DIR}/ftplog.txt -a ${TDA_DIR}/TDAdownload.log -c ${CC_RECIPIENT} ${RECIPIENT} exit 1
#fi
#
#DTE_YMD=`date +%F`
echo 'ENTER THE DATE,YYYY-MM-DD (2021-05-31):' 
read DTE_YMD
echo "DATE ENTERED:" $DTE_YMD
read x
#${TDA_DIR}/jwu_tdc_strip_and_concat_isir.sh
COMB_FILE=${BANNER_HOME}/dataload/finaid/${FOURDIGIT}isir_comb_${DTE_YMD}.tdc
echo ${BANNER_HOME} '/' ${COMB_FILE}
read x
if [ -s ${COMB_FILE} ]
then 
  echo '' 
else
  echo "TDA ${TDA_ENV} CONCAT FILE NO RECORDS: `date`." | mailx  -s "TDA ${TDA_ENV} CONCAT FILE NO RECORDS" -a ${TDA_DIR}/ftplog.txt -a ${TDA_DIR}/TDAdownload.log -c ${CC_RECIPIENT} ${RECIPIENT}
  exit 1
fi
#echo 'AFTER SIZE CHECK'
#read x

#  jobsub steps -  only processing the FINAID steps  A,B, & C
## each jobsub has their own unique one up number 

#  RCPTP21 STEP A -   insert file names into glbprun
${TDA_DIR}/jwu_import_isir_step_A_RCPTP.sh 
return_code=$?

if [ $return_code -eq 0 ]
then

# RCPMTCH STEP B
${TDA_DIR}/jwu_import_isir_step_B_RCPMTCH.sh
 return_code=$?

  if [ $return_code -eq 0 ]
  then

#  RCRTP21 STEP C
${TDA_DIR}/jwu_import_isir_step_C_RCRTP.sh

  return_code=$?
    if [ $return_code -gt 0 ]
    then
 #     echo $return_code '/ RCPTPxx Failed'
      echo "TDA ${TDA_ENV} STEP C FINAID RCRTPxx failed: `date`." | mailx  -s "TDA ${TDA_ENV} RCRTPxx ERROR"  -c ${CC_RECIPIENT} ${RECIPIENT}
    else
      echo "ALL TDA ${TDA_ENV} FINAID JOBSUBS complete with ${COMB_FILE}: `date`." | mailx  -s "TDA ${TDA_ENV} FINAID JOBSUB COMPLETED"   -c ${CC_RECIPIENT} ${RECIPIENT}
    fi
  else
 #   echo $return_code '/' 'RCPMTCH Failed'
    echo "TDA ${TDA_ENV} STEP B FINAID RCPMTCH failed : `date`." | mailx  -s "TDA ${TDA_ENV} RCPMTCH ERROR"   -c ${CC_RECIPIENT} ${RECIPIENT}
  fi
else
 # echo $return_code '/ RCPTPxx Failed'
  echo "TDA ${TDA_ENV} STEP A FINAID RCPTPxx failed all jobs STOP: `date`." | mailx  -s "TDA ${TDA_ENV} RCPTPxx ERROR"  -c ${CC_RECIPIENT} ${RECIPIENT}
  exit 1
fi
