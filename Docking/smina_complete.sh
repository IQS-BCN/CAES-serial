#!/bin/bash
## the inputs must be 1: receptor.pdbqt -- file for the receptor
## 		      2: ligand.pdbqt -- file for the ligand
##            3: model1 -- prefix for the out files 
## th


## remove the necessary directories and then create them to make sure they are empty and clean
rm -r dk
rm -r min


mkdir dk
mkdir min

file=`basename $1 .pdbqt`

## make the docking with smina and the fixed atoms
smina --receptor $1 --ligand $2 --config smina.in --out "docked_${file}.pdbqt"


## split the output into individual pdbqt files
vina_split --input "$file.out.pdbqt" --ligand "dk/$file."

## for each pdbqt, minimize it and save the result
for lig in `ls dk/*.pdbqt`
do 
name=`basename $lig .pdbqt`

file="$name.pdbqt"

echo $file

smina --receptor $2 --config minimize.in --minimize --autobox_ligand $lig --ligand $lig --out "min/${name}_min.pdbqt" 
done

## join all of the minimized results into a single file, and then split the
## individual structures into pdbqt's

cat min/*.pdbqt > dock_min_all.${file}.pdbqt

#vinatopdb_resort.sh dock_min_"${file}".pdbqt

rm -r min
rm -r dk
rm $file.out.pdbqt