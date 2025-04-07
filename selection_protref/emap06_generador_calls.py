import pandas as pd
import json
from emap04_buscar_prot_model import *
from emap05_1_HMM_eval import get_HMM
from emap03_indexs_lligands import ligand_indexes

def get_calls(familia, atomo, data_df):
    PDB = seleccionar_prot_ref(familia, data_df)
    if PDB == None:
        return None
    
    chain = get_chain(PDB)
    HMMcols = get_HMM(familia, data_df)
    if HMMcols == None:
        return None
    lig_index = ligand_indexes(PDB, data_df)
    domain = "GH_" + familia
    CAZY_family = "GH" + familia
    atomo

    # easimap_all {hmm_column domain pdb_code_ref CAZY_fam ligando atom_chain atomo}
    string = ("easimap_all \\\"" + str(HMMcols) +"\\\" " + domain + " " + PDB
              + " " + CAZY_family + " " +PDB+" \\\"" + lig_index +"\\\" " + atomo + " \\\"chain " + chain +"\\\"")

    return string


# Test
# data_df = None




