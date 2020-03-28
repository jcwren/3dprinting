cup_hgt         =  50.0;      // Height of outer cup
cup_thick       =   2.0;      // Thickness of wall and bottom of outer cup
wheel_dia       = 120.0;      // Diameter of inner wheel
wheel_hgt       =   6.0;      // Height (thickness) of inner wheel
treat_dia       =  18.0;      // Diameter of hole for treats
treat_hgt       = wheel_hgt;  // Height of hole for treats
treat_offset    =  50.0;      // Distance from wheel center to treat hole center
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

use <motor_hub.scad>;

module treat_wheel () {
  color ("dodgerblue") {
    difference () {
      union () {
        difference () {
          cylinder (d = wheel_dia, h = wheel_hgt, $fn = sides);
      
          for (i = [0:(360 / treat_holes):359]) {
            x1 = sin (i) * treat_offset;
            y1 = cos (i) * treat_offset;
            x2 = sin (i) * (treat_offset + 20);
            y2 = cos (i) * (treat_offset + 20);
          
            hull () {
              translate ([x1, y1, -0.01])
                cylinder (d = treat_dia, h = treat_hgt + 0.02, $fn = sides);
              translate ([x2, y2, -0.01])
                cylinder (d = treat_dia, h = treat_hgt + 0.02, $fn = sides);
            }
          }
        }
      }
      translate ([0, 0, -0.01])
        cylinder (d = 10, h = 20.02, $fn = sides);
    }
    
    motor_hub (10, 20);
  }
}

module treat_wheel_one () {
  color ("dodgerblue") {
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
      }
      translate ([0, 0, -0.01])
        cylinder (d = 10, h = 20.02, $fn = sides);
    }
    motor_hub (10, 20);
  }
}

module treat_cup () {
  color ("greenyellow", 0.5) {
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
  }
}

module scraper () {
  color ("magenta") {
    cup_inner_dia = wheel_dia + (cup_thick * 2);
    cup_outer_dia = wheel_dia + (cup_thick * 3);
    scraper_inner_dia = cup_inner_dia - (cup_thick * 2);
    scraper_outer_dia = cup_outer_dia + cup_thick;
    scraper_hgt = 39;
    outer_overhang_hgt = 8;
    
    translate ([0, 0, cup_hgt + 2]) {
      rotate ([180, 0, 0]) {

        difference () {
          cylinder (d = scraper_outer_dia, h = scraper_hgt, $fn = sides);
          union () {
            translate ([0, 0, -0.01]) {
              cylinder (d = scraper_inner_dia, h = scraper_hgt + 0.02, $fn = sides);
              translate ([0, 0, 2]) { // Edge ring
                difference () {
                  cylinder (d = cup_outer_dia + 0.01, h = scraper_hgt, $fn = sides);
                  cylinder (d = cup_inner_dia, h = scraper_hgt, $fn = sides);
                }
              } // Edge ring
              translate ([0, 0, outer_overhang_hgt]) { // Shorten outer edge
                difference () {
                  cylinder (d = scraper_outer_dia + 0.01, h = scraper_hgt, $fn = sides);
                  cylinder (d = cup_outer_dia, h = scraper_hgt, $fn = sides);
                }
              } // Shorten outer edge
            }
          }
        }
           
        difference () {
          angle = 45 + 90; // +90 because we're rotated 180 degrees
          scraper_rad = scraper_inner_dia / 2;
          x1_pos = sin (angle) * (scraper_rad - 20);
          y1_pos = cos (angle) * (scraper_rad - 20);
          
          hull () {
            translate ([x1_pos, y1_pos, 0]) 
              cylinder (d = treat_dia * 2, h = scraper_hgt, $fn = sides);
            for (i = [-16:4:16]) {
              translate ([sin (angle + i) * scraper_rad, cos (angle + i) * scraper_rad, 0])
                cylinder (d = 4.0, h = scraper_hgt, $fn = 64);
            }
          }
          hull () {
            translate ([x1_pos, y1_pos, -0.01]) 
              cylinder (d = (treat_dia * 2) - 4, h = scraper_hgt + 0.02, $fn = sides);
            for (i = [-16:4:16]) {
              translate ([sin (angle + i) * scraper_rad, cos (angle + i) * scraper_rad, 0])
                cylinder (d = 0.01, h = scraper_hgt, $fn = 64);
            }
          }
        }
      }
    }
  }
}

*translate ([0, 0, cup_thick + 0.1])
  treat_wheel ();

treat_cup ();

*difference () {
  scraper ();
  translate ([-80, -80, -0.01]) {
    cube ([160, 80, 60]); 
    cube ([80, 160, 60]);
  }
}