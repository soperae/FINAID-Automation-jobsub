#! /bin/sh
# get the next  ONE_UP_NUM

l_uid=$( cat $BANNER_HOME/p_usr )
##export l_uid=general
l_pwd=$( cat $BANNER_HOME/p_system )
l_uidpwd=${l_uid}/${l_pwd}

#echo $ORACLE_SID
#read x

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
  # echo $ONE_UP_NUM "good"
    echo $ONE_UP_NUM > $TDA_DIR/jwu_ISIR_one_up_num.lst
    echo $ONE_UP_NUM
#    read x
    exit 0
else
    echo "ONE UP NUM NOT NUMERIC OR GT ZERO"
    echo $ONE_UP_NUM_TEST
    echo "TDA ${TDA_ENV} FINAID ONEUP number not numeric or greater than zero on `date`." | mailx  -s "TDA ${TDA_ENV} ONE UP NUMBER ERROR" -c ${CC_RECIPIENT} ${RECIPIENT}
    exit 1
fi
