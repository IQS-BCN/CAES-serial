mkdir RESULTS

for fam in `ls PROTLISTS/*`
do
famname=`basename $fam .txt`

mkdir RESULTS/${famname}

cp PROTLISTS/${fam} RESULTS/${famname}/.
cp HMM/${famname}.hmm RESULTS/${famname}/.
cp CATRES/${famname}.catres RESULTS/${famname}/.
cp PDB_REF/${famname}_*.* RESULTS/${famname}/.

done