proc alinear_vectores {vector axis} {

    global path
    puts "alineando vector con eje $axis"

    if {$axis == "x"} {
 
        set vec1 [vecnorm $vector]

        set vec2 [vecnorm {1 0 0}]

    } elseif {$axis == "y"} {
 
        set vec1 [vecnorm $vector]

        set vec2 [vecnorm {0 1 0}]


    } elseif {$axis == "z"} {

        set vec1 [vecnorm $vector]

        set vec2 [vecnorm {0 0 1}]

  
    } else {puts "solo x, y o z"}

#Se determinan el ángulo y eje de rotación
    set rotvec [veccross $vec1 $vec2]
    set sine   [veclength $rotvec]
    set cosine [vecdot $vec1 $vec2]
    set angle [expr atan2($sine,$cosine)]
    puts "angulo para corrección de eje $axis : $angle"
    puts "sen: $sine"
    puts "cos: $cosine"


	set center "0 0 0"

#Se alinean todas las moléculas
	set MOLSLIST [molinfo list]
	foreach molid $MOLSLIST {
  	 [atomselect $molid "all"] move [trans center "$center" axis $rotvec $angle rad]
	}

	puts "vector alineado con eje $axis"
}



