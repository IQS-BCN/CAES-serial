#!/bin/bash
POSITIONLIST=$1
if [ -e "RESULTS" ]
then
   echo "RESULTS directory already exists, skipping creation"
else
   echo "creating RESULTS directory"
   mkdir RESULTS
fi

echo "CAES -- Carbohydrate Active Enzyme Smina docking initatied - `date`"
for postion in $POSITIONLIST
do
   echo "CAES for position:  $position -- `date`"
   echo "finding family for $position"
   fam_file=`grep $position ../PROTLIST/*.txt | cut -d ":" -f 1`
   fam=`basename $fam_file .txt`
   echo "family: $fam"
   if [ ! -d $fam ]
   then
      echo "creating family directory"
      make_families.sh $fam
   fi
   cd RESULTS/$fam
   if [ -e "CAES_$position" ]
   then 
        echo "CAES_$position already exists, skipping $position"
   else
        cp -pr CAES_serial CAES_$position
        cd CAES_$position
        echo $position > position.txt
        echo $fam > family.txt
        
        NUC=`cat ${fam}.catres | cut -d " " -f 1`
        AB=`cat ${fam}.catres | cut -d " " -f 2`

        cp ../../CAZYMES_3D_ORIGIN/${position}_origin.pdb ${position}.pdb

        ./do_modelling.sh $position

        ./do_prepare.sh position
        ./do_docking.sh position
        ./do_scoring.sh position
        echo "CAES for position:  $position done -- `date`"
   fi
done
