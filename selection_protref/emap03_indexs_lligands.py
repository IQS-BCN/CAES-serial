
def ligand_indexes(pdb_code, ligands):
        
    import pandas as pd

    if ligands is None:
        df = pd.read_csv('ligand_annotation_1.txt', sep=',')
    else:
        df = ligands    
    df = df[df['pdb_code'] == pdb_code]
    ligand_indexes = [0,0,0,0,0,0]
    ligand_chain = []
    posicions = ["C1", "C2", "C3", "C4", "C5", "O5"]
    i = 0
    for pos in posicions:
        temp = df[df['atom_name'] == pos]
        ligand_indexes[i] = int(temp["atom_index"].values[0])
        if pos == "C1":
            ligand_chain = temp["mol_index"].values[0]
        else:
            if ligand_chain != temp["mol_index"].values[0]:
                print(f"Error: The ligand for {df['pdb_code'].values[0]} has different molecules annotated for atoms {pos} and C1")
                return None
        i += 1

    lig_indexes = str(ligand_indexes[0]) + " " + str(ligand_indexes[1]) + " " + str(ligand_indexes[2]) + " " + str(ligand_indexes[3]) + " " + str(ligand_indexes[4]) + " " + str(ligand_indexes[5])

    return lig_indexes



#print(ligand_indexes("7VKY", None))
