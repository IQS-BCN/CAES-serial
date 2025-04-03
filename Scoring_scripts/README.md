# Geometric Scoring

This series of scripts are the ones related to the geometric scoring of the enzyme substrate complexes.

## USAGE
Firts, the 01_calc_params script must be used, then the 02_score_function.

### 01_calc_params.py
```

python 01_calc_params.py [-h] [-r RECEPTOR] [-l LIG] [-oAB OAB] [-oNuc ONUC] [-i INDEX] [-c CHAIN] [-v] [-o OUT]

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

### 02_score_function.py

```
usage: 02_score_function.py [-h] [-i INPUT] [-0 OUT] [-nt NTYPE] [-v]

Function to score a given receptor - ligand pair, using the parameters calculated with 01_calc_params.py

options:
  -h, --help                     show this help message and exit
  -i INPUT, --input INPUT        CSV file with the calculated parameters of the poses to score
  -o OUT, --output OUT           CSV file with the resulting scores
  -nt NTYPE, --NucType NTYPE     Type of nucleophile activity: R for retaining activity, I for inveritng activity (not implemented)
  -v, --verbose
```