#USAGE
# receptor_addatoms.sh O1 O2 receptor.pdbqt
ll=`grep -n "$1.00  " $3 | grep "CD" | cut -d ":" -f 1`
sed "$ll s/C $/Chlorine/" $3  > $3
echo $ll
echo $1
echo $2
ll=`grep -n "$2.00  " $3 | grep "CD" | cut -d ":" -f 1`
sed "$ll s/C $/Iodine/" $3  > $3
echo $ll
