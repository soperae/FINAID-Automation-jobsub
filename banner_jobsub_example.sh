#!/bin/sh
#
# Name:    swc_update_campus_transfer_roles.sh
#
# Author:  styner
#
# Created: 02/20/2017 
# 
# Comment:
#    Update transfer student roles by running Banner job submission at the command line
#    Run the following  jobs:
#    Database: jwu.SWS_CAMPUS_TRANSFER_STUDENTS 
#    GURIROL -  Banner baseline job to populate roles
#    ICGORODM - Banner baseline job to send (push) Banner roles to Luminis (JWU Link) 
#
# History:
#   Tag  Date        Who        Description of Change
#   ---  ----------  ---------- ------------------------------------
#
#
####################################################################################
#
# Parameters for GORIROL (using pop-sel values)
#  *******************************************************
#  01 - Application Code:  value -> STUDENT 
#  02 - Selection ID    :  value -> CAMPUS_TRANSFER_MANUAL
#  03 - Creator ID      :  value -> STYNER 
#  04 - User ID         :  value -> STYNER
#  05 - Role Group      :  value -> INTCOMP
#  06 - Role            :  value -> < blank >
#  *******************************************************
#
#  Parameters for ICGORDOM (using pop-sel values):
#  *******************************************************
#  01 - Application Code:  value -> STUDENT 
#  02 - Selection ID    :  value -> CAMPUS_TRANSFER_MANUAL
#  03 - User ID         :  value -> STYNER
#  04 - Creator ID      :  value -> STYNER 
#  05 - Spriden ID      :  value -> < blank >
#  06 - Subject Code    :  value -> < blank >
#  07 - Course Number   :  value -> < blank >
#  08 - CRN             :  value -> < blank >
#  09 - TERM            :  value -> < blank > 
#  *******************************************************

 
. /opt2/jwu/env
. /opt2/sct/banner/.profile

#  set up environment variables to run job at command line
HOME="$BANNER_BANJOBS" H="$HOME"
SCRIPT_LOG="/opt2/jwu/log/swc_update_campus_tranfer_roles.log"
touch $SCRIPT_LOG
chmod 777 $SCRIPT_LOG

DTE=`date`
echo "$DTE $0 started" |   tee -ai $SCRIPT_LOG


PASS=`cat $BANNER_HOME/p_system2`
USR=`cat $BANNER_HOME/p_usr`
l_uidpwd=${USR}/${PASS}

ROLE=`sqlplus -s <<EOF 
$l_uidpwd
set showmode off

set timing off
set heading off
set pagesize 1
set tab off
set trim on
set feedback off
-- add pipe |" for column seperator since the output has a lot of unnecesary garbage 
select '|' || to_char(general.gjbpseq.nextval)
from  dual;
EOF`
# use pipe "|" as column delimiter (-d"|")

ROLE_ONE_UP=`echo $ROLE | cut -f2 -d"|"`

ROLE_JOB="gurirol"
ROLE_TEMP="${ROLE_JOB}_${ROLE_ONE_UP}"
ROLE_LOG="$HOME/${ROLE_TEMP}.log"
ROLE_IN="$HOME/${ROLE_TEMP}.in"
touch $ROLE_LOG
chmod 777 $ROLE_LOG
ROLE_LIST="${HOME}/gurirol_${ROLE_ONE_UP}.lis"
touch $ROLE_LIST
chmod 777 $ROLE_LIST
ROLE_OUTPUT=${ROLE_JOB}.lis

USER=jwujobs
PASS=`cat $BANNER_HOME/j_system`
touch $ROLE_IN    
chmod 777 $ROLE_IN
echo "${USER}/${PASS}" >> $ROLE_IN 
echo "$ROLE_ONE_UP" >>  $ROLE_IN 
echo " " >> $ROLE_IN  


ONE=`sqlplus -s <<EOF 
$l_uidpwd
set showmode off
set timing off
set heading off
set pagesize 1
set tab off
set trim on
set feedback off

-- add pipe |" for column seperator since the output has a lot of unnecesary garbage 
select '|' || to_char(general.gjbpseq.nextval)
from  dual;
EOF`

# use pipe "|" as column delimiter (-d"|")
ONE_UP=`echo $ONE | cut -f2 -d"|"`

JOB="icgorodm"
TEMP="${JOB}_${ONE_UP}"
LOG="$HOME/${TEMP}.log"
IN="$HOME/${TEMP}.in"

