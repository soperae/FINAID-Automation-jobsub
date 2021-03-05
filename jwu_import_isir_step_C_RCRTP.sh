#!/bin/sh
#   LOAD ISIR Step A. jwu_import_isir_step_A_RCRTP.sh

# Name:    jwu_import_isir_step_A_RCRTP.sh
#
# Author:  ASoper
#
# Created: 03.02.2021 
# 
# Comment:
#    import RCRTP data for FINAID  by running Banner job submission at the command line
#    Run the following  jobs:
#    RCRTPXX - Banner baseline job to send DEpt of ED concatenated file to Banner
#
# History:
#   Tag  Date        Who        Description of Change
#   ---  ----------  ---------- ------------------------------------
#
#
# use concatenated file that is sent to $BANNER_HOME/dataload/finaid 
# parameters for RCRTPxx
#	01-Aid Year=2021
#	02-Data Source Code=EDE
#	03-Load Option for Need Analysis=1(load all records that match as current EDE record)
#	04-Not used
#	05-NSLDS print option=Y (for discrepancy report)
#	06-Need Analysis Print Option=Y
#	07-Recruiting Option=N
#	08-Recalc Need Analysis Option=N
#	09-NSLDS Output App ID=N/A
#	10-NSLDS Output Selection ID=N/A
#	11-NSLDS Output Creator ID=N/A
#	12-ISIR Creation Option=Y (to print ISIR records this has be a Yes)
#	13-Not used
#	14-Process Indicator=B (batch process)
#	15-Temporary PIDM=N/A
#	16-Update Postal Address=N
#	17-Update Telephone Number=N
#	18-Update E-mail address=Y
#	19-Update Social Security number=Y

. /opt2/jwu/env
. /opt2/sct/banner/.profile

l_uid=jwujobs
#export l_uid=general
l_pwd=$( cat $BANNER_HOME/j_system )
l_uidpwd=${l_uid}/${l_pwd}

#  set up environment variables to run job at command line
#HOME="$BANNER_BANJOBS" H="$HOME"
SCRIPT_LOG="/opt2/jwu/log/jwu_tdclient_finaid_auto_stepC_RCRTPXX.log"
	

DTE=`date`
echo "$DTE rcrtp${TWODIGIT} sqlplus started" | tee -ai $SCRIPT_LOG

$TDA_DIR/jwu_get_one_up_num.sh
return_code=$?

# Validate the one up number
if [ -s $TDA_DIR/jwu_ISIR_one_up_num.lst ]
then
  ONE_UP_NUM=`cat $TDA_DIR/jwu_ISIR_one_up_num.lst`
  if [ $ONE_UP_NUM -gt 0 ]
  then
    echo $ONE_UP_NUM "good"
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

JOB="rcrtp${TWODIGIT}"

JOB_TEMP="${JOB}_${ONE_UP_NUM}"
JOB_LOG="$BANNER_BANJOBS/${JOB_TEMP}.log"
JOB_IN="$BANNER_BANJOBS/${JOB_TEMP}.in"

chmod 777 $JOB_IN
echo "${l_uidpwd}" >> $JOB_IN
echo "$ONE_UP_NUM" >>  $JOB_IN
echo " " >> $JOB_IN



echo $FOURDIGIT '/' $TWODIGIT '/' $ONE_UP_NUM '/' $BANNER_BANJOBS '/STOP HERE'
read x 

insert_into_gjbprun() {
sqlplus -s <<EOF >> ${SCRIPT_LOG}
$l_uidpwd
set showmode off

set timing off
set heading off
set pagesize 1
set tab off
set trim on
set feedback off
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '01', sysdate, '${FOURDIGIT}' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '02', sysdate, 'EDE' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '03', sysdate, '1');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '05', sysdate, 'Y' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '06', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '07', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '08', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '09', sysdate, 'N/A');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '10', sysdate, 'N/A’);
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '11', sysdate, 'N/A');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '12', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '14', sysdate, 'B');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '15', sysdate, 'N/A');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '16', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '17', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '18', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCRTP${TWODIGIT}' $ONE_UP_NUM, '19', sysdate, 'Y');
exit;
EOF
}


DTE=`date`
LIST="${BANNER_BANJOBS}/${JOB_TEMP}.lis"

echo "Start ......... $DTE" >>  $JOB_LOG
echo " " >> $SCRIPT_LOG
echo "$DTE ${JOB} -f -o $LIST started"  |  tee -ai  $SCRIPT_LOG

${JOB} –f –o $LIST <$JOB_IN 1>> $JOB_LOG 2>&1


echo " " >> $LIST
cat $LIST >> $JOB_LOG

DTE="`date`"
echo "End ......... $DTE"  >> $JOB_LOG
echo "$DTE ${JOB} -f -o $LIST ended" | tee -ai  $SCRIPT_LOG

# clean up  one up file
rm  -f $TDA_DIR/jwu_ISIR_one_up_num.lst

