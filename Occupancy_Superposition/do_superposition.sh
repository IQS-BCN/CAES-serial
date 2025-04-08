FAM=$1

if [ -e "CAZYMES_3D_ORIGIN"]
then
    echo "CAZYMES_3D_ORIGIN directory already exists"
    
else
    echo "CAZYMES_3D_ORIGIN directory does not exist. Creating it."
    mkdir CAZYMES_3D_ORIGIN
fi


for i in `cat PROTLISTS/${FAM}.txt`
do
    echo "Processing $i"
    # Check if the file exists before copying
    if [ -e "PDB_REF/${i}_*.cif" ]; then
        prot_ref='PDB_REF/${i}_*.cif'
        prot_ref_name=`basename $prot_ref .cif`
        ## VMD call
    else
        echo "File PDB_REF/${i}_*.cif does not exist. Skipping ${i}."
    fi

done