touch $LOG
chmod 777 $LOG

LIST="${HOME}/icgorodm_${ONE_UP}.lis"
touch $LIST
chmod 777 $LIST


if [ "$1" == "" ] 
then 
  application="STUDENT"
  selection="CAMPUS_TRANSFER_MANUAL"  
  creator_id="STYNER"
  user_id="STYNER"
else  # need ALL parameters to have values - so check the last one $4
  if [ "$4" == "" ]
  then 
    application="STUDENT"
    selection="CAMPUS_TRANSFER_MANUAL"  
    creator_id="STYNER"
    user_id="STYNER"
  else
    application="$1"
    selection="$2"  
    creator_id="$3"
    user_id="$4"
  fi 
fi 

DTE=`date`
echo "$DTE sqlplus started" | tee -ai $SCRIPT_LOG

# Run these sqlplus  steps:
# 1. Load the pidms in jwu.pidm_temp table into the pop-sel table, glbextr 
# 2. Load the parameters for gurirol into gbjprun - to prepare for the running of gurirol
# 3. Load the parameters for icgorodm into gbjprun - to prepare for the running of icgorodm

sqlplus -s <<EOF >>$SCRIPT_LOG
$l_uidpwd
-- load jwu.pidm_temp table and then glbextr table via this procedure
exec jwu.sws_campus_transfer_students('$application', '$selection', '$user_id', '$creator_id');
-- insert parameters (5 Pop-Sel parameter) into gjbprun for gurirol process
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$ROLE_JOB'), $ROLE_ONE_UP, '01', sysdate, upper('$application') );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$ROLE_JOB'), $ROLE_ONE_UP, '02', sysdate, upper('$selection') );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$ROLE_JOB'), $ROLE_ONE_UP, '03', sysdate, upper('$creator_id') );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$ROLE_JOB'), $ROLE_ONE_UP, '04', sysdate, upper('$user_id') );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$ROLE_JOB'), $ROLE_ONE_UP, '05', sysdate, 'INTCOMP');

-- insert parameters (4 Pop-Sel parameter) into gjbprun for icgorodm process
insert into gjbprun 
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$JOB'), $ONE_UP, '01', sysdate, upper('$application') );
insert into gjbprun 
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$JOB'), $ONE_UP, '02', sysdate, upper('$selection') );
insert into gjbprun 
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$JOB'), $ONE_UP, '03', sysdate, upper('$user_id') );
insert into gjbprun 
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( upper('$JOB'), $ONE_UP, '04', sysdate, upper('$creator_id') );
exit;
EOF


# Create roles in Banner 
DTE="`date`"
echo "Start ......... $DTE" >>  $ROLE_LOG
echo " " >> $SCRIPT_LOG
echo "$DTE gurirol -f -o $ROLE_LIST started"  |  tee -ai  $SCRIPT_LOG
gurirol -f -o $ROLE_LIST  < $ROLE_IN 1>> $ROLE_LOG 2>&1
echo " " >> $ROLE_LIST
cat $ROLE_LIST >> $ROLE_LOG 

DTE="`date`"
echo "End ......... $DTE"  >> $ROLE_LOG
echo "$DTE gurirol -f -o $ROLE_LIST ended" | tee -ai  $SCRIPT_LOG


touch $IN    
chmod 777 $IN
echo "${USER}/${PASS}" >> $IN 
echo "$ONE_UP" >>  $IN 
echo "" >> $IN  

# Push roles to Luminis 
DTE="`date`"
echo "Start ......... $DTE"  >> $LOG
echo " " >> $SCRIPT_LOG
echo "$DTE icgorodm -f -o $LIST started" >> $SCRIPT_LOG
icgorodm -f -o $LIST  < $IN 1>> $LOG 2>&1
echo " " >> $LIST
cat $LIST >> $LOG

DTE="`date`"
echo "End ........... $DTE"  >> $LOG
echo " " >> $LOG
echo "$DTE icgorodm -f -o $LIST ended"  | tee -ai $SCRIPT_LOG
echo " " >> $SCRIPT_LOG

# Clean up .in files
rm $ROLE_IN
rm $IN

echo "$DTE $0 ended"  | tee -ai  $SCRIPT_LOG
echo " " >> $SCRIPT_LOG

exit 0;

