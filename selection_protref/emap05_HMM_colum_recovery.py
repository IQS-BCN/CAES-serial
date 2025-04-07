import pandas as pd
import json

def get_HMM_cols(PDB, dades_df):
    if dades_df == None:
        with open("FULL_DF_CAZY.json") as json_file:
            data = json.load(json_file)
            # convertir a dataframe
        
        df = pd.DataFrame(data)
    else:
        df = dades_df

    df = df[df['PDB_Code'] == PDB]

    catres = df["Cat_Res_Uniprot"].values[0]
    catpred = df["Cat_Res_Predicted"].values[0]
    HMMcols = df["HMM_Columns"].values[0]
    i = 0
    m = 0
    r = 0 
    for i in range(len(catres)):
        for m in range(len(catpred)):
            if catres[i] == catpred[m]:
                if r == 0:
                    result = str(HMMcols[m])
                    r += 1
                else:
                    result += " " + str(HMMcols[m])
        


    return result

# print(get_HMM_cols("7V0I", None))