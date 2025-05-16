#!/bin/bash

CAES_PATH=$3
# home/joanfillolp/CAES_run_0/RESULTS/GH_x
PROTEIN=$1
# UPcode
LIGAND=$2
# OME_XXX_XXX

echo "get_complex: Extracting ene and pdb files"
grep -hA1 "MODEL" ${CAES_PATH}/CAES_${PROTEIN}/DOCKING/${LIGAND}/model.*_smina.dk_min_all.pdbqt | grep "minimizedAffinity" | awk '{print NR, $3}' > ligand_out.ALL.ene
grep -hv "REMARK" ${CAES_PATH}/CAES_${PROTEIN}/DOCKING/${LIGAND}/model.*_smina.dk_min_all.pdbqt | grep -v "BRANCH" | grep -v "ROOT" | grep -v "TORSDOF" | grep -v "BEGIN_RES" | grep -v "END_RES" > ligand_out.ALL.pdb
cat ${CAES_PATH}/CAES_${PROTEIN}/MODELS/model.B9999*_fit.pdb > receptor.ALL.pdb

nLIGANDS=`wc -l ligand_out.ALL.ene | awk '{print $1}'`
nRECEPTORS=`ls ${CAES_PATH}/CAES_${PROTEIN}/MODELS/model*B9999*_fit.pdb | wc -l`

echo "get_complex: $nLIGANDS ligand structures for $nRECEPTORS receptor structures"


echo "get_complex: building complexes_all.sorted.ene" # vmdframe#,ene,vina#,receptormodel#,splittedligand#
r=1
for ff in `ls ${CAES_PATH}/CAES_${PROTEIN}/DOCKING/${LIGAND}/model.*_smina.dk_min_all.pdbqt`
do
  grep -A1 "MODEL" ${ff} | grep "minimizedAffinity" | awk '{print NR, $3}' | awk -v r=$r '{print $0, r}'
  r=$(( r + 1 ))
done | awk '{print $0,NR}' > complexes_all.ene

cat complexes_all.ene | sed "s/\+//" | sort -nk2 | awk '{print NR-1,$2,$1,$3,$4}'  > complexes_all.sorted.ene    


###echo "building complexes_all.sorted.rmsd" # vmdframe#,rmsd,vina#,receptormodel#,splittedligand#
###r=1
###for ff in `ls model*B9999*_fit.pdb.ligand_out.pdbqt.sorted.rmsd.gz`
###do
###  zcat ${ff} | awk -v r=$r '{print $0, r}' 
###  r=$(( r + 1 ))
###done | awk '{print $0,NR}' > complexes_all.rmsd
###
#### sorting RMSDs...
####for some weired reason, this sorting is not working the same as sorting in line 29
####paste ligand_out.ALL.ene ligand_out.ALL.rmsd | sort -nk 2 | awk '{print NR-1,$4}' > complexes_all.sorted.rmsd
####                                                                    vmdframe#,rmsd
###for i in `seq 1 $nLIGANDS`
###do
###  thisLIG=`sed -n ${i}p complexes_all.sorted.ene | awk '{print $5}'`
###  sed -n ${thisLIG}p complexes_all.rmsd | awk '{print $2,$1,$3,$4}'
###done | awk '{print NR-1,$0}' > complexes_all.sorted.rmsd               


echo "get_complex: building complexes_all.sorted.pdb"
linesLIG=`wc -l ligand_out.ALL.pdb | awk '{print $1}'`
linesREC=`wc -l receptor.ALL.pdb   | awk '{print $1}'`
linesSTRLIG=`echo $linesLIG $nLIGANDS   | awk '{print $1/$2}'`
linesSTRREC=`echo $linesREC $nRECEPTORS | awk '{print $1/$2}'`

split -l $linesSTRLIG --numeric-suffixes=1 -a 3 ligand_out.ALL.pdb tmp.ligand.pdb.
split -l $linesSTRREC --numeric-suffixes=1 -a 3 receptor.ALL.pdb   tmp.receptor.pdb.

# sorting PDBs...
JJ=1
for i in `seq 1 $nLIGANDS`
do
  thisENE=`sed -n ${JJ}p complexes_all.sorted.ene | awk '{print $2}'`
  thisREC=`sed -n ${JJ}p complexes_all.sorted.ene | awk '{printf("%03i\n", $4)}'`
  thisPOS=`sed -n ${JJ}p complexes_all.sorted.ene | awk '{print $3}'`
  thisLIG=`sed -n ${JJ}p complexes_all.sorted.ene | awk '{printf("%03i\n", $5)}'`

  echo "MODEL $JJ"
  echo "REMARK    receptor: $thisREC   pose: $thisPOS  energy: $thisENE"
  cat tmp.receptor.pdb.$thisREC | grep -v "END" | grep -v "REMARK" | grep -v "EXPDTA"
  cat tmp.ligand.pdb.$thisLIG | grep -v "MODEL" | grep -v "ENDMDL"
  echo "END"

  JJ=$(( JJ + 1 ))
done > complexes_all.sorted.pdb


rm tmp.ligand.pdb.*
rm tmp.receptor.pdb.*

echo "get_complex: Done!"
