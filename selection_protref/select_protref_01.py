import pandas as pd
import json
from emap04_buscar_prot_model import *
from emap05_1_HMM_eval import get_HMM
from emap03_indexs_lligands import ligand_indexes
import sys
import argparse

parser = argparse.ArgumentParser(description=
                                 'Function to select the reference protein of a given GH family, to add the given protein\'s sugar atoms ' \
                                 'to the respective file and to generate the GH_i.catres file.')


parser.add_argument("-f", '--family', dest='fam', help='Family to select the reference protein')
parser.add_argument('-json', dest='json', default='FULL_DF_CAZY.json', help='JSON input file, with the protein information of CAZY. Default: FULL_DF_CAZY.json')
parser.add_argument('-lig', dest='lig', default='ligand_annotation_1.txt', help='Ligand annotation file. Default: ligand_annotation_1.txt')
parser.add_argument('-lo', '--ligand_output', dest='lig_out', default='ref_ligands.csv', help='Output file for the ligands. Default: ref_ligands.csv')
parser.add_argument('-v', '--verbose', action='store_true', help='Verbose mode')

args = parser.parse_args()
if args.verbose:
    print("Selecting reference protein for family: {}".format(args.fam))
    print("Input JSON file: {}".format(args.json))
    print("Ligand annotation file: {}".format(args.lig))
    print("Output file for the ligands: {}".format(args.lig_out))

with open(args.json) as json_file:
    data = json.load(json_file)
    # convertir a dataframe

df = pd.DataFrame(data)
prot = seleccionar_prot_ref(args.fam, None)
if prot == None:
    sys.exit(0)
else:
    print(prot)



hmm_cols = get_HMM(args.fam, None)

if hmm_cols == None:
    sys.exit(0)
else:
    with open('CATRES/GH_' +args.fam + '.catres', 'w') as file:
        file.write(str(hmm_cols))


lig_index = ligand_indexes(prot, None)
if lig_index == None:
    sys.exit(0)
else:
    with open('PDB_REF/GH_'+args.fam+'_'+prot+'.atoms', 'w') as file:
        file.write(str(lig_index))


