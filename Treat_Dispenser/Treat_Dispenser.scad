cup_hgt         =  50.0;      // Height of outer cup
cup_thick       =   2.0;      // Thickness of wall and bottom of outer cup
wheel_dia       = 120.0;      // Diameter of inner wheel
wheel_hgt       =   8.0;      // Height (thickness) of inner wheel
treat_dia       =  18.0;      // Diameter of hole for treats
treat_hgt       = wheel_hgt;  // Height of hole for treats
treat_offset    =  45.0;      // Distance from wheel center to treat hole center
treat_holes     =   6;        // Number of holes for treats
stem_dia        =  10.0;      // Diameter of stem for grub screw
stem_hgt        =   7.0;      // Height of stem for grub screw
grub_dia        =   3.0;      // Diameter of hole for M3 grub screw
shaft_dia       =   4.8;      // Diameter of hole for motor shaft
shaft_base_dia  =  22.5;      // Diameter of ring around motor shaft
shaft_base_hgt  =   2.0;      // Height of ring around motor shaft
shaft_screw_rad =  21.92;     // Radius of motor screw holes from shaft center ((√(a² + b²)) / 2)
shaft_screw_dia =   3.0;      // M3 mounting screw
sides           = 360.00;     // Number of sides when rendering holes

module treat_wheel () {
  color ("dodgerblue")
    difference () {
      union () {
        difference () {
          cylinder (d = wheel_dia, h = wheel_hgt, $fn = sides);
      
          for (i = [0:(360 / treat_holes):359]) {
            x = sin (i) * treat_offset;
            y = cos (i) * treat_offset;
            
            translate ([x, y, -0.01])
              cylinder (d = treat_dia, h = treat_hgt + 0.02, $fn = sides);
          }
        }
        
        translate ([0, 0, wheel_hgt])
          cylinder (d = stem_dia, h = stem_hgt, $fn = sides);
      }
    
      translate ([0, 0, -0.01])
        cylinder (d = shaft_dia, h = wheel_hgt + treat_hgt + 0.02, $fn = sides);
      
      translate ([0, 0, (wheel_hgt + stem_hgt) - (2+ (grub_dia / 2))])
        rotate ([90, 0, 0])
          cylinder (d = grub_dia, h = stem_dia / 2, $fn = sides);
      
      translate ([0, 0, -0.01]) {
        difference () {
          cylinder (r = shaft_screw_rad + 2.5, h = 2, $fn = sides);
          cylinder (r = shaft_screw_rad - 2.5, h = 2, $fn = sides);
        }
      }
    }
}

module treat_cup () {
  color ("greenyellow", 0.5)
    difference () {
      cylinder (d = wheel_dia + (cup_thick * 3), h = cup_hgt, $fn = sides);
      
      translate ([0, 0, cup_thick])
        cylinder (d = wheel_dia + (cup_thick * 2), h = (cup_hgt - cup_thick) + 0.01, $fn = sides);
      translate ([sin (45) * treat_offset, cos (45) * treat_offset, -0.01])
        cylinder (d = treat_dia + 5.0, h = cup_thick + 0.02, $fn = sides);
      translate ([0, 0, -0.01])
        cylinder (d = shaft_base_dia, h = shaft_base_hgt + 0.02, $fn = sides);
      for (i = [0:(360 / 4):359]) {
        x = sin (i) * shaft_screw_rad;
        y = cos (i) * shaft_screw_rad;
        
        translate ([x, y, -0.01])
          cylinder (d = shaft_screw_dia, h = treat_hgt + 0.02, $fn = sides);
      }
    }
  
  if (0) {
    color ("red", 0.2)
      rotate ([0, 0, 45])
        translate ([-21, -21, -2.01])
          cube ([42, 42, 2]);
  }
}

if (1)
  translate ([0, 0, cup_thick + 0.1])
    treat_wheel ();

if (0)
  treat_cup ();

