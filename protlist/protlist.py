import pandas as pd
import numpy as np

#read tsv
tsv = pd.read_csv('protlist\cazyme3d_full.tsv', sep='\t')

tsv_slim = tsv.drop(columns=['taxonomy', 'cluster_num', 'cluster_num', 'cluster_num', 'cluster_num'])
print('Total number of entries in CAZyMes3D:                           ' + str(len(tsv_slim)))
tsv_s50 = tsv_slim[tsv_slim['rep_id'] == 'Rep-ID50']
tsv_s50 = tsv_s50.drop(columns=['rep_id'])

 #read fam file
with open('protlist\\fams.txt') as f:
  fams = f.read().splitlines()

#remove _ from fams
fams = [x.replace('_', '') for x in fams]

fams_slim = tsv_slim[tsv_slim['family'].isin(fams)]
print('Number of structures of families with protref:                  ' + str(len(fams_slim)))

fams_slim = fams_slim.drop_duplicates(subset=['uniprot_mapped'])
print('Number of protref structures without uniprot duplicates:        ' + str(len(fams_slim)))

print('----------------------------------------------------------------------------------------')
#keep only tsv_s50 rows that are in fams
print('Number of structures where squence id < 50%:                    ' + str(len(tsv_s50)))
tsv_s50 = tsv_s50[tsv_s50['family'].isin(fams)]
print('Number of ID50 structures of familes wth protref:               ' + str(len(tsv_s50)))
tsv_s50 = tsv_s50.drop_duplicates(subset=['uniprot_mapped'])
print('Number of ID50, prot ref structures without uniprot duplicates: ' + str(len(tsv_s50)))

for fam in fams:
    
    fam_rows_s50 = tsv_s50[tsv_s50['family'] == fam]
    fam_rows_s50 = fam_rows_s50['cazyid']
    print('Number of ID50 structures in ' + fam + ':                      ' + str(len(fam_rows_s50)))
    fam_rows_s50.to_csv('protlist\\' + fam + '_ID50.txt', index=False, header=False)
    