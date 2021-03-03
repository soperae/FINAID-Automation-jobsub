
l_uid=$( cat $BANNER_HOME/p_usr )
l_pwd=$( cat $BANNER_HOME/p_system2 )
l_job=$0
l_prog=$1
l_prnt=$2
FOURDIGIT=$3
TWODIGIT=${FOURDIGIT:2:2}
echo $FOURDIGIT '/' $TWODIGIT
echo "RCR${TWODIGIT}" ' / ' $l_uid
echo $BANNER_HOME
