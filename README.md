# CAES-serial
File containing the necessary scripts to run the SMINA docking with restraints.

## what is needed
To be able to call this function, there needs to be the pdbqt of the receptor and the pdbqt of the ligand, both with the necessary atoms for the restraints to take effect.

The current set up is the following
Restraint 1: Cl -- S  [3.6 Armstrongs]
Restraint 2:  I -- Zn [3.8 Armstrongs]

For the current idea, the Cl is last C of A/B, S is glicosidic Oxigen, I is last C of Nucleophile and Zn is annomeric Carbon of sugar -1

## USAGE

### For the whole procedure
```
smina_complete.sh receptor.pdbqt ligand.pdbqt lig
```
Where:

receptor.pdbqt      - is the .pdbqt file for the receptor, with the atoms set accordingly to the restraints

ligand.pdbqt        - is the .pdbqt file for the ligand, with the atoms set accordingly to the restaints

lig                 - is the desired prefix for the outputs, to try to minimize clashes

# Addatoms

This repo also contains the necessary scripts to add the Cl, I, S and Zn atoms to receptor and ligand respectively. To do this, the scripts need for the receptor to be previously fitted with the corresponding HMM, such that the information is storied in the occupancy space.

## Usage

The usage for both the receptor and ligand addatoms scripts is as follows.

### Receptor

```
receptor_addatoms.sh Occupancy_AB Occupancy_Nuc receptor.pdbqt
```

### Ligand

```
python ligand_addatoms.py ligand.pdbqt
```