#!/bin/bash

shopt -s extglob
position=$1
LIGANDLIST=$2
if [ -e "RESULTS" ]
then
   echo "RESULTS directory already exists, skipping creation"
else
   echo "creating RESULTS directory"
   mkdir RESULTS
fi


echo "checking if ${position}_origin.pdb exists in CAZYMES_3D_ORIGIN"

if [ -e "CAZYMES_3D_ORIGIN/${position}_origin.pdb" ]
then
   echo "CAES -- Carbohydrate Active Enzyme Smina docking initatied - `date`"

   echo "$position exists, proceeding with CAES"
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
        echo "CAES_$position already exists, goint into it to check steps"
        cp -pr CAES-serial/* RESULTS/${fam}/CAES_$position/.
        cd RESULTS/${fam}/CAES_$position
   else
	echo "creating CAES_$position inside $fam directory"
        cp -pr CAES-serial RESULTS/${fam}/CAES_$position
        cd RESULTS/${fam}/CAES_$position
          echo $position > position.txt
          echo $fam > family.txt
   fi
   if [ -e "Docking" ]
   then
     echo "Docking file directory already exists in CAES_$position" 
   else
     cp -pr ../../../CAES-serial/Docking .
     echo "Copying Docking file from CAES-serial into CAES_$position"
   fi 
          NUC=`cat ../${fam}.catres | cut -d " " -f 1`
          AB=`cat ../${fam}.catres | cut -d " " -f 2`

          cp ../../../CAZYMES_3D_ORIGIN/${position}_origin.pdb ${position}.pdb
        
# do modelling
          if [ -e "MODELS" ]
          then
            echo "$position/MODELS already exists"
            echo "checking if PREPARE exists"
            if [ -e "PREPARE" ]
            then
              echo "PREPARE exists, checking if MODELS are completed"
              models=`ls MODELS/model.B999900*_fit.pdb | wc -l`
              if [ "$models" -gt 1 ]
              then
                mod=1
              else
                mod=0
              fi
            else 
              echo "PREPARE does not exist, re-doing MODELLING"
              rm -r "MODELS"
              mod=0
            fi
          else
            mod=0
          fi
          if [ $mod -eq 0 ]
          then
            echo "starting modelling for $position"
            cp -pr Modeller_serial MODELS
            cp $position.pdb MODELS/template.pdb
            cd MODELS
              ./do_modelling.sh $position
            cd ..      
          fi
# do prepare
          if [ -e "PREPARE" ]
          then
            echo "$position/PREPARE already exists, checking contents"
            countprep=`ls PREPARE/model.*_fit_smina.pdbqt | wc -l`
            if [ "$countprep" -gt 1 ]
            then 
              echo "$position/PREPARE has at least 2 elements inside, skipping prepare"
              prep=1
            else 
              prep=0
            fi
        
	       else
           prep=0
          fi
        if [ $prep -eq 0 ]
        then
           echo "doing PREPARE on  $position"
            cp -pr Addatoms PREPARE
	         cp MODELS/*.pdb PREPARE/.
	         cd PREPARE
	           ./do_prepare.sh $NUC $AB 
            cd ..
          fi
# do docking
          if [ -e "DOCKING" ]
          then
            echo "$position/DOCKING already exists, entering to check docked sugars"
          else
            echo "starting dockings for $position"
            mkdir DOCKING
	    cp -pr Docking DOCKING/.
          fi  
          cd DOCKING
          
	  if [ -e "Docking" ]
          then
            echo "Docking already in DOCKING"
          else
            cp -r ../Docking .
	    echo "Copying Docking in DOCKING."
          fi 
	  echo $LIGANDLIST
            for suc in $LIGANDLIST
            do
              count="0"
              if [ -e $suc ]
                then
                count=`ls $suc/* | wc -l`
              fi
              if [ "$count" -gt 0 ] 
              then
                echo "$suc already docked, skipping docking $suc"
              else
		pwd
		echo "docking $suc to $position"
                cp -pr Docking $suc
                cd $suc
		pwd
		echo "copying $suc.pdbqt from LIGAND_PROCESSED, also copying ../../PREPARE/*.pdbqt"
		cp ../../../../../LIGAND_PROCESSED/$suc.pdbqt ligand.pdbqt
                cp ../../PREPARE/*.pdbqt .
                
                  for receptor in `ls *_smina.pdbqt`
                  do
                    echo "docking $suc to $receptor"
                    ./smina_complete.sh $receptor ligand.pdbqt
                    rm $receptor
                  done
               echo "removing: `ls !(*_all.pdbqt)`"
               rm -v !(*_all.pdbqt)
	      cd ..  
              fi

            if [ -e "$suc/complexes_all.sorted.pdb" ]
            then
              echo "pdb already built of $suc and $position dokings" 
            else
              if [ -e "$suc/get_complexes_sorted_caes.sh" ]
              then
                echo "get complexes protocol already in directory"
              else
                cp -pr Docking/get_complexes_sorted_caes.sh $suc/.
                echo "get complexes script copied to directroy"
              fi
              echo "building PDB of $suc and $position"
              cd $suc
              bash get_complexes_sorted_caes.sh $position $suc ../../../
              rm get_complexes_sorted_caes.sh
	      cd .. 
            fi

            done
            rm -r Docking

            cd ..

      
       rm -r Docking
       rm -r Addatoms
       rm -r Modeller_serial
       rm -r Scoring

# do scoring          
	  #./do_scoring.sh position
          echo "CAES for position:  $position done -- `date`"
       cd ../../../ 
else
  echo "${position}_origin.pdb does not exist in CAZYMES_3d_ORIGIN, skipping $position"
#  echo "checking if $position was already created"
#  if [ -e "RESULTS/${position}" ]
#  then
#    echo "RESULTS/$position file exists, removing it"
#    rm -r RESULTS/$position
#    echo  "exiting CAES for $position"
#  else
#    echo "RESULTS/$position does not exist, exiting CAES for $position" 
#  fi
fi
