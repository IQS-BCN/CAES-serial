#!/bin/bash
## the inputs must be 1: receptor.pdbqt -- file for the receptor
## 		      2: ligand.pdbqt -- file for the ligand
##            3: model1 -- prefix for the out files 
## th

## remove the necessary directories and then create them to make sure they are empty and clean
rm -r tmp_dk
rm -r tmp_min


mkdir tmp_dk
mkdir tmp_min

file=`basename $1 .pdbqt`
echo "smina_complete: docking $1"
## make the docking with smina and the fixed atoms
smina --cpu 1 --receptor $1 --ligand $2 --config smina.in --out "${file}.dk_out.pdbqt"


## split the output into individual pdbqt files
vina_split --input "$file.dk_out.pdbqt" --ligand "tmp_dk/$file.dk_out."

## for each pdbqt, minimize it and save the result
for lig in `ls tmp_dk/*.pdbqt`
do 
name=`basename $lig .pdbqt`

filemin="$name.pdbqt"

echo "smina_complete: minimizing $filemin"

smina --cpu 1 --receptor $1 --config minimize.in --minimize --autobox_ligand $lig --ligand $lig --out "tmp_min/${name}.min_out.pdbqt" 
done

## join all of the minimized results into a single file, and then split the
## individual structures into pdbqt's

cat tmp_min/*.pdbqt > ${file}.dk_min_all.pdbqt

#vinatopdb_resort.sh dock_min_"${file}".pdbqt

rm -r tmp_min
rm -r tmp_dk
