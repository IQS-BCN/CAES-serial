# Occupancy & Superpositon

The scripts here are the ones in charge of aligning the CAZYMES_3D structures with the HMM and superimposing them to the reference protein of their given family.

This procedure is inherited from EASiMap, following the same logic, but without the calculations of the celestial maps.

***FALTA: Script que generi les carpetes per code i despres tiri el occup_superpos.tcl***

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

   source easimaptodalacadena_CarboPlanes_v5.tcl
   easimap_all "165 360" GH_1 3SCU GH1 "4552 4553 4554 4555 4556 4562" sidechain "chain A"
```
