famname=$1

mkdir RESULTS/${famname}

cp PROTLIST/${famname}.txt RESULTS/${famname}/.
cp HMM/${famname}/${famname}.hmm RESULTS/${famname}/.
cp CATRES/${famname}.catres RESULTS/${famname}/.
cp PDB_REF/${famname}_*.* RESULTS/${famname}/.

