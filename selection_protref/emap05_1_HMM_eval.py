import pandas as pd
import json
from emap05_HMM_colum_recovery import get_HMM_cols

def get_HMM(familia, dades_df):
    if dades_df == None:
        with open("FULL_DF_CAZY.json") as json_file:
            data = json.load(json_file)
            # convertir a dataframe
        
        df = pd.DataFrame(data)
    else:
        df = dades_df
    df = df[df["Enzyme_Class"] == "GH"]
    dff = df[df['Family'] == familia]
    pdbs= []
    for pdb in dff["PDB_Code"].unique():
        if df[df['PDB_Code'] == pdb].shape[0] == 1:
            pdbs.append(pdb)
            
    for pdb in pdbs:
        catres = df[df['PDB_Code'] == pdb]['Cat_Res_Uniprot'].values[0]
        catpred = df[df['PDB_Code'] == pdb]['Cat_Res_Predicted'].values[0]
        if catres != ['None']:
            if catres == catpred:
                if (len(df[df['PDB_Code'] == pdb]['HMM_Columns'].values[0])) > 1:
                    #print(pdb)
                    return get_HMM_cols(pdb, None)
    

    with open('families_error.txt', 'a') as file:
        file.write("GH"+ familia+" - Cap pdb on la predicció de HMM sigui bona \n")
    return None



# print(get_HMM_cols("3VGF", None))
