#!/bin/bash
#Expected paramters:
#$1--New password
#$2--TDClient path
#Addition of tdclient path necessary for each execution since it is being reset
#by other methods.
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TDA_DIR

#Change directory to area of execution
#cd $2

#set password to the current password established in EDConnect
./tdclientc RESET "network=saigportal${TDA_ENV}" ftpuserid=$1 new_passwd=$2 query_list

