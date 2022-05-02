#Strip headers and trailers
#Expected parameters:
#$1=file name to process
#$2=directory path
. /opt2/jwu/bin/TDAccess/set_TDA_parameters.sh 
#cd $TDA_DIR/incoming
#pwd
for i in `ls $TDA_DIR/incoming/*op*`
do
echo "  "
echo $i
#read x
echo "head before sed"
head -n 1 $i
sed '1d;$d' $i > $TDA_DIR/incoming/temp.txt
mv -fv $TDA_DIR/incoming/temp.txt $i
echo "  "
echo "head after sed"
head -n 1 $i
done
