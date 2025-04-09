PROTLIST_FILE=$1

PROTLIST=`cat ${PROTLIST_FILE}`
echo "processing list file $PROTLIST_FILE"
bash do_CAES.sh $PROTLIST
