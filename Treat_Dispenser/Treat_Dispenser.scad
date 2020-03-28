cup_hgt         =  50.0;      // Height of outer cup
cup_wall        =   2.0;      // Thickness of wall and bottom of outer cup
wheel_dia       = 120.0;      // Diameter of inner wheel
wheel_hgt       =   4.0;      // Height (thickness) of inner wheel
treat_dia       =  18.0;      // Diameter of hole for treats
treat_hgt       = wheel_hgt;  // Height of hole for treats
treat_offset    =  55.0;      // Distance from wheel center to treat hole center
treat_holes     =   6;        // Number of holes for treats
stem_dia        =  10.0;      // Diameter of stem for grub screw
stem_hgt        =   7.0;      // Height of stem for grub screw
grub_dia        =   3.0;      // Diameter of hole for M3 grub screw
shaft_dia       =   4.8;      // Diameter of hole for motor shaft
shaft_base_dia  =  22.5;      // Diameter of ring around motor shaft
shaft_base_hgt  =   2.0;      // Height of ring around motor shaft
shaft_screw_rad =  21.92;     // Radius of motor screw holes from shaft center ((√(a² + b²)) / 2)
shaft_screw_dia =   3.0;      // M3 mounting screw
motor_shaft_dia =  10.0;      // Outside diameter of motor shaft stem
motor_shaft_hgt =  22.5;      // Total height of motor shaft stem
motor_shaft_len =  20.0;      // Length of shaft on motor (from datasheet)
sides           = 360.00;     // Number of sides when rendering holes

wheel_rad           = wheel_dia / 2;
wheel_z_bot         = motor_shaft_len - (motor_shaft_hgt - ((grub_dia / 2) + 4)); 
wheel_z_top         = wheel_z_bot + wheel_hgt;
cup_inner_dia       = wheel_dia + cup_wall;
cup_outer_dia       = cup_inner_dia + cup_wall; 
cup_inner_rad       = cup_inner_dia / 2;
cup_outer_rad       = cup_outer_dia / 2;
scraper_inner_dia   = cup_inner_dia - (cup_wall * 2);
scraper_outer_dia   = cup_outer_dia + cup_wall;
scraper_inner_rad   = scraper_inner_dia / 2;
scraper_outer_rad   = scraper_outer_dia / 2;
scraper_hgt         = (cup_hgt - wheel_z_top) + 1;
outer_overhang_hgt  = 8;
render_fix          = 0.01;

use <motor_hub.scad>;

