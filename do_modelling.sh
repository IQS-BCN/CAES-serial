PROTEIN=$1

if [ -e "MODELS" ]
then
   echo "$protein/MODELS already exists, skipping modelling $protein"
else
   cp -pr Modeller_serial MODELS
   cp $PROTEIN.pdb MODELS/template.pdb
   cp $PROTEIN.pdb af_1.pdb
   cd MODELS
   bash get_sequence_fromPDB.sh
   SEQUENCE_FILE="sequence.dat"
   OUTPUT_FILE="ALIGNMENT.pir"
   touch "$OUTPUT_FILE"
  #Leer la secuencia del archivo de entrada
    SEQUENCE=$(cat "$SEQUENCE_FILE")
# Construccion del archivo ALIGNMENT.pir
    echo ">P1;template" >> "$OUTPUT_FILE"
    echo "structureX:template.pdb:1:A:1:::::" >> "$OUTPUT_FILE"
    echo "$SEQUENCE" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo ">P1;model" >> "$OUTPUT_FILE"
    echo "sequence:::::::::" >> "$OUTPUT_FILE"
    echo "$SEQUENCE" >> "$OUTPUT_FILE"
    mod10.0 model-single-ligand.py
    rm template.pdb
    cd ..
fi 