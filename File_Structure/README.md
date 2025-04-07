# File Structure

This scripts allow for the structure of the RESULTS directory to be built. It is asummed that the script is run in a directory with the items listed below:

## Needed Structure

* **./PROTLISTS**
Directoriy containing the different lists of proteins to be evaluated for each GH family. The files shoud be: GH_1.txt, GH_2.txt, GH_3.txt ... GH_i.txt

* **./HMM**
Directory containing the different hmm for the different families. As it comes from **Eloy**'s work: ```HMM/GH_i/GH_i.hmm```

* **./CATRES**
Directory containing the different files annotating the catalitic residues' position on the HMM. The files should be named ```GH_i.catres```

* **./PDB_REF**
Directory containg the different pdb files used as reference for each familiy. The files should be named: ```GH_i_xxxx.pdb```
It is expected that there will also be a file named ```GH_i_xxxx.atoms```, containing the atom indexes for the sugar ring for the given pdb.
It is criticall that the pdb's contain GH_i_ at the start, to be able to select them for their given family.
