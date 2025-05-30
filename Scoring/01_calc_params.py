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
           for atom in chain.get_atoms():
               if atom.is_disordered() != 0:
                   print("sugar atoms are disordered, working arround it")
                   og = [atom.disordered_get_list()[0].get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[0])][0] 
                   cn = [atom.disordered_get_list()[0].get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[1])][0]
                   c1 = [atom.disordered_get_list()[0].get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[2])][0]   
                   c2 = [atom.disordered_get_list()[0].get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[3])][0]
               else:
                   og = [atom.get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[0])] 
                   cn = [atom.get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[1])]
                   c1 = [atom.get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[2])]   
                   c2 = [atom.get_coord() for atom in chain.get_atoms() if atom.serial_number == int(indexslligand[3])]
                   
        #calcular els parametres
        p = ori_pos(o1_AB, c_AB, o2_AB, og, c1, cn)
        n = str(modelnum)
        
        model_file = path_ligand.split('.')[-2]
        params.loc[modelnum*4 +1] = [model_file, n, 'AB', '1', p[0], p[1], np.cos(np.radians((p[2]))), p[3], p[4], np.cos(np.radians((p[5]*2)))]
        p = ori_pos(o2_AB, c_AB, o1_AB, og, c2, cn)
        params.loc[modelnum*4 +2] = [model_file, n, 'AB', '2', p[0], p[1], np.cos(np.radians((p[2]))), p[3], p[4], np.cos(np.radians((p[5]*2)))]
        p = ori_pos(o1_Nuc, c_Nuc, o2_Nuc, c1, c2, og)
        params.loc[modelnum*4 +3] = [model_file, n, 'Nuc', '1',p[0], p[1], np.cos(np.radians((p[2]*2))), p[3], p[4], np.cos(np.radians((p[5]*3)))]
        p = ori_pos(o2_Nuc, c_Nuc, o1_Nuc, c1, c2, og)
        params.loc[modelnum*4 +4] = [model_file, n, 'Nuc', '2',p[0], p[1], np.cos(np.radians((p[2]*2))), p[3], p[4], np.cos(np.radians((p[5]*3)))]
        modelnum += 1
    return params

import numpy as np
import pandas as pd
from math import atan2, degrees
from Bio import PDB
from Bio.PDB import PDBParser
import os
import sys
from ori_pos import *
import sys
import argparse

parser = argparse.ArgumentParser(
    description="Function to calculate the geometric parameters for the geometric scoring of a given receptor - ligand pair.")


#-db DATABASE -u USERNAME -p PASSWORD -size 20000
parser.add_argument("-r", "--receptor", dest = "receptor", default = "receptor.pdb", help="Receptor PDB file")
parser.add_argument("-l", "--ligand", dest = "lig", default = "ligand.pdb", help="Ligand PDB file, can have multiple frames")
parser.add_argument("-oAB", "--occupancyAB",dest ="oAB", help="Occupancy of AB residue. Must be format 123.00", type=float)
parser.add_argument("-oNuc", "--occupancyNuc",dest = "oNuc", help="Occupancy of Nuc residue. Must be format 123.00", type=float)
parser.add_argument("-i", "--ligindex",dest = "index", help="List of indexes for the ligand, 'og cn c1 c2'", default="")
parser.add_argument("-c", "--ligchain",dest = "chain", help="Chain of the ligand", default='X')
parser.add_argument('-v', '--verbose',action='store_true')
parser.add_argument('-o', "--output", dest='out', default='params.csv', help='File name for the output csv. Must include csv in the name.')

args = parser.parse_args()
args.index=args.index.split()
if args.verbose:
    print("CALCULATING GEOMETRIC PARAMETERS FOR:\nReceptor: {} \nLigand: {}\nOccupancy of AB & Nuc: {}, {}\n".format(
        args.receptor,
        args.lig,
        args.oAB,
        args.oNuc
    ))
    if args.index != []:
        print("Forcing ligand indexes to:\n   og: {}\n   cn: {}\n   c1: {}\n   c2: {}".format(
            args.index[0],
            args.index[1],
            args.index[2], 
            args.index[3]
        ))
    if args.chain != 'X':
        print("Forcing ligand chain to: chain {}".format(args.chain))



a = calc_params(args.receptor,args.lig,args.oAB,args.oNuc,args.index,args.chain)

a.to_csv(args.out, index=False)
