# Occupancy & Superpositon

The scripts here are the ones in charge of aligning the CAZYMES_3D structures with the HMM and superimposing them to the reference protein of their given family.

This procedure is inherited from EASiMap, following the same logic, but without the calculations of the celestial maps.

***FALTA: script que llegeixi GH_i.catres i llenci la comanda***
***FALTA: forma d'acomular els atoms dels anells dels lligands ref, no volem commandes prefetes***

## Needs, eviroment & output

This script (*Occup_Superpos.tcl*) is suposed to be run in the given GH family directory, with the following enviroment:

```bash
├── CAZYMES_3D
│   └── UP000000.pdb
└── RESULTS
    └── GH_i
        ├── GH_i.catres
        ├── GH_i.hmm
        ├── GH_i.txt
        ├── pdb_ref.pdb
        ├── pdb_ref.atoms
        └── UP00000
            └── UP00000.pdb

```
```
Where:

GH_i.txt        list of UP codes for the given family
GH_i.hmm        HMM for the given family
GH_i.catres     file containing the hmm for the catalytic resdiues of the family
pdb_ref.pdb     pdb file for the reference protein of the GH family
pdb_ref.atoms   file with the atom indexes of the sugar for the reference protein of the GH family

CAZYMES_3D      directory containing the pdb files for the downloaded AF_DB structures
```

The output of this script, is the placing of the algined structure in the given UP00000 directory, inside the GH_i directory.
## Usage

```
argumentos:
hmm_column      Las posiciones del HMM que se usarán para la superposición Ej: 165 360
domain          El nombre en Pfam de la familia cuyo HMM se quiere utilizar Ej: PF00232
pdb_code_ref    El nombre del archivo PDB de la proteína que se utilizará como referencia Ej: 3SCU
CAZY_fam        El nombre de la familia de proteínas cuyos PDB se descargarán de Cazy Ej: GH1
atom_chain      Lista de los atomos del anillo del ligando: c1 c2 c3 c4 c5 o5 Ej: "4552 4553 4554 4555 4556 4562"
atomo           El tipo de átomo o conjunto de átomos que se desean representar Ej: sidechain
chainR          Cadena del ligando Ej: "chain A"


 usage:

   source Occup_Superpos.tcl
   occup_superpos "165 360" GH_1 3SCU GH1 "4552 4553 4554 4555 4556 4562" sidechain "chain A"
```
