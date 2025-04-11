from modeller import *
from modeller.automodel import *

log.verbose()

env = environ(rand_seed=-23452)

class MyModel(automodel):
    def special_patches(self, aln):
        # Rename both chains and renumber the residues in each
        self.rename_segments(segment_ids=['A', 'X'],
                             renumber_residues=[1, 1])


# Read in HETATM records from template PDBs
env.io.hetatm = True

a = MyModel(env, 
              alnfile='./ALIGNMENT.pir',
              knowns='template',
              sequence='model',
              assess_methods=(assess.DOPE, assess.normalized_dope, assess.GA341))

# Very thorough VTFM optimization:
#a.library_schedule = autosched.slow
#a.max_var_iterations = 300

# Thorough MD optimization:
#a.md_level = refine.slow

# Align new structures to template, and write them to _fit.pdb
a.final_malign3d = True

a.starting_model = 1
a.ending_model = 20 
a.make()