module treat_wheel_open () {
  color ("dodgerblue") {
    difference () {
      difference () {
        cylinder (d = wheel_dia, h = wheel_hgt, $fn = sides);
    
        for (i = [0:(360 / treat_holes):359]) {
          x1 = sin (i) * treat_offset;
          y1 = cos (i) * treat_offset;
          x2 = sin (i) * wheel_rad; 
          y2 = cos (i) * wheel_rad;
        
          hull () {
            translate ([x1, y1, -render_fix])
              cylinder (d = treat_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
            translate ([x2, y2, -render_fix])
              cylinder (d = treat_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
          }
        }
      }
      
      //
      //  Hole for motor shaft so it actually goes through wheel
      //
      translate ([0, 0, -render_fix])
        cylinder (d = motor_shaft_dia, h = motor_shaft_hgt + (render_fix * 2), $fn = sides);
    }
    
    motor_hub (motor_shaft_dia, motor_shaft_hgt);
  }
}

module treat_wheel_closed () {
  color ("dodgerblue") {
    difference () {
      union () {
        difference () {
          cylinder (d = wheel_dia, h = wheel_hgt, $fn = sides);
      
          for (i = [0:(360 / treat_holes):359]) {
            x = sin (i) * treat_offset;
            y = cos (i) * treat_offset;
            
            translate ([x, y, -render_fix])
              cylinder (d = treat_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
          }
        }
      }
      translate ([0, 0, -render_fix])
        cylinder (d = motor_shaft_dia, h = motor_shaft_hgt + (render_fix * 2), $fn = sides);
    }
    
    motor_hub (motor_shaft_dia, motor_shaft_hgt);
  }
}

module treat_cup () {
  color ("greenyellow", 0.5) {
    difference () {
      cylinder (d = cup_outer_dia, h = cup_hgt, $fn = sides);
      
      translate ([0, 0, cup_wall])
        cylinder (d = cup_inner_dia, h = (cup_hgt - cup_wall) + render_fix, $fn = sides);
      
      //
      //  Treat hole
      //
      difference () {
        angle = 45;
        x1_pos = sin (angle) * (cup_inner_rad - treat_dia);
        y1_pos = cos (angle) * (cup_inner_rad - treat_dia);
        
        hull () {
          translate ([x1_pos, y1_pos, -render_fix]) 
            cylinder (d = treat_dia + 5, h = cup_wall + (render_fix * 2), $fn = sides);
          for (i = [-10:2:10]) {
            a2 = angle + i;
            x2 = sin (a2) * cup_inner_rad;
            y2 = cos (a2) * cup_inner_rad;
            translate ([x2, y2, 0])
              cylinder (d = cup_wall, h = cup_wall + (render_fix * 2), $fn = 64);
          }
        }
      }
      
      //
      //  Shaft hole
      //
      translate ([0, 0, -render_fix])
        cylinder (d = shaft_base_dia, h = shaft_base_hgt + (render_fix * 2), $fn = sides);
      
      //
      //  Screw holes
      //
      for (i = [0:90:359]) {
        x = sin (i) * shaft_screw_rad;
        y = cos (i) * shaft_screw_rad;
        
        translate ([x, y, -render_fix])
          cylinder (d = shaft_screw_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
      }
    }
  }
}

module scraper () {
  color ("magenta") {
    translate ([0, 0, cup_hgt + 2]) {
      rotate ([180, 0, 0]) {

        //
        //  Support flange
        //
        difference () {
          cylinder (d = scraper_outer_dia, h = scraper_hgt, $fn = sides);
          union () {
            translate ([0, 0, -render_fix]) {
              cylinder (d = scraper_inner_dia, h = scraper_hgt + (render_fix * 2), $fn = sides);
              translate ([0, 0, 2]) { // Edge ring
                difference () {
                  cylinder (d = cup_outer_dia + render_fix, h = scraper_hgt, $fn = sides);
                  cylinder (d = cup_inner_dia - render_fix, h = scraper_hgt, $fn = sides);
                }
              } // Edge ring
              translate ([0, 0, outer_overhang_hgt]) { // Shorten outer edge
                difference () {
                  cylinder (d = scraper_outer_dia + render_fix, h = scraper_hgt, $fn = sides);
                  cylinder (d = cup_outer_dia - render_fix, h = scraper_hgt, $fn = sides);
                }
              } // Shorten outer edge
            }
          }
        }
        
        //
        //  Wiper loop
        //
        difference () {
          angle = 45 + 90; // +90 because we're rotated 180 degrees
          x1_pos = sin (angle) * (scraper_inner_rad - treat_dia);
          y1_pos = cos (angle) * (scraper_inner_rad - treat_dia);
          
          hull () {
            translate ([x1_pos, y1_pos, 0]) 
              cylinder (d = treat_dia * 2, h = scraper_hgt, $fn = sides);
            for (i = [-16:4:16]) {
              translate ([sin (angle + i) * scraper_inner_rad, cos (angle + i) * scraper_inner_rad, 0])
                cylinder (d = 4.0, h = scraper_hgt, $fn = 64);
            }
          }
          hull () {
            translate ([x1_pos, y1_pos, -render_fix]) 
              cylinder (d = (treat_dia * 2) - 4, h = scraper_hgt + (render_fix * 2), $fn = sides);
            for (i = [-16:4:16]) {
              translate ([sin (angle + i) * scraper_inner_rad, cos (angle + i) * scraper_inner_rad, 0])
                cylinder (d = 0.01, h = scraper_hgt, $fn = 64);
            }
          }
        }
      }
    }
  }
}

translate ([0, 0, wheel_z_bot])
  treat_wheel_open ();

difference () {
  scraper ();
  translate ([-80, -80, -render_fix]) {
    cube ([160, 80, 60]); 
    cube ([80, 160, 60]);
  }
}

treat_cup ();