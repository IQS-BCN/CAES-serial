#!/bin/bash
## the inputs must be 1: smina.in -- config file for initial smina docking
## 		      2: minimize.in -- config file for minimization docking


## remove the necessary directories and then create them to make sure they are empty and clean
rm -r dk
rm -r min

mkdir dk
mkdir min

## make the docking with smina and the fixed atoms
smina --config $1

vinatopdb_resort.sh ligand_out.pdbqt

## split the output into individual pdbqt files
vina_split --input ligand_out.pdbqt --ligand dk/

## for each pdbqt, minimize it and save the result
for lig in `ls dk/*.pdbqt`
do 
name=`basename $lig .pdbqt`
file="$name.pdbqt"

smina --config $2 --minimize --autobox_ligand $lig --ligand $lig --out "min/${name}_out.pdbqt" 
done

## join all of the minimized results into a single file, and then split the
## individual structures into pdbqt's

cat min/*.pdbqt > min/all.pdbqt

vinatopdb_resort.sh min/all.pdbqt

