import pandas as pd
import numpy as np

import sys

def score_function(params, ntype):
    # establir paths
    df = params

    out = pd.DataFrame(columns=['Model', 'Frame', 'Type', 'Oxygen', 'Score_w', 'Score0', 'Score1', 'Score2', 'Score3', 'Score4', 'Score5'])
    #definir els offsets (ValRef) de AB
    o_AB = [2.8005,110,-0.57,110,0.98005,1]

    if ntype == 'R':
        #definir els offsets (ValRef) de Nuc
        o_Nuc = [3.5,110,1,110,0.8005,1]

    #definir l'amplada dels intervals
    wi_AB = [0.9, 20, 0.18, 20, 0.33, 0.2]
    wi_Nuc = [1, 20, 0.18, 20, 0.33, 0.2]
    #definir els pesos
    we = [1,1,1,1,0,1]

    dades = df[['d', 'alpha', 'omega', 'beta', 'theta', 'gamma']]

    for i in range(len(df)):
        if df.loc[i, 'Type'] == 'AB':
            s, t = puntuacio(dades.loc[i], o_AB, wi_AB, we)
        if df.loc[i, 'Type'] == 'Nuc':
            s, t = puntuacio(dades.loc[i], o_Nuc, wi_Nuc, we)
        out.loc[i, 'Model'] = df.loc[i, 'Model']
        out.loc[i, 'Frame'] = df.loc[i, 'Frame']
        out.loc[i, 'Type'] = df.loc[i, 'Type']
        out.loc[i, 'Oxygen'] = df.loc[i, 'Oxygen']
        out.loc[i, 'Score_w'] = s
        for j in range(len(t)):
            out.loc[i, 'Score'+
                    str(j)] = t[j]
            
    return out 

    # definir funció de puntuació
def puntuacio(dades, offset, width, weights):
    """Calcula la puntuació de les dades"""

    s = []
    #per cada valor de dades, calcula el valor de la funció switch segons el offset i width donats
    i = 0
    for datapoint in dades:
        si = (1-(((datapoint-offset[i])/(width[i]))**6))/(1-(((datapoint-offset[i])/(width[i]))**12))
        si = round(si, 2)
        s.append(si)
        i += 1
    #calcula la puntuació final amb els weights donats
    st = 0
    for i in range(len(weights)):
        st += s[i]*weights[i]
    

    return st/sum(weights), s


import sys
import argparse

parser = argparse.ArgumentParser(
    description="Function to score a given receptor - ligand pair, using the parameters calculated with 01_calc_params.py")




#-db DATABASE -u USERNAME -p PASSWORD -size 20000
parser.add_argument("-i", "--input", dest = "input", default = "parameters.csv", help="CSV file with the calculated parameters of the poses to score")
parser.add_argument("-o", "--output", dest = "out", default = "score.csv", help="CSV file with the resulting scores")
parser.add_argument('-nt', '--NucType', dest = 'ntype', default='R', help='Type of nucleophile activity: R for retaining activity, I for inveritng activity (not implemented)')
parser.add_argument('-v', '--verbose',action='store_true')

args = parser.parse_args()

if args.verbose:
    print("SCORING GEOMETRIC PARAMETERS FOR:\nInput file: {}\nOutput file: {}\nNucleophile type: {}".format(
        args.input,
        args.out, 
        args.ntype 
    ))

params = pd.read_csv(args.input)

a = score_function(params, args.ntype)
a.to_csv(args.out, index=False)
