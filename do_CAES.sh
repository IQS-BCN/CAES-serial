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
for position in $POSITIONLIST
do
   echo "CAES for position:  $position -- `date`"
   echo "finding family for $position"
   fam_file=`grep $position PROTLIST/*.txt | cut -d ":" -f 1`
   fam=`basename $fam_file .txt`
   echo "family: $fam"
   if [ -e "RESULTS/$fam" ]
   then
      echo "directory for $fam already exists"
   else
      echo "creating family directory"
      bash make_families.sh $fam
   fi
   #cd RESULTS/$fam
   if [ -e "RESULTS/${fam}/CAES_$position" ]
   then 
        echo "CAES_$position already exists, skipping $position"
   else
	echo "creating CAES_$position inside $fam directory"
        cp -pr CAES-serial RESULTS/${fam}/CAES_$position
        cd RESULTS/${fam}/CAES_$position
          echo $position > position.txt
          echo $fam > family.txt
        
          NUC=`cat ../${fam}.catres | cut -d " " -f 1`
          AB=`cat ../${fam}.catres | cut -d " " -f 2`

          cp ../../../CAZYMES_3D_ORIGIN/${position}_origin.pdb ${position}.pdb
        
# do modelling
          if [ -e "MODELS" ]
          then
            echo "$position/MODELS already exists, skipping modelling $position"
          else
            echo "starting modelling for $position"
            cp -pr Modeller_serial MODELS
            cp $position.pdb MODELS/template.pdb
            cd MODELS
              ./do_modelling.sh $position
            cd ..      
          fi
# do prepare
          if [-e "PREPARE" ]
          then
            echo "$position/PREPARE already exists, skipping processing $position"
	  else
            cp -pr Addatoms PREPARE
	         cp MODELS/*.pdb PREPARE/.
	         cd PREPARE
	           ./do_prepare.sh 
            cd ..
          fi
# do docking
	  ./do_docking.sh position
# do scoring          
	  ./do_scoring.sh position
          echo "CAES for position:  $position done -- `date`"
       cd ../../../ 
   fi
done
