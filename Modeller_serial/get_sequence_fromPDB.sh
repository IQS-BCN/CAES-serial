#!/bin/bash

grep -v "CRYS" template.pdb | awk 'BEGIN{
aa["ALA"]="A"
aa["CYS"]="C"
aa["ASP"]="D"
aa["GLU"]="E"
aa["PHE"]="F"
aa["GLY"]="G"
aa["HIS"]="H"
aa["ILE"]="I"
aa["LYS"]="K"
aa["LEU"]="L"
aa["MET"]="M"
aa["ASN"]="N"
aa["PRO"]="P"
aa["GLN"]="Q"
aa["ARG"]="R"
aa["SER"]="S"
aa["THR"]="T"
aa["VAL"]="V"
aa["TRP"]="W"
aa["TYR"]="Y"
naa=1
prev_nhet=""
}
NR==1{
  for(i=1;i<$6;i++){
    printf("%s","-")
  }
  prev_naa=$6
  printf("%s",aa[$4])
}
$1=="TER"{
  printf("%s","/")
}
NR>1 && $1!="TER" && $1=="ATOM"{
  if(prev_naa!=$6){
    for(i=prev_naa+1;i<$6;i++){
      printf("%s","-")
    }
    prev_naa=$6
    printf("%s",aa[$4])
  }
}
NR>1 && $1!="TER" && $1=="HETATM"{
  if(prev_nhet!=$6){
    prev_nhet=$6
    printf("%s",".")
  }
}
END{
    printf("%s","*")
  print ""
}
' >> sequence.dat 
