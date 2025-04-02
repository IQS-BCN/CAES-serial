import numpy as np
import pandas as pd
from math import atan2, degrees
from Bio import PDB
from Bio.PDB import PDBParser
import os
import sys
from ori_pos import *

def calc_params(path_receptor, path_ligand, occupancyAB, occupancyNuc, indexslligand = [], chainlig = 'X'):
    """ Calculate the parameters for the orientation of the ligand in the receptor
    Args:
        path_receptor: path to the receptor pdb file
        path_ligand: path to the ligand pdb file
        occupancyAB: occupancy value for the atoms of the AB
        occupancyNuc: occupancy value for the atoms of the Nucleophile

        indexslligand: (optional) list of the indexes of the atoms of the ligand to calculate the parameters
        chainlig: (Optional) chain of the ligand to calculate the parameters
        
    Returns:
            params: pandas dataframe with the parameters calculated for the orientation of the ligand in the receptor
    """
    params = pd.DataFrame(columns=['Model', 'Frame','Type', 'Oxygen', 'd', 'alpha', 'omega', 'beta', 'theta', 'gamma'])
    modelnum = 0
    #inicialitzar parser
    parser = PDBParser(PERMISSIVE=1, QUIET=True)

    #parse estrcutrua receptor i lligand
    receptor = parser.get_structure("receptor", path_receptor)
    ligand = parser.get_structure("ligand", path_ligand)

    #inicialitzar una llista per les cadenes bones de lligands
    ligand_bons = []
    #seleccionar les cadenes que no estiguin buides com a cadenes bones de lligand
    for model in ligand:
        if len(model) != 0:
            ligand_bons.append(model)

    # inicialitzar llistes per a el nucleofil i AB
    AB = []
    Nuc = []
    ab = 0
    nuc = 0

    for residue in receptor.get_residues():
        for atom in residue:
            if atom.occupancy == occupancyAB:
                ab= 1
            if atom.occupancy == occupancyNuc:
                nuc = 1
        if ab == 1:
            AB = residue
        if nuc == 1:
            Nuc = residue
        ab = 0
        nuc = 0
                
    #seleccionar o1, o2 i c de l'AB
    c_AB = 0
    for atom in AB:
        if atom.get_id()[-1] == '1':
            o1_AB = atom.get_coord()
        if atom.get_id()[-1] == '2':
            o2_AB = atom.get_coord()
        if atom.get_id()[-1] == 'D':
            c_AB = atom.get_coord()
        if atom.get_id()[-1] == 'G':
            temp = atom.get_coord() 

    if type(c_AB) == int:
        c_AB = temp


    #seleccionar c1, c2 i n de l'Nuc
    c_Nuc = 0
    for atom in Nuc:
        if atom.get_id()[-1] == '1':
            o1_Nuc = atom.get_coord()
        if atom.get_id()[-1] == '2':
            o2_Nuc = atom.get_coord()
        if atom.get_id()[-1] == 'D':
            c_Nuc = atom.get_coord()
        if atom.get_id()[-1] == 'G':
            temp = atom.get_coord() 

    if type(c_Nuc) == int:
        c_Nuc = temp

    

    #recorrer cadascun dels models bons del lligand
    for model in ligand_bons:
        chain = model[chainlig]

        #recorrer els residus de la cadena i acomular el nom
        res_list = []
        for residue in chain:
            if residue.get_resname() not in res_list:
                res_list.append(residue.get_resname())
        #seleccionar el link que te el lligand
        link = ''
        for res in res_list:
            if res[0].isnumeric() and res[0] != '0':
                link = res[0]
                reslink = res
                break
        #si no es donen indexs de lligands:
        if indexslligand == []:
        #seleccionar el anell 1+ i -1
            for residue in chain:
                if residue.get_resname() == reslink:
                    s1 = residue
                if residue.get_resname()[0] == '0':
                    s0 = residue
            

            #seleccionar els atoms d'interes del lligand
            #seleccionar Og i Cn
    
            for atom in s1:
                nom = atom.get_id()
                if nom == 'O'+link:
                    og = atom.get_coord()
                if nom == 'C'+link:
                    cn = atom.get_coord()
            
            #seleccionar c1 i c2 de -1
            for atom in s0:
                nom = atom.get_id()
                if nom == 'C1':
                    c1 = atom.get_coord()
                if nom == 'C2':
                    c2 = atom.get_coord()
        else: # si es donen indexs de lligands
            for res in chain:
                for mol in res:
                    for atom in mol: #recorrer els atoms de la molecula i acomular els que siguin els indexs
                        if atom.get_serial_number() == indexslligand[0]:
                            og = atom.get_coord()
                        if atom.get_serial_number() == indexslligand[1]:
                            cn = atom.get_coord()
                        if atom.get_serial_number() == indexslligand[2]:
                            c1 = atom.get_coord()
                        if atom.get_serial_number() == indexslligand[3]:
                            c2 = atom.get_coord()


        #calcular els parametres
        p = ori_pos(o1_AB, c_AB, o2_AB, og, c1, cn)
        n = str(modelnum)
        
        model_file = path_receptor.split('.')[-2]
        params.loc[modelnum*4 +1] = [model_file, n, 'AB', '1', p[0], p[1], np.cos(np.radians((p[2]))), p[3], p[4], np.cos(np.radians((p[5]*2)))]
        p = ori_pos(o2_AB, c_AB, o1_AB, og, c2, cn)
        params.loc[modelnum*4 +2] = [model_file, n, 'AB', '2', p[0], p[1], np.cos(np.radians((p[2]))), p[3], p[4], np.cos(np.radians((p[5]*2)))]
        p = ori_pos(o1_Nuc, c_Nuc, o2_Nuc, c1, c2, og)
        params.loc[modelnum*4 +3] = [model_file, n, 'Nuc', '1',p[0], p[1], np.cos(np.radians((p[2]*2))), p[3], p[4], np.cos(np.radians((p[5]*3)))]
        p = ori_pos(o2_Nuc, c_Nuc, o1_Nuc, c1, c2, og)
        params.loc[modelnum*4 +4] = [model_file, n, 'Nuc', '2',p[0], p[1], np.cos(np.radians((p[2]*2))), p[3], p[4], np.cos(np.radians((p[5]*3)))]
        modelnum += 1
    return params

a = calc_params('4HU0_GH_5_120 157 258.pdb', '4HU0_GH_5_120 157 258.pdb', 157.00, 258.00, [2739,2733,2747,2742], 'B')

a.to_csv('params.csv', index=False)
