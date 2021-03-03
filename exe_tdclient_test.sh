#!/bin/bash
echo $USER
echo $AW_HOME
echo $DATA_HOME
. $HOME/set_TDA_parameters.sh 

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TDA_DIR

#cd /opt2/jwu/TDAccess3.3.1

./tdclientc network="saigportaltest" ftpuserid=TG51339  RESET query_list

