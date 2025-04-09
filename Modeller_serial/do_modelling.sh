PROTEIN=$1
#enable gobling
shopt -s extglob

echo "do_modelling: getting sequence  from $PROTEIN"
bash get_sequence_fromPDB.sh
SEQUENCE_FILE="sequence.dat"
OUTPUT_FILE="ALIGNMENT.pir"
touch "$OUTPUT_FILE"
#Leer la secuencia del archivo de entrada
SEQUENCE=$(cat "$SEQUENCE_FILE")
echo "do_modelling: building .pir file for $PROTEIN"
# Construccion del archivo ALIGNMENT.pir
echo ">P1;template" >> "$OUTPUT_FILE"
echo "structureX:template.pdb:1:A:1:::::" >> "$OUTPUT_FILE"
echo "$SEQUENCE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo ">P1;model" >> "$OUTPUT_FILE"
echo "sequence:::::::::" >> "$OUTPUT_FILE"
echo "$SEQUENCE" >> "$OUTPUT_FILE"
echo "do_modelling: executing modeller for $PROTEIN"
mod10.0 model-single-ligand.py
rm -v !(model*_fit.pdb)
