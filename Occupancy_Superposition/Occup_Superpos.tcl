global path

#////////////////Occupancy_Superposition/////////////////////

#argumentos:
#hmm_column -> Las posiciones del HMM que se usarán para la superposición Ej: 165 360
#domain -> El nombre en Pfam de la familia cuyo HMM se quiere utilizar Ej: PF00232
#pdb_code_ref -> El nombre del archivo PDB de la proteína que se utilizará como referencia Ej: 3SCU
#CAZY_fam -> El nombre de la familia de proteínas cuyos PDB se descargarán de Cazy Ej: GH1
#atom_chain -> Lista de los atomos del anillo del ligando: c1 c2 c3 c4 c5 o5 Ej: "4552 4553 4554 4555 4556 4562"
#atomo -> El tipo de átomo o conjunto de átomos que se desean representar Ej: sidechain
#chainR -> Cadena del ligando Ej: "chain A"


# usage:
#
#   source Occup_Superpos.tcl
#   occup_superpos "165 360" GH_1 3SCU GH1 10 1 2 4 6 9 sidechain "chain A"


# modificat 8/04 per JFP
#	canviar el que envia a origen per que quadri amb el que necessita el carboplanes
# 	canviar el origen a origen_carbo_planes
proc occup_superpos {hmm_column domain pdb_code_ref CAZY_fam atom_chain atomo chainR} {

	global path

#indicar el path de la carpeta EASiMap
	#set path "/home/jfillol/EASiMap_v1.0/TEST/Test_T2"
  	#set pathpdb ""
	
#llamada a los programas que se utilizarán
	

	#fa falta
	source hmm_obtenir_eloi.tcl 
	source nuevo_beta_occupancy.tcl
	source superposicion_de_estructuras_version_familias_v2.tcl
	source origen_carbo_planes_v2.tcl
	source alinear_vectores.tcl

#Eliminar las moléculas que podían estar cargadas antes de lanzar el programa
	set MOLSLIST [molinfo list]
        foreach molid $MOLSLIST {
        	mol delete $molid }

#siempre se descarga protref y se cambian la occupancy y el factor de sus átomos 
#por la posición en el HMM y la altura en el logo respectivamente
#Hay que asegurarse de que esta proteína no presenta errores en la numeración
    
	set cif_path "$pdb_code_ref.cif"
    	mol new $cif_path
	

	set_beta_occupancy_hmms $domain $pdb_code_ref $chainR
	
# set la dist 1 per calcular la distancia relativa entre res cat despres i eliminar els q estan lluny	


	set ligguardado [atomselect top "all"]
	$ligguardado writepdb $pdb_code_ref.pdb


	
	#set pdbguardado [atomselect top $chainR]

       	#$pdbguardado writepdb $path/PDBs/${pdb_code_ref}_${domain}_${hmm_column}.pdb
	

	origenC $atom_chain

 	set dist1 [atomselect top "occupancy $hmm_column and backbone"]
	set mol_id_ref [molinfo top]


   
#inicialitzar
 	set channellog [open "logs/${CAZY_fam}_occupancy_superposition_log.tsv" w ]

   	puts  $channellog "pdb,code,result,error"
    
   	set channellog [open "logs/${CAZY_fam}_occupancy_superposition_log.tsv" a ]

											

#Repetir el paso con cada proteína de la lista
    	set archivo [open ${CAZY_fam}.txt]
   	set abierto [read $archivo]
   	set lineas [split $abierto "\n"]

    	foreach linea $lineas {

		set code [lindex $linea 0]
		set chain [lindex $linea 1]

    	if {$code == ""} {
    		
    		puts "Fin" }

 	if {$code != "" } {
				set pd [file exists "${code}/${code}_origin.pdb"]

				if {$pd == 0} {
					#mol pdbload $code
						
					set cif_path "../../CAZYMES_3D/$code.pdb"
                        		set mol_loaded 0
					catch {	
						mol new $cif_path waitfor all
						set mol_loaded 1
						set pdbload 0
						} 
					if {$mol_loaded == 0} {
							puts $channellog "$code,10,Fail,failure to load molecule"								
							} 						
					if {$mol_loaded == 1} { 
						set estado3 [set_beta_occupancy_hmms $domain $code $chain]
						if {$estado3 == 1 } {
							#si falla se acomula el error en el log y se borra la representación						
							#puts "mal alineamiento o FASTA vacia [molinfo top get name]"
							puts  $channellog "$code,11,Fail,failure to align HMM or set beta occupancy"
							mol delrep 0 top
								} else { set pn3 $code } }

					if {{$estado3 != 1} && {$pn3 == $code} } { 
						#si no falla continuar
						set mol_id_comp [molinfo top]									
						#Superposición del PDB utilizando la proteína de referencia
						set estado4 [superposicion_de_estructuras $hmm_column $domain $CAZY_fam $mol_id_ref $mol_id_comp $code $chain]
						if {$estado4 == 1 } {
							#si falla se acomula el error en el log y se borra la representación	
							#puts "mala seleccion de átomos [molinfo top get name]"
							puts  $channellog "$code,12,Fail,failure align with reference protein"
							mol delrep 0 top } else { set pn4 $code } }
							
					if {{$estado4 != 1} && {$pn4 == $code} } {	

						set dist2 [atomselect $mol_id_comp "occupancy $hmm_column and backbone"]

						set separacio [measure rmsd $dist1 $dist2]			
						
						if {$separacio > 5} { 
						
							#si falla se acomula el error en el log y se borra la representación			
							#puts "los residuos cataliticos de $code estan separados entre si"
						
							puts  $channellog "$code,13,Fail,failure select proper catalytic residues"
							mol delrep 0 top
						
							} else { set sep $code } }

					if {{$separacio <= 5} && { $sep == $code } } {

						#representacio final
						#guardar mol
						set pdbguardado [atomselect top "all"]
		       				$pdbguardado writepdb ${code}/${code}_origin.pdb 

						#LOG
						if {$pdbload == 0} { puts  $channellog "$code,00,Success,na" }
								}
		       					}					
		       			} 
					}	
				}



	close $channellog
   }


