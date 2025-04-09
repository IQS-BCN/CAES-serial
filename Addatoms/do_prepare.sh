NUC=$1
AB=$2
#enable gobling
shopt -s extglob
for pdbfile in `ls *pdb`
  do
    name=`basename $pdbfile .pdb`
    namebo="${name/B999900/}"
    file_pdbqt="${namebo}.pdbqt"
    echo "do_prepare: makeing pdbqt from $pdbfile"
    prepare_receptor4.py -r $pdbfile -o $file_pdbqt
    echo "do_prepare: adding atoms to $file_pdbqt"
    ./receptor_addatoms.sh $AB $NUC $file_pdbqt
  done
rm -v !(*_smina.pdbqt)
