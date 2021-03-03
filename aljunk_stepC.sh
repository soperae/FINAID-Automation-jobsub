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
# use concatenaged file that is sent to $BANNER_HOME/dataload/finaid 
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

#  set up environment variables to run job at command line
HOME="$BANNER_BANJOBS" H="$HOME"
SCRIPT_LOG="/opt2/jwu/log/jwu_tdclient_finaid_automation.log"
	
JOB="rcrtp${TWODIGIT}"
TEMP="${JOB}_${ONE_UP}"
LOG="$HOME/${TEMP}.log"
IN="$HOME/${TEMP}.in"

DTE=`date`
echo "$DTE rcrtp${TWODIGIT} sqlplus started" | tee -ai $SCRIPT_LOG


echo $JOB '/' $TEMP '/' $LOG '/' $IN '/' $HOME
read x

$TDA_DIR/jwu_get_one_up_num.sh
return_code=$?
echo $return_code '/' $ONE_UP_NUM 'RCRTPxx'
if [ $return_code -eq 1 ]
then
  exit 1
fi
