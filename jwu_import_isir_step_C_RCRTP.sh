#!/bin/sh
#   LOAD ISIR Part C
# Database connection portion


# create a variable containing name of the sql job
#l_sqljob=`echo $PROG | tr "[A-Z]" "[a-z]"`.sql

# create a variable containing the user ID and password


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
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '01', sysdate, $FOURDIGIT );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '02', sysdate, ‘EDE’ );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '03', sysdate, '1');
•	-04-Not used
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '05', sysdate, 'Y' );
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '06', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '07', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '08', sysdate, 'N');
•	09, 10, 11 are N/A
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '12', sysdate, 'Y');
13-Not used
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '14', sysdate, 'B');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '12', sysdate, 'Y');
15 is N/A
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '16', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '17', sysdate, 'N');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '18', sysdate, 'Y');
insert into gjbprun
( gjbprun_job, gjbprun_one_up_no, gjbprun_number, gjbprun_activity_date, gjbprun_value)
values
( "RCRTP${TWODIGIT}" $ONE_UP_NUM, '19', sysdate, 'Y');
\
}


LIST="${HOME}/rcrtp${TWODIGIT}_${ONE_UP_NUM}.lis"
rcrtp${TWODIGIT}  –f –o $LIST

