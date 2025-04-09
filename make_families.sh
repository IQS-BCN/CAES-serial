famname=$1

mkdir RESULTS/${famname}

cp PROTLISTS/${famname}.txt RESULTS/${famname}/.
cp HMM/${famname}.hmm RESULTS/${famname}/.
cp CATRES/${famname}.catres RESULTS/${famname}/.
cp PDB_REF/${famname}_*.* RESULTS/${famname}/.

