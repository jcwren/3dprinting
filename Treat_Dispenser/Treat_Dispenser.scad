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
render_fix          = $preview ? 0.01 : 0.00;

include <Wheel.scad>;
include <Cup.scad>;
include <Scraper.scad>;

translate ([0, 0, wheel_z_bot])
  wheel ();

difference () {
  scraper ();
  translate ([-80, -80, -render_fix]) {
    cube ([160, 80, 60]); 
    cube ([80, 160, 60]);
  }
}

cup ();