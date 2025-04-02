pdbqtout=$1

grep -v "REMARK" $pdbqtout | grep -v "BRANCH" | grep -v "ROOT" | grep -v "TORSDOF" | grep -v "BEGIN_RES" | grep -v "END_RES" > $pdbqtout.pdb.tmp
grep "RESULT" $pdbqtout | awk '{print NR,$4}' > $pdbqtout.ene
grep -A1 "MODEL" $pdbqtout | grep "minimizedAffinity" | awk '{print NR,$3}' >> $pdbqtout.ene

linesPDB=`wc -l $pdbqtout.pdb.tmp | awk '{print $1}'`
linesENE=`wc -l $pdbqtout.ene | awk '{print $1}'`
linesSTR=`echo $linesPDB $linesENE | awk '{print $1/$2}'`

cat $pdbqtout.ene | sed "s/\+//" | sort -nk2 | awk '{print NR-1,$2,$1}'  > $pdbqtout.sorted.ene

JJ=1
for i in `awk '{print $3}' $pdbqtout.sorted.ene`
do
  iniLine=$(( linesSTR * i + 1 ))
  finLine=$(( linesSTR * i + linesSTR ))
  thisENE=`sed -n ${JJ}p $pdbqtout.sorted.ene | awk '{print $2}'`
  echo "MODEL $JJ"
  sed -n $iniLine,${finLine}p $pdbqtout.pdb.tmp | awk -v ENE=$thisENE '{print $0" 1.00 "ENE}'
  JJ=$(( JJ + 1 ))
done > $pdbqtout.sorted.pdb

cp $pdbqtout.pdb.tmp $pdbqtout.pdb
rm $pdbqtout.pdb.tmp
