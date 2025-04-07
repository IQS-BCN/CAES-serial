
import pandas as pd
import json

def seleccionar_prot_ref(familia, dades_df):
    """
    Selects a reference protein from a given family based on certain criteria:Family exists (1), 
    must have a canonical ligand (2, 3), must not have any mutations (4), 
    distance of C1 carbon must be coherent with catalytic activity (5) and the ligand must be complete (6).

    Args:
        familia (str): The family name.
        dades_df (DataFrame): The input dataframe containing protein data.

    Returns:
        str: The PDB code of the selected reference protein, or None if no protein meets the criteria.
    """
    # abrir el full de cazy
    dolents = ["6SEA", "1KWF", "1B9Z", "5D5B", "5HO9", "1F9D", "6Q3R", "5Z9S", "6EON", "6G0B", '3VGF']

    if dades_df == None:
        with open("FULL_DF_CAZY.json") as json_file:
            data = json.load(json_file)
            # convertir a dataframe
        
        df = pd.DataFrame(data)
    else:
        df = dades_df
# obrir el lligand annotation
    suc = pd.read_csv('ligand_annotation_1.txt', sep=',')
    #seleccionar la GH
    df = df[df["Enzyme_Class"] == "GH"]

    #seleccionar la familia donada
    df = df[df["Family"] == familia]

    #error si no existeix la familia
    if df.shape[0] == 0:
        with open('families_error.txt', 'a') as file:
            file.write("GH" + familia +" -No hi ha proteines\n")
        return None
    
    #eliminar els que no tenen PDB
    df = df.dropna(subset=["PDB_Code"])

    #error si no hi ha PDBs
    if df.shape[0] == 0:
        with open('families_error.txt', 'a') as file:
            file.write("GH"+ familia+" -No hi ha PDBs per les proteines \n")
        return None
    
    #eliminar els que no tenen lligand
    df = df.dropna(subset=["Annotated_Ligand"])

    #error si no hi ha lligands
    if df.shape[0] == 0:
        with open('families_error.txt', 'a') as file:
            file.write("GH" +familia+ " -No hi ha LLIGANDS ANOTATS \n")
        return None
    
    #eliminar els que tenen mutacions
    llista = []
    

    # seleccionar els que no tenen mutacions
    #FALLA, PASSEN AMB MUTACIONS
    for pdb in df["PDB_Code"].unique():
        if df[df['PDB_Code'] == pdb]['Mutation'].values[0] =="None":
            llista.append(pdb)
    

    # error si no hi ha proteines sense mutacions
    if len(llista) == 0:
        with open('families_error.txt', 'a') as file:
            file.write("GH"+familia+" -No hi ha proteines SENSE MUTACIONS \n")
        return None

    llistaCanonica = []
    SubstratsCanonics = ["GLC", "BGC", "GLA","GAL",
                         "MAN", "BMA","XYS", "XYP", "AHR", "FUB", 
                         "FUC", "FUL" , "NAG", "NGA","FRU", "Z9N"]

    # seleccionar els que tenen substrats canonics
    for pdb in llista:
        if df[df['PDB_Code'] == pdb]['Annotated_Ligand'].values[0] in SubstratsCanonics:
            llistaCanonica.append(pdb) 

    # error si no hi ha proteines amb substrats canonics
    if len(llistaCanonica) == 0:
        with open('families_error.txt', 'a') as file:
            file.write("GH" + familia +" -No hi ha proteines amb SUBSTRATS CANONICS \n")
        #with open('fam_errors/GH' + familia +'_PDBs_subs_no_canonics.txt', 'w') as file:
        #    for line in llista:
        #        file.write(line + "\n")
        return None

    # # seleccionar els que tenen 2 HMM columns
    # llista2HMM = []
    # for pdb in llistaCanonica:
    #     if len(df[df['PDB_Code'] == pdb]['HMM_Columns'].values[0]) == 2:
    #         llista2HMM.append(pdb)

    # # error si no hi ha proteines amb 2 HMM columns
    # if len(llista2HMM) == 0:
    #     with open('families_error.txt', 'a') as file:
    #         file.write("GH"+ familia+" -No hi ha proteines amb 2 COLUMNES DE HMM \n")
        
    #     with open('fam_errors/GH'+familia +'_PDBs_no_2_HMMcol.txt', 'w') as file:
    #         for line in llista:
    #             file.write(line + "\n")
    #     return None
    

    # seleccionar els que tenen distancies de C1 que siguin <4 i >3 0 <7 i >6
    inverting = ["6", "19", "37", "47", "67", "90"]
    llistadist = []
    llistaNodist = []
    llistaNopdb = []
    if familia in inverting:
        for pdb in llistaCanonica:
            if pdb in suc['pdb_code'].unique():
                if float(suc[suc['pdb_code'] == pdb]['dist'].values[0]) < 7 and float(suc[suc['pdb_code'] == pdb]['dist'].values[0]) > 6: 
                    llistadist.append(pdb)
                else:
                    llistaNodist.append(pdb)
            else:
                llistaNopdb.append(pdb)
    else:    
        for pdb in llistaCanonica:
            if pdb in suc['pdb_code'].unique():
                if float(suc[suc['pdb_code'] == pdb]['dist'].values[0]) < 4 and float(suc[suc['pdb_code'] == pdb]['dist'].values[0]) > 3: 
                    llistadist.append(pdb)
                else:
                    llistaNodist.append(pdb)
            else:
                llistaNopdb.append(pdb)       

    borra = False
    for i in range(len(llistadist)):
        if borra == False:
            if llistadist[i] in dolents:
                llistadist.pop(i)
                borra = True

    if len(llistadist) == 0 and len(llistaNodist)==0 :
        #with open('fam_errors/GH' + familia +'_PDBs_no_dist.txt', 'w') as file:
        #    for line in llistaNopdb:
        #        file.write(line + "\n")
        with open('families_error.txt', 'a') as file:
            file.write("GH"+ familia+" -No hi ha proteines amb distancia de C1 coneguda \n")
        return None
    
    if len(llistadist) == 0 and len(llistaNodist)!=0:
        #with open('fam_errors/GH' + familia +'_PDBs_dist_malament.txt', 'w') as file:
         #   for line in llistaNodist:
         #       file.write(line + "\n")
        with open('families_error.txt', 'a') as file:
            file.write("GH"+ familia+" -No hi ha proteines amb distancia de C1 entre 3 i 4 \n")
        return None

    llistasucBo = []
    llistasucDol = []
    
    
            
    for i in range(len(llistadist)):
        if llistadist[i] in suc['pdb_code'].unique():
            llistasucBo.append(llistadist[i])
    for pdb in llistadist:
        posicions = ["C1", "C2", "C3", "C4", "C5", "O5"]


        for pos in posicions:
            temp = suc[suc['atom_name'] == pos]  
            if pos == "C1":
                lig_molecule = temp[temp['pdb_code'] == pdb]["mol_index"].values[0]
            else:
                if lig_molecule != temp[temp['pdb_code'] == pdb]["mol_index"].values[0]:
                    llistasucDol.append(pdb)
                else:
                    if pos == "O5" and lig_molecule == temp[temp['pdb_code'] == pdb]["mol_index"].values[0] :
                        llistasucBo.append(pdb)
            
    if len(llistasucBo) == 0:
        #with open('fam_errors/GH' + familia +'_PDBs_no_lig_mateixa_struct.txt', 'w') as file:
        #    for line in llistasucDol:
        #        file.write(line + "\n")
        with open('families_error.txt', 'a') as file:
            file.write("GH"+ familia+" -No hi ha proteines amb lligands de la mateixa estructura \n")
        return None
    

    
    
    
    return llistasucBo[0]

    
def get_chain(pdb):
    with open("FULL_DF_CAZY.json") as json_file:
        data = json.load(json_file)
        
    
    df = pd.DataFrame(data)

    chain = df[df['PDB_Code'] == pdb]['CIF_Chain'].values[0]

    return chain


#a = []

#for i in range(200):
   #if seleccionar_prot_ref(str(i), None) != None:
 #       a.append(seleccionar_prot_ref(str(i), None))
   # 

#rint(a)
    
            


