#USAGE
# receptor_addatoms.sh O1 O2 receptor.pdbqt 
AB=$1
NUC=$2
file=`basename $3 .pdbqt`
#for AB
l1=''
#try with CD
l1=`grep -n "$AB.00" $3 | grep "CD" | cut -d ":" -f 1`

#if there was no CD, try CG
if [ "$l1" = "" ]
then 
l1=`grep -n "$AB.00" $3 | grep "CG" | cut -d ":" -f 1`
fi 

#substitute C to Chlorine on l1 line
sed "$l1 s/C $/Chlorine/" $3  > ${file}.temp

#for Nuc
l2=''
#try with CD
l2=`grep -n "$NUC.00" ${file}.temp | grep "CD" | cut -d ":" -f 1`

#if there was no CD, try CG

if [ "$l2" = "" ]
then
l2=`grep -n "$NUC.00" ${file}.temp | grep "CG" | cut -d ":" -f 1`
fi

#subsititue C to Iodine on line l2
sed "$l2 s/C $/Iodine/" ${file}.temp  > ${file}_smina.pdbqt

