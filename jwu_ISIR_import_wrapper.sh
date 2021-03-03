#! /bin/sh
# jwu_ISIR_import_wrapper.sh 
#  usage:   jwu_ISIR_import_wrapper.sh TEST TEST  2122
#  ASoper 3.2.2021
#
. $HOME/set_TDA_parameters.sh
export l_uid=$( cat $BANNER_HOME/p_usr )
#export l_uid=general
export l_pwd=$( cat $BANNER_HOME/p_system )
export l_job=$0
# first parameter
export l_prog=$1
# second  parameter
export l_prnt=$2
# third parameter
export FOURDIGIT=$3
export TWODIGIT=${FOURDIGIT:2:2}
#echo ${TWODIGIT} '/'  $l_uid '/'$l_pwd
RECIPIENT=asoper@jwu.edu
##  testing rm -f $TDA_DIR/jwu_ISIR_one_up_num.lst
#read x

# create a variable containing name of the sql job
#l_sqljob=`echo $PROG | tr "[A-Z]" "[a-z]"`.sql

# create a variable containing the user ID and password
export l_uidpwd=${l_uid}/${l_pwd}

# download the files
####  testing $TDA_DIR/jwu_exe_tdclient_isir.sh 
# strip headers and trailer, concatenate, move to $BannerHome/dataload/finaid

$TDA_DIR/jwu_tdc_strip_and_concat_isir.sh
## no need to run the oneup while testing  

## testing $TDA_DIR/jwu_get_one_up_num.sh 

if [ -s $TDA_DIR/jwu_ISIR_one_up.lst ]
then

   ONE_UP_NUM_TEST=`cat $TDA_DIR/jwu_ISIR_one_up.lst`

if [ $ONE_UP_NUM_TEST -gt 0 ]
then
    echo $ONE_UP_NUM_TEST "good"

#  jobsub steps -  only processing the FINAID steps  A,B, & C
#  RCPTP21 -   insert file names into glbprun
#. $TDA_DIR/jwu_import_isir_step_A_RCPTP.sh 
#  RCPMTCH
#. $TDA_DIR/jwu_import_isir_step_B_RCPMTCH.sh
#  RCRTP21
#. $TDA_DIR/jwu_import_isir_step_C_RCRTP.sh
else
    echo "ONE UP NUM NOT NUMERIC OR GT ZERO"
    echo $ONE_UP_NUM_TEST
  #  echo "TDA FINAID ONEUP number not numeric or greter than zero on `date`." | mailx  -s "TDA ONE UP NUMBER ERROR" -c $RECIPIENT 
fi
else 
    echo "NO ONE UP NUM FILE"
    echo $ONE_UP_NUM_TEST
  #  echo "TDA FINAID ONEUP number didn't get created: `date`." | mailx  -s "TDA ONE UP NUMBER ERROR" -c $RECIPIENT 
    exit 1
fi
