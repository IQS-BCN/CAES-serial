# modificat JFP 8/04/24
# 	canviar el input per que sigui lo del carboplanes

# v2: fer que el input sigui una llista, split la llista en " " i separar els atoms

proc origenC {atom_ring} {
  global path
  source alinear_vectores.tcl
  
  puts "entrando en origen"
  


  #puts $atom_ring

  set atom_1 [lindex $atom_ring 0]
  set atom_2 [lindex $atom_ring 1]
  set atom_3 [lindex $atom_ring 2]
  set atom_4 [lindex $atom_ring 3]
  set atom_5 [lindex $atom_ring 4]
  set atom_6 [lindex $atom_ring 5]
	

  # set ring [list $c1 $c2 $c3 $c4 $c5 $o5]
  set c1 [atomselect top "index ${atom_1}"]
  set c2 [atomselect top "index ${atom_2}"]
  set c3 [atomselect top "index ${atom_3}"]
  set c4 [atomselect top "index ${atom_4}"]
  set c5 [atomselect top "index ${atom_5}"]
  set o5 [atomselect top "index ${atom_6}"]
  set ring [atomselect top "index ${atom_1} ${atom_2} ${atom_3} ${atom_4} ${atom_5} ${atom_6}"]
  #puts $ring
# set R igual que al carboplanes

  set R(0) [lindex [$c1 get {x y z} ] 0]
  set R(1) [lindex [$c2 get {x y z} ] 0]
  set R(2) [lindex [$c3 get {x y z} ] 0]
  set R(3) [lindex [$c4 get {x y z} ] 0]
  set R(4) [lindex [$c5 get {x y z} ] 0]
  set R(5) [lindex [$o5 get {x y z} ] 0]


# JF - run el carboplanes per pintar els eixos, potser no cal?

  puts "estableciendo centro geométrico"
# Establecer el centro geométrico como 0

  set Rc [measure center $ring]
  set gc $Rc

#Establece un nuevo centro geométrico
  set ngc [vecscale -1 $gc]
    
  puts "moviendo moléculas al centro geométrico"
#Mueve las moléculas al centro geométrico CAL RESPECTAR, MOURE EL ANELL AL ORIGEN GEOMETIRC 
  set MOLSLIST [molinfo list]
  foreach molid $MOLSLIST {
        #puts [molinfo $molid get name]
	#puts $molid
    [atomselect $molid "all"] move [trans offset "$ngc"]
	#puts $molid
  }
      
#JF - canviar els alineaments pels eixos del carboplanes

puts "calculando ejes segun carbo planes 1"

  set R(0) [lindex [$c1 get {x y z} ] 0]
  set R(1) [lindex [$c2 get {x y z} ] 0]
  set R(2) [lindex [$c3 get {x y z} ] 0]
  set R(3) [lindex [$c4 get {x y z} ] 0]
  set R(4) [lindex [$c5 get {x y z} ] 0]
  set R(5) [lindex [$o5 get {x y z} ] 0]

foreach key [array names R] {
    set R0($key) [vecsub $R($key) $Rc]  
  }

  set PI [expr "4*atan(1)"]

  for {set i 0} {$i < 6} {incr i} {
    set S1($i) [vecscale $R0($i) [expr "sin(2*$PI*($i)/6)"] ]  
    set S2($i) [vecscale $R0($i) [expr "cos(2*$PI*($i)/6)"] ]  
  }
  set YY "0 0 0"
  set XX "0 0 0"
  foreach key [array names S1] {
    set XX [vecadd $XX $S1($key)]
    set YY [vecadd $YY $S2($key)]
  }

  set ZZ [veccross $XX $YY]

  puts "alineando eje Z"
#Alinea el eje y
  alinear_vectores $ZZ z

  puts "calculando ejes segun carbo planes 2"

  set R(0) [lindex [$c1 get {x y z} ] 0]
  set R(1) [lindex [$c2 get {x y z} ] 0]
  set R(2) [lindex [$c3 get {x y z} ] 0]
  set R(3) [lindex [$c4 get {x y z} ] 0]
  set R(4) [lindex [$c5 get {x y z} ] 0]
  set R(5) [lindex [$o5 get {x y z} ] 0]

  foreach key [array names R] {
    set R0($key) [vecsub $R($key) $Rc]  
  }


  set PI [expr "4*atan(1)"]

  for {set i 0} {$i < 6} {incr i} {
    set S1($i) [vecscale $R0($i) [expr "sin(2*$PI*($i)/6)"] ]  
    set S2($i) [vecscale $R0($i) [expr "cos(2*$PI*($i)/6)"] ]  
  }
  set YY "0 0 0"
  set XX "0 0 0"
  foreach key [array names S1] {
    set XX [vecadd $XX $S1($key)]
    set YY [vecadd $YY $S2($key)]
  }

  set ZZ [veccross $XX $YY]

  set vector2 [vecnorm $XX]

  set vector_proyection "[lindex $vector2 0] [lindex $vector2 1] 0"
#print ejes

  set R(0) [lindex [$c1 get {x y z} ] 0]
  set R(1) [lindex [$c2 get {x y z} ] 0]
  set R(2) [lindex [$c3 get {x y z} ] 0]
  set R(3) [lindex [$c4 get {x y z} ] 0]
  set R(4) [lindex [$c5 get {x y z} ] 0]
  set R(5) [lindex [$o5 get {x y z} ] 0]

  alinear_vectores $vector_proyection x
 foreach key [array names R] {
    set R0($key) [vecsub $R($key) $Rc]  
  }


  set PI [expr "4*atan(1)"]

  for {set i 0} {$i < 6} {incr i} {
    set S1($i) [vecscale $R0($i) [expr "sin(2*$PI*($i)/6)"] ]  
    set S2($i) [vecscale $R0($i) [expr "cos(2*$PI*($i)/6)"] ]  
  }
  set YY "0 0 0"
  set XX "0 0 0"
  foreach key [array names S1] {
    set XX [vecadd $XX $S1($key)]
    set YY [vecadd $YY $S2($key)]
  }

  set ZZ [veccross $XX $YY]

  set vector2 [vecnorm $XX]
  
  #puts "X: $XX"
  #puts "Y: $YY"
  #puts "Z: $ZZ"
  puts "origen establecido"

}
