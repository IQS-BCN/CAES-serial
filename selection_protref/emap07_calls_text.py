import pandas as pd
import json
from emap06_generador_calls import get_calls


with open("FULL_DF_CAZY.json") as json_file:
    data = json.load(json_file)

df = pd.DataFrame(data)
    
df = df[df["Enzyme_Class"] == "GH"]
df = df.groupby("Family").size().reset_index(name='counts')
fams = df["Family"].values

famsS = sorted(fams, key=lambda x: int(x))
famsok = []
i = 0
file = "calls_f1"
r= ""
for fam in famsS:
    temp = (get_calls(fam, "sidechain", None))
    if temp != None:
        r = r + "echo \"" + temp + "\" | vmd -e easimaptodalacadena_CarboPlanes_v14.tcl"  "\n"
        famsok = famsok + [fam]
        



file = "calls_linux_vmd.txt"
with open(file, 'w') as file:
    file.write(r)

with open("families_ok.txt", 'w') as file:
    for fam in famsok:
        file.write(fam + "\n")

