#!/usr/bin/python

import pandas as pd
import numpy as np
import sys
#load ligand.pdbqt
 
ligand_file = sys.argv[1]

with open(ligand_file) as f:
    ligand = f.readlines()

lig_og = ligand
#convert ligand to pandas entry
ligand = pd.DataFrame([x.split() for x in ligand])

lig2 = ligand.dropna(axis=0)

ligand.loc[:,6] = lig2.loc[:,6].astype(float)
ligand.loc[:,7] = lig2.loc[:,7].astype(float)
ligand.loc[:,8] = lig2.loc[:,8].astype(float)

#select glycosidic O -- entry before 'ENDROOT'
gly_O_num = ligand[ligand[0] == 'ENDROOT'].index[0] - 1
gly_O = ligand.loc[gly_O_num]
#select all C1
C1 = ligand[(ligand[0] == 'ATOM') & (ligand[2] == 'C1')]

#calulate rms of different c1 entries to gly_O
#set a variable for the row of the c1
c1_num = None
#for the different lines in C1
for i in C1.index:
    #select the row of the C1
    c1 = C1.loc[i,:]
    #calculate the distance between the gly_O and the C 
    dx = c1[6] - gly_O[6]
    dy = c1[7] - gly_O[7]
    dz = c1[8] - gly_O[8]
    #calculate the rmsd
    rms = np.sqrt(dx**2 + dy**2 + dz**2)
    #if the rmsd is between 1.2 and 1.7
    #set the c1_num to the row of the C1
    #and break the loop
    if rms < 1.7 and rms > 1.2:
        c1_num = i
        break

#change the atom type of the glycosidic O and C1
#to S and Zn respectively
lig_out = lig_og
lig_out[gly_O_num] = lig_out[gly_O_num][0:77] + 'S' + lig_out[gly_O_num][79:]
lig_out[c1_num] = lig_out[c1_num][0:77] + 'Zn' + lig_out[c1_num][79:]



with open(ligand_file+ '_old.pdbqt', 'w') as f:
    f.writelines(lig_og)

with open(ligand_file, 'w') as f:
    f.writelines(lig_out)
