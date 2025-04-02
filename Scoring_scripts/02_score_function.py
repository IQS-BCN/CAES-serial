import pandas as pd
import numpy as np

import sys

def score_function(params):
    # establir paths
    df = params

    out = pd.DataFrame(columns=['Model', 'Frame', 'Type', 'Oxygen', 'Score_w', 'Score0', 'Score1', 'Score2', 'Score3', 'Score4', 'Score5'])
    #definir els offsets (ValRef) de AB
    o_AB = [2.8005,110,-0.57,110,0.98005,1]

    #definir els offsets (ValRef) de Nuc
    o_Nuc = [3.5,110,1,110,0.8005,1]

    #definir l'amplada dels intervals
    wi_AB = [x*0.3 for x in o_AB]
    print(o_AB)
    print(wi_AB)
    wi_Nuc = [x*0.3 for x in o_Nuc]
    #definir els pesos
    we = [1,1,1,1,0,1]

    dades = df[['d', 'alpha', 'omega', 'beta', 'theta', 'gamma']]

    for i in range(len(df)):
        if df.loc[i, 'Type'] == 'AB':
            s, t = puntuacio(dades.loc[i], o_AB, wi_AB, we)
        if df.loc[i, 'Type'] == 'Nuc':
            s, t = puntuacio(dades.loc[i], o_Nuc, wi_Nuc, we)
        out.loc[i, 'ID'] = df.loc[i, 'ID']
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

params = pd.read_csv('params.csv')
a = score_function(params)

#a = pd.concat([a, t], axis=1)
print(a)
a.to_csv('output.csv', index=False)
