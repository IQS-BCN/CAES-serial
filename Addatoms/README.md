
# Addatoms

This repo also contains the necessary scripts to add the Cl, I, S and Zn atoms to receptor and ligand respectively. To do this, the scripts need for the receptor to be previously fitted with the corresponding HMM, such that the information is storied in the occupancy space.

The addatoms for the receptor, starts with a pdb, runs it thrugh the ```prepare_receptor4.py``` available thrugh AD4 and then adds atoms.

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