#!/bin/bash
## the inputs must be 1: receptor.pdbqt -- file for the receptor
## 		      2: ligand.pdbqt -- file for the ligand
##            3: ligand_out.pdbqt -- file for the output of the docking
## th


## remove the necessary directories and then create them to make sure they are empty and clean
rm -r dk
rm -r min
rm -r all

mkdir dk
mkdir min

## make the docking with smina and the fixed atoms
smina --receptor $1 --ligand $2 --config smina.in --out "$3.out.pdbqt"


## split the output into individual pdbqt files
vina_split --input "$3.out.pdbqt" --ligand "dk/$3."

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

cat min/*.pdbqt > all/"${3}"_all.pdbqt

vinatopdb_resort.sh all/"${3}"_all.pdbqt

rm -r min
rm -r dk
rm $3.out.pdbqt