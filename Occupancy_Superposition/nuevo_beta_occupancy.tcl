#Antes de llamar a este proceso hay que asegurarse de que la molécula está cargada
#y de que el archivo del HMM existe
#No es necesario descargar más archivos

proc set_beta_occupancy_hmms {domain pdb_id chain} {

  global path

  #puts "set_beta_occupancy $pdb_id"

#Determinar las variables y cambiar los valores de beta y occupancy a 0
  #set vmd_selection "protein and chain A"
  set vmd_selection "protein and $chain"
  set hmm_file "$domain.hmm"
  set mol_id top
  set all_pdb [atomselect $mol_id "all"] 
  
  $all_pdb set beta 0 
  $all_pdb set occupancy 0 
  set estado2 [set_beta_occupancy_hmm2 $vmd_selection $hmm_file $mol_id]
  
  if {$estado2 ==1} {return $estado2}
}


#Cambiar el beta factor y la occupancy de la molécula (pdb_id)
#por las correspondientes alturas y posciones del HMM (domain)
proc set_beta_occupancy_hmm2 {vmd_selection hmm_file {mol_id top}} {
  set protein_selection [atomselect $mol_id $vmd_selection]
  array set HMM_MY_POSITIONS [hmm_align $hmm_file $protein_selection]

#Filtro para eliminar los PDBs que puedan tener numeración diferente y que generará problemas en los siguientes pasos
#Se debe revisar para buscar la manera de incluirlos también
#En caso de que pase el filtro se extraen las posiciones del HMM
  #if {[[atomselect top "protein"] get residue] == ""} {

   # return 1
    
 # } #elseif {[[atomselect top "protein and chain A and residue 2"] get residue] == ""} {

  #  return 1
    
  #} elseif {[[atomselect top "protein and chain A and residue 1"] get residue] == ""} {

   # if {$HMM_MY_POSITIONS(2) ==-1} {return 1}
    
  #} elseif {[[atomselect top "protein and chain A and residue 0"] get residue] == ""} {

   # if {$HMM_MY_POSITIONS(1) ==-1} {return 1}
    
  #} elseif {$HMM_MY_POSITIONS(0) ==-1} {return 1}

#Aquí se extraen las alturas del HMM
  array set HMM_MY_HEIGHTS   [hmm_heights $hmm_file]


#Aquí se le asignan los valores nuevos a las columnas occupancy y beta
  foreach rid [$protein_selection get residue] {
    if { $HMM_MY_POSITIONS($rid) != 0 } {
      set pp $HMM_MY_POSITIONS($rid)
      set hh $HMM_MY_HEIGHTS($pp)
      set sel [atomselect $mol_id "residue $rid"]
      $sel set occupancy $pp
      $sel set beta      $hh
    }
  }
}


#Proceso de obtención de las alturas del HMM
proc hmm_heights {hmm_file} {
  set data [exec hmmlogo --no_indel $hmm_file]
  set position_height [lsearch -all $data "("]
  set height ""

  array set hmm_height {}
  set pos 1
  foreach position $position_height {
    set h [string trim [lindex $data [expr $position + 1]] ")"]
    set hmm_height($pos) $h
    incr pos
  }
  return [array get hmm_height]
}


# Alineamiento del PDB con el HMM
# devuelve una lista con la posición del HMM para cada residuo de la selección
proc hmm_align {hmm_file protein_selection} {

#Obtención de la secuencia fasta a partir del PDB
  set fasta_sequence [get_fasta $protein_selection]

  if {$fasta_sequence ==1 } {
    array set hmm_pos {}
    set hmm_pos(0) -1
    return [array get hmm_pos]
  }

  set fasta_file "sequence.fasta"
  set channel_fasta_file [open $fasta_file w]
  puts $channel_fasta_file $fasta_sequence
  close $channel_fasta_file

	set initial [exec hmmalign --outformat SELEX $hmm_file $fasta_file]

#Separar el alineamiento para trabajar con el 
	set position_pdb [lsearch -regexp -nocase -all $initial "VMD_SEQUENCE_FROM_SELECTION"]
        set position_hmm [lsearch -regexp -all $initial "\#\=RF"]

        set list_pdb ""
        foreach position_p $position_pdb {
          set fragment_p [split [lindex $initial [expr $position_p + 1]] {}]
          set list_pdb [concat $list_pdb $fragment_p]
        }

	set list_hmm ""
	foreach position_h $position_hmm {
	  set fragment_h [split [lindex $initial [expr $position_h + 1]] {}]
	  set list_hmm [concat $list_hmm $fragment_h]
	}


#Obtener los números de los residuos de la misma manera que se obtuvo la secuencia fasta
   set rrs [lsort -unique -dictionary [$protein_selection get {residue resname}]]


#Trabajar con ambas listas para obtener las posiciones 
	
	set limit [llength $list_hmm]
	set position_pdbe ""
	set a 0
  set p 0
  set pp 0
#y será el número de residuo, por lo que el primero debe ser 0
  set y -1

  array set hmm_pos {}

	for {set x 0} {$x < $limit } {incr x} {
	  set char [lindex $list_hmm $x]
	  set aa [lindex $list_pdb $x]

#asignar la posicioón del HMM a cada aminoácido de la secuencia fasta por medio de un alineamiento
	  if {$char == "x"} {
	    incr p
	  } 
	  if {$aa != "-" } {
	    incr y 
            if {$char == "x"} {
              set pp $p
            } else {
              set pp 0
            }
          }

#obtener los numeros de residuo reales en la selección, correspondientes a la posición en la secuencia fasta
    set ridue [lindex [lindex $rrs $y] 0]

          set hmm_pos($ridue) $pp
	}

	return [array get hmm_pos]

}


#Obtención de la secuencia fasta
#a partir de los números de residuos "únicos" en la selección
proc get_fasta {selection} {
  set aa(ALA) "A"
  set aa(CYS) "C"
  set aa(ASP) "D"
  set aa(GLU) "E"
  set aa(PHE) "F"
  set aa(GLY) "G"
  set aa(HIS) "H"
  set aa(ILE) "I"
  set aa(LYS) "K"
  set aa(LEU) "L"
  set aa(MET) "M"
  set aa(ASN) "N"
  set aa(PRO) "P"
  set aa(GLN) "Q"
  set aa(ARG) "R"
  set aa(SER) "S"
  set aa(THR) "T"
  set aa(VAL) "V"
  set aa(TYR) "Y"
  set aa(TRP) "W"


#Obtener una lista de los residuos y sus nombres de la selección
  set rrs [lsort -unique -dictionary [$selection get {residue resname}]]

  set sequence ""
  foreach rr $rrs {
    set ridue [lindex $rr 0]
    set rname [lindex $rr 1]
    if { [array names aa -exact $rname] != "" } {
      set thisaa $aa($rname)
    } else {
      #Para continuar se le asigna una letra no incluída en el código de aminoácidos
      set thisaa "z"
    }
    set sequence [concat ${sequence}$thisaa]
  }
  
  set estado1 0
  if {$sequence == ""} {
    set estado1 1 
     }
     if {$estado1 == 1} {return $estado1}
     

  set fasta_header ">VMD_SEQUENCE_FROM_SELECTION"
  set fasta "${fasta_header}\n$sequence"
  return $fasta 
}


