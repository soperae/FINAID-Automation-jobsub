#!/bin/bash
echo $USER
echo $AW_HOME
echo $DATA_HOME

. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TDA_DIR

#cd /opt2/jwu/TDAccess3.3.1

./tdclientc network="saigportal${TDA_ENV}" ftpuserid=$1  RESET query_list

