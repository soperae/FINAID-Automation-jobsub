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
	

insert_into_gjbprun() {
sqlplus -s <<EOF
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
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '01', sysdate, ${FOURDIGIT} );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '02', sysdate, 'EDE' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '03', sysdate, '${FOURDIGIT}isir_comb.tdc');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '04', sysdate, 'G');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '05', sysdate, 'N' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '06', sysdate, 'MA');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '07', sysdate, 'MA');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '08', sysdate, 'PERF');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '09', sysdate, 'PARF');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '10', sysdate, 'Y’);
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values ( 'RCPTP${TWODIGIT}' $ONE_UP_NUM, '11', sysdate, '${FOURDIGIT}EDEError.txt');
\
}


LIST="${HOME}/rcrtp${TWODIGIT}_${ONE_UP_NUM}.lis"
rcrtp21 –f –o $LIST

