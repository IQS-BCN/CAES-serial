#v2: treure set chain pq ja entra desde Emap

proc superposicion_de_estructuras {hmm_column domain CAZY_fam mol_id_ref mol_id_comp code chainT} {
 
 	global path

 	#puts "entrando en superposicion_de_estructuras"
	set chain "$chainT"


#Matriz de desplazamiento y alineamiento
#Los átomos que se utilizan se pueden modificar según se desee
	set atoms "C O N CA CB"

	set listaref [llength [[atomselect $mol_id_ref " backbone and $chain and occupancy $hmm_column and name $atoms" ] list]]
	set listacomp [llength [[atomselect $mol_id_comp  " backbone and $chain and occupancy $hmm_column and name $atoms"] list]]

	set estado4 0
		
        if {$listaref != $listacomp} {set estado4 1}
      
	if {$estado4 ==1} {return $estado4}

	set atoms "C O N CA CB"
	set reference_sel  [atomselect $mol_id_ref " backbone and $chain and occupancy $hmm_column and name $atoms"]
		
	set comparison_sel [atomselect $mol_id_comp  " backbone and $chain and occupancy $hmm_column and name $atoms"]
		
	set transformation_mat [measure fit $comparison_sel $reference_sel]

	set move_sel [atomselect $mol_id_comp "all"]
	$move_sel move $transformation_mat

		
	
	
}
