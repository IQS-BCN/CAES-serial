
for i in `seq 1 200`
do
    echo "Processing file $i"
    
    pdb=`python select_protref_01.py -f $i`

    if [ -e PDB_REF/GH_${i}_${pdb}.atoms ]
    then
        echo "reference protein for GH_${i} succesfully obtained, sourcing it from $1"
        echo "pdb: $pdb"
        
	echo $1/${pdb}.cif 
        cp $1/${pdb}.cif PDB_REF/GH_${i}_${pdb}.cif
    else
        echo "reference protein for GH_${i} could not obtained"
    fi
done
