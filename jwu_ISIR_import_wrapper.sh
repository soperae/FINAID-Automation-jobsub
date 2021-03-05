#! /bin/sh
# jwu_ISIR_import_wrapper.sh 
#  usage:   jwu_ISIR_import_wrapper.sh TEST TEST  2122
#  ASoper 3.2.2021
#
. $HOME/set_TDA_parameters.sh
#export l_uid=jwujobs
export l_uid=$( cat $BANNER_HOME/p_usr )
#export l_uid=general
export l_pwd=$( cat $BANNER_HOME/j_system )
export l_uidpwd=${l_uid}/${l_pwd}
export l_job=$0
# first parameter
export l_prog=$1
# second  parameter
export l_prnt=$2
# third parameter
export FOURDIGIT=$3
export TWODIGIT=${FOURDIGIT:2:2}

#echo ${TWODIGIT} '/'  $l_uid '/'$l_pwd '/' $l_uidpwd
#read x

RECIPIENT=asoper@jwu.edu

rm -f $TDA_DIR/jwu_ISIR_one_up_num.lst
#read x

# create a variable containing name of the sql job
#l_sqljob=`echo $PROG | tr "[A-Z]" "[a-z]"`.sql

# create a variable containing the user ID and password

# download the files
###  THIS WORKS
####  testing $TDA_DIR/jwu_exe_tdclient_isir.sh 
# strip headers and trailer, concatenate, move to $BannerHome/dataload/finaid

# THIS WORKS 
###  $TDA_DIR/jwu_tdc_strip_and_concat_isir.sh
## each jobsub has their own unique one up number 

##this moved to step A,B,C scripts --  $TDA_DIR/jwu_get_one_up_num.sh 

# check for

#  jobsub steps -  only processing the FINAID steps  A,B, & C

#  RCPTP21 STEP A -   insert file names into glbprun
sh -x TDA_DIR/jwu_import_isir_step_A_RCPTP.sh 
##sh -x $TDA_DIR/aljunk_stepA.sh
return_code=$?
  echo $return_code '/ ' POST RCPTPXX STOP HERE'
  read x

if [ $return_code -eq 0 ]
then

# RCPMTCH STEP B
sh -x $TDA_DIR/jwu_import_isir_step_B_RCPMTCH.sh
# sh -x $TDA_DIR/aljunk_stepB.sh
  return_code=$?
  echo $return_code '/ POST RCPMTCH STOP HERE'
  read x
  if [ $return_code -eq 0 ]
  then

#  RCRTP21 STEP C
sh -x $TDA_DIR/jwu_import_isir_step_C_RCRTP.sh
## $TDA_DIR/aljunk_stepC.sh

  return_code=$?
  echo $return_code '/ '
# read x
    if [ $return_code -gt 0 ]
    then
      echo $return_code '/ RCPTPxx Failed'
      echo "TDA STEP C FINAID RCRTPxx failed: `date`." | mailx  -s "TDA RCRTPxx ERROR" -c $RECIPIENT 
    else
      echo "ALL TDA FINAID JOBSUBS complete: `date`." | mailx  -s "TDA FINAID JOBSUB COMPLETED" -c $RECIPIENT 
    fi
  else
    echo $return_code '/' 'RCPMTCH Failed'
    echo "TDA STEP B FINAID RCPMTCH failed : `date`." | mailx  -s "TDA RCPMTCH ERROR" -c $RECIPIENT 
  fi
else
  echo $return_code '/ RCPTPxx Failed'
  echo "TDA STEP A FINAID RCPTPxx failed all jobs STOP: `date`." | mailx  -s "TDA RCPTPxx ERROR" -c $RECIPIENT 
  exit 1
fi
