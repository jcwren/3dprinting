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
shaft_screw_dia =   3.2;      // M3 mounting screw
motor_shaft_dia =  10.0;      // Outside diameter of motor shaft stem
motor_shaft_hgt =  22.5;      // Total height of motor shaft stem
motor_shaft_len =  20.0;      // Length of shaft on motor (from datasheet)

wheel_rad            = wheel_dia / 2;
wheel_z_bot          = motor_shaft_len - (motor_shaft_hgt - ((grub_dia / 2) + 4)); 
wheel_z_top          = wheel_z_bot + wheel_hgt;
cup_inner_dia        = wheel_dia + cup_wall;
cup_outer_dia        = cup_inner_dia + (cup_wall * 1); 
cup_inner_rad        = cup_inner_dia / 2;
cup_outer_rad        = cup_outer_dia / 2;
scraper_inner_dia    = cup_inner_dia - (cup_wall * 2);
scraper_outer_dia    = cup_outer_dia + cup_wall;
scraper_inner_rad    = scraper_inner_dia / 2;
scraper_outer_rad    = scraper_outer_dia / 2;
scraper_hgt          = (cup_hgt - wheel_z_top) + 1;
scraper_overhang_hgt = 8;
render_fix           = $preview ? 0.01 : 0.00;
sides                = $preview ? 100 : 360;

include <BOSL/constants.scad>
use <BOSL/beziers.scad>
use <BOSL/paths.scad>
include <arc.scad>
include <Wheel.scad>;
include <Cup.scad>;
//include <Scraper.scad>;

module scraper () {
  color ("magenta") {
    angles = [0, 90];
    
    difference () {
      union () {
        translate ([0, 0, wheel_z_top + 1]) 
          linear_extrude (cup_hgt - (wheel_z_top + 1))
            arc (scraper_inner_rad, angles, cup_wall, sides);  
        translate ([0, 0, cup_hgt - scraper_overhang_hgt])
          linear_extrude (scraper_overhang_hgt)
            arc (cup_outer_rad, angles, cup_wall, sides);
        translate ([0, 0, cup_hgt])
          linear_extrude (cup_wall)
            arc (scraper_inner_rad, angles, cup_wall * 3, sides);
    
        fa = angles [0];
        la = angles [1];
        ma = ((la - fa) / 2) + fa;
                        
        a = [[ la -  2, scraper_inner_rad - 1],
             [ la - 28, scraper_inner_rad - 2],
             [ la - 16, scraper_inner_rad - 32],
             [ ma +  0, scraper_inner_rad - (treat_dia * 1.8) - 2.4],
             [ fa + 16, scraper_inner_rad - 32],
             [ fa + 28, scraper_inner_rad - 2],
             [ fa +  2, scraper_inner_rad - 1]];
             
        b = [[ fa +  2, scraper_inner_rad + 1],
             [ fa + 30, scraper_inner_rad],
             [ fa + 20, scraper_inner_rad - 30],
             [ ma +  0, scraper_inner_rad - (treat_dia * 1.8)],
             [ la - 20, scraper_inner_rad - 30],
             [ la - 30, scraper_inner_rad],
             [ la -  2, scraper_inner_rad + 1]];

        bez1 = [
          for (i = [0 : len (a) - 1]) 
            [sin (a [i][0]) * a [i][1], 
             cos (a [i][0]) * a [i][1]]
        ];
        bez2 = [
          for (i = [0 : len (b) - 1]) 
            [sin (b [i][0]) * b [i][1], 
             cos (b [i][0]) * b [i][1]]
        ];
          
        nbez1 = bezier_polyline (bez1, splinesteps = 64, N = 3);
        nbez2 = bezier_polyline (bez2, splinesteps = 64, N = 3);
        nbez3 = concat (nbez1, nbez2);
        
        translate ([0, 0, wheel_z_top + 1])
          linear_extrude_bezier (nbez3, (cup_hgt + cup_wall) - (wheel_z_top + 1));
      }

      //
      //  44 degree chamfer on leading edge of scraper (45 leaves a hair thin line)
      //
      cube_x = cup_wall * 1.4;
      cube_y = cup_wall * 3;
      cube_center = sqrt ((cube_x * cube_x) + (cube_x * cube_x)) / 2;
      
      translate ([cup_inner_rad - cup_wall, -cube_center, (wheel_z_top + 1) - render_fix])
        rotate ([0, 0, 44])
          cube ([cube_x, cube_y, ((cup_hgt + cup_wall) - (wheel_z_top + 1)) + (render_fix * 2)]);
    }
  }    
}

*translate ([0, 0, wheel_z_bot])
  wheel ();

scraper ();
cup ();