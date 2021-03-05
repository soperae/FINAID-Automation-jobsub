#!/bin/sh
#   LOAD ISIR Step A. jwu_import_isir_step_A_RCPTP.sh

# Name:    jwu_import_isir_step_A_RCPTP.sh
#
# Author:  ASoper
#
# Created: 03.02.2021 
# 
# Comment:
#    import RCPTP data for FINAID  by running Banner job submission at the command line
#    Run the following  jobs:
#    Database: jwu.SWS_CAMPUS_TRANSFER_STUDENTS 
#    RCPTPXX - Banner baseline job to send DEpt of ED concatenated file to Banner
#
# History:
#   Tag  Date        Who        Description of Change
#   ---  ----------  ---------- ------------------------------------
#
#
# use concatenaged file that is sent to $BANNER_BANNER_BANJOBS/dataload/finaid 
# parameters for RCPTPxx
#	01-Aid Year Code for = 2021
#	02-Data Source Code= EDE 
#	03-Import concatenated Filename =  (AIDYEAR)isir_comp.tdc
#	04-Generated ID/Use SSN Indicator=G (Generated ID)
#	05-Recalculate Need Indicator=N (Unless IFM)
#	06-Address Type Code=MA (mailing)
#	07-Telephone Type=MA (mailing)
#	08-Student Email Address Type Code= PERF (personal)
#	09-Parent Email Address Type Code= PARF (parent)
#	10-Export Errors= Y
#	11-Export File Name= 2021EDEError.txt
. /opt2/jwu/env
. /opt2/sct/banner/.profile

l_uid=jwujobs
#export l_uid=general
l_pwd=$( cat $HOME/j_system )
l_uidpwd=${l_uid}/${l_pwd}

#echo $l_uidpwd '|  user info STOP HERE'
#read x

#  set up environment variables to run job at command line
#HOME="$BANNER_BANJOBS" 
SCRIPT_LOG="/opt2/jwu/log/jwu_tdclient_finaid_automation.log"
	
JOB="rcptp${TWODIGIT}"

DTE=`date`
echo "$DTE rcptp${TWODIGIT} sqlplus started" | tee -ai $SCRIPT_LOG
# pass the one up number in the return code 
sh -x $TDA_DIR/jwu_get_one_up_num.sh
return_code=$?

if [ -s $TDA_DIR/jwu_ISIR_one_up_num.lst ]
then

   ONE_UP_NUM=`cat $TDA_DIR/jwu_ISIR_one_up_num.lst`

if [ $ONE_UP_NUM -gt 0 ]
then
    echo $ONE_UP_NUM "good"

#  jobsub steps -  only processing the FINAID steps  A,B, & C
#  RCPTP21 -   insert file names into glbprun
#. $TDA_DIR/jwu_import_isir_step_A_RCPTP.sh 
#  RCPMTCH
#. $TDA_DIR/jwu_import_isir_step_B_RCPMTCH.sh
#  RCRTP21
#. $TDA_DIR/jwu_import_isir_step_C_RCRTP.sh
else
    echo "ONE UP NUM NOT NUMERIC OR GT ZERO"
    echo $ONE_UP_NUM
  #  echo "TDA FINAID ONEUP number not numeric or greter than zero on `date`." | mailx  -s "TDA ONE UP NUMBER ERROR" -c $RECIPIENT 
fi
else 
    echo "NO ONE UP NUM FILE"
    echo $ONE_UP_NUM
  #  echo "TDA FINAID ONEUP number didn't get created: `date`." | mailx  -s "TDA ONE UP NUMBER ERROR" -c $RECIPIENT 
    exit 1
fi

export TEMP="${JOB}_${ONE_UP_NUM}"
export LOG="$BANNER_BANJOBS/${TEMP}.log"
export IN="$BANNER_BANJOBS/${TEMP}.in"
echo $JOB '/' $TEMP '/' $LOG '/' $IN '/' $BANNER_BANJOBS '/' $ONE_UP_NUM '/' $TWODIGIT 'just before sql'
read x

sqlplus -s <<EOF >>$SCRIPT_LOG
$l_uidpwd
select sysdate from dual;
exit;
EOF

# clean up  one up file
rm  -f $TDA_DIR/jwu_ISIR_one_up_num.lst

## stop all if error
if [ $return_code -eq 1 ]
then
  exit 1
fi
