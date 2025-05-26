File containing the necessary scripts to run the SMINA docking with restraints.

In the different directories, there is a *README.md* file explaining the main usage and requirements of the given procedure.

What is where? This repo is organized in the following structure:

1. **Docking**
In the *.\Docking* directory there are scripts related to doing the actual geometricaly restrained docking of a receptor-ligand pair.

2. **Scoring**
In the *.\Scoring* directory there are the scripts related to calculating the geometric parameters and obtaining the geometric score based on said parameters.

3. **Addatoms**
In the *.\Addatoms* directory there are the scripts to add the Cl, S, I and Zn to the receptor and ligand, to be able to set the restraints for the docking procedure.

4. **Modeller**
In the *./Modeller_serial* directory there are the scripts to model the side chain flexibility of the receptors.


The file to run the pipeline is do_CAES.sh, with a workflow as follows:

![do_CAES](https://github.com/user-attachments/assets/0945cbba-24d9-44dc-bc96-c0fe9eb8b4a4)
