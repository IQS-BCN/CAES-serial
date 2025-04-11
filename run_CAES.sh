LIGLIST_FILE=$2
PROTLIST=$1
LIGLIST=`cat ${LIGLIST_FILE}`

for position in $PROTLIST
do
  bash do_CAES.sh $position "$LIGLIST"
done
