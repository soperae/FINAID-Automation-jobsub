#! /bin/sh
# get the next  ONE_UP_NUM


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
select to_char(general.gjbpseq.nextval) from  dual;
EOF`

if [ $ONE_UP_NUM -gt 0 ]
then
echo $ONE_UP_NUM > $TDA_DIR/jwu_ISIR_one_up_num.lst
fi
