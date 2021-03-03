#!/bin/sh
#   LOAD ISIR Part C
# Database connection portion

l_uid=$( cat $BANNER_HOME/p_usr )
l_pwd=$( cat $BANNER_HOME/p_system2 )
l_job=$0
l_prog=$1
l_prnt=$2
FOURDIGIT=$3
TWODIGIT=${FOURDIGIT:2:2}
echo $TWODIGIT


# create a variable containing name of the sql job
l_sqljob=`echo $PROG | tr "[A-Z]" "[a-z]"`.sql

# create a variable containing the user ID and password
l_uidpwd=${l_uid}/${l_pwd}


get_one_up() {
ONE_UP_NUM=`sqlplus -s <<EOF 
$l_uidpwd
set showmode off

set timing off
set heading off
set pagesize 1
set tab off
set trim on
set feedback off
-- add pipe |" for column separator since the output has a lot of unnecessary garbage 
select '|' || to_char(general.gjbpseq.nextval) from  dual;
EOF`
}

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
values
( ‘RCRTP21’ $ONE_UP_NUM, '01', sysdate, '2021' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '02', sysdate, ‘EDE’ );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '03', sysdate, '1');
•	-04-Not used
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '05', sysdate, 'Y' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '06', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '07', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '08', sysdate, 'N');
•	09, 10, 11 are N/A
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '12', sysdate, 'Y');
13-Not used
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '14', sysdate, 'B');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '12', sysdate, 'Y');
15 is N/A
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '16', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '17', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '18', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( ‘RCRTP21’ $ONE_UP_NUM, '19', sysdate, 'Y');
\
}


LIST="${HOME}/rcrtp21_${ONE_UP_NUM}.lis"
rcrtp21 –f –o $LIST

