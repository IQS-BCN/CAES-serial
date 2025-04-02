#USAGE
# receptor_addatoms.sh O1 O2 receptor.pdbqt

#for AB
l1=''
#try with CD
l1=`grep -n "$1.00  " $3 | grep "CD" | cut -d ":" -f 1`

#if there was no CD, try CG
if [ "$l1" = "" ]
then 
l1=`grep -n "$1.00  " $3 | grep "CG" | cut -d ":" -f 1
fi 

#substitute C to Chlorine on l1 line
sed "$l1 s/C $/Chlorine/" $3  > $3

#for Nuc
l2=''
#try with CD
l2=`grep -n "$2.00  " $3 | grep "CD" | cut -d ":" -f 1`

#if there was no CD, try CG

if [ "$l2" = "" ]
then
l2=`grep -n "$2.00  " $3 | grep "CG" | cut -d ":" -f 1`
fi

#subsititue C to Iodine on line l2
sed "$l2 s/C $/Iodine/" $3  > $3
