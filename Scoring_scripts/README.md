# Geometric Scoring

This series of scripts are the ones related to the geometric scoring of the enzyme substrate complexes.

## USAGE
Firts, the 01_calc_params script must be used, then the 02_score_function.

### 01_calc_params
```

01_calc_params.py [-h] [-r RECEPTOR] [-l LIG] [-oAB OAB] [-oNuc ONUC] [-i INDEX] [-c CHAIN] [-v] [-o OUT]

Function to calculate the geometric parameters for the geometric scoring of a given receptor - ligand pair.

options:
  -h, --help                            show this help message and exit
  -r RECEPTOR, --receptor RECEPTOR      Receptor PDB file
  -l LIG, --ligand LIG                  Ligand PDB file, can have multiple frames
  -oAB OAB, --occupancyAB OAB           Occupancy of AB residue. Must be format 123.00
  -oNuc ONUC, --occupancyNuc ONUC       Occupancy of Nuc residue. Must be format 123.00
  -i INDEX, --ligindex INDEX            List of indexes for the ligand, [og, cn, c1, c2]
  -c CHAIN, --ligchain CHAIN            Chain of the ligand
  -o OUT, --output OUT                  File name for the output csv. Must include csv in the name.  
  -v, --verbose
```