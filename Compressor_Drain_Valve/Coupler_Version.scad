include <gears.scad>
use <motor_hub.scad>;

// 4mm shaft: d = 4, offset = 1.6
// 5mm shaft: d = 5, offset = 2
// 6mm shaft: d = 6, offset = 2.5

shaft_diameter        =  5.3;       // Diameter of the stepper shaft
shaft_d_offset        =  2;         // Offset from the center of the shaft to the plane of the Dshaft_base_dia        =  22.5;      // Diameter of ring around motor shaft
shaft_base_dia        =  22.5;      // Diameter of ring around motor shaft
shaft_base_hgt        =   2.0;      // Height of ring around motor shaft
shaft_screw_rad       =  21.92;     // Radius of motor screw holes from shaft center ((√(a² + b²)) / 2)
shaft_screw_dia       =   3.2;      // Diameter of threads for M3 mounting screw (with 0.2 fudge factor)
shaft_screw_head_dia  =   6.2;      // Diameter of head for M3 mounting screw (with 0.2 fudge factor)

motor_shaft_hgt       =  22.5;      // Total height of motor shaft stem
motor_shaft_len       =  20.0;      // Length of shaft on motor (from datasheet)
motor_length          =  30.0;      // Length of motor body
motor_body_xy         =  42.3;      // Size of NEMA 17 motor body

coupler_diameter      =  40.0;      // Overall diameter of coupler
coupler_width         =  18.0;      // Total width of coupler
coupler_clearance     =   1.0;      // Clearance between valve block and coupler

valve_handle_depth    =   8.0;      // Depth of handle cutout
  
grub_dia              =   3.0;      // Diameter of hole for M3 grub screw

$fn = 128;

coupler_shaft_depth = coupler_width - valve_handle_depth;

//
//  Standard NEMA-17 stepper motor. The body width and breadth
//  is fixed, but the length can vary.
//
module Nema17 (motor_height = motor_length) {
  translate ([0, 0, -motor_height]) {
    difference () {
      union () {
        translate ([0, 0, motor_height / 2]) {
          intersection () {
            cube ([42.3, 42.3, motor_height], center = true);
            rotate ([0, 0, 45])
              translate ([0, 0, -1])
                cube ([74.3 * sin (45), 73.3 * sin (45), motor_height + 2], center = true);
          }
        }
        //
        //  Raised area around shaft and motor shaft
        //
        translate ([0, 0, motor_height])
          cylinder (h = 2, r = 11);
        translate ([0, 0, motor_height  + 2])
          cylinder (h = motor_shaft_len, r = 2.5);
      }

      //
      //  Mounting screws (M3 5mm deep)
      //
      for (i = [0 : 3]) {
        rotate ([0, 0, 90 * i])
          translate ([15.5, 15.5, motor_height - 4.5])
            cylinder (h = 5, r = 1.5);
      }
    }
  }
}

//
//  Mounting plate for NEMA-17 stepper motor 
//
module motor_mount (plate_xy = 42.30, plate_thickness = 2.0, plate_radius = 2.00) {
  difference () {
    union () {
      linear_extrude (plate_thickness) {
        hull () {
          plate_xy2 = plate_xy / 2;

          translate ([-(plate_xy2 - plate_radius), -(plate_xy2 - plate_radius), 0])
            circle (r = plate_radius);
          translate ([-(plate_xy2 - 0.1), plate_xy2 - 0.1, 0])
            circle (r = 0.1);
          translate ([plate_xy2 - plate_radius, -(plate_xy2 - plate_radius), 0])
            circle (r = plate_radius);
          translate ([plate_xy2 - 0.1, plate_xy2 - 0.1, 0])
            circle (r = 0.1);
        }
      }
    }

    //
    //  Shaft hole
    //
    translate ([0, 0, -0.01])
      cylinder (d = shaft_base_dia, h = shaft_base_hgt + (0.01 * 2));

    //
    //  Screw holes for motor. Commented out line is to allow a recess in the
    //  mounting plate for socket head screws if the mounting plate is thick.
    //
    for (i = [45:90:359]) {
      x = sin (i) * shaft_screw_rad;
      y = cos (i) * shaft_screw_rad;

      translate ([x, y, -0.01])
        cylinder (d = shaft_screw_dia, h = plate_thickness + (0.01 * 2));
      *translate ([x, y, plate_thickness + 0.01])
        cylinder (d = shaft_screw_head_dia, h = 7 + 0.01);
    }
  }
}

//
//  Coupler functions
//
module d_shaft (dia = 0, hgt = 0) {
  if (hgt) 
    linear_extrude (height = hgt + 0.01)
      difference () {
        circle (d = shaft_diameter);
        translate ([0, shaft_d_offset + shaft_diameter / 2, 0])
          square (size = shaft_diameter, center = true);
      }
}

module handle_cutout () {
  translate ([0, 0, -0.01]) {
    cylinder (d = 18.5, h = 6);
    for (i = [-1, 1])
      linear_extrude (height = valve_handle_depth)
        hull () {
          translate ([0, 0, 0])
            circle (d = 4.8);
          translate ([(18 - 2.4) * i, 0, 0])
            circle (d = 4.8);
        }
      }
}

module coupler () {  
  rotate ([0, 180, 0])
    translate ([0, 0, -coupler_width])
      difference () {
        cylinder (d = coupler_diameter, h = coupler_width);
        d_shaft (dia = coupler_diameter, hgt = coupler_width + 0.01);
        handle_cutout ();
        translate ([0, 0, coupler_width - (grub_dia + (grub_dia / 2))])
          rotate ([90, 0, 180])
            cylinder (d = grub_dia, h = (coupler_diameter / 2) + 0.01);
      }
}

//
//  Base plate with valve body and motor mount
//
module valve_holder (show_coupler = 0) {
  valve_dia_1    = 16.6; // Diameter without 2 small ribs on either side
  valve_dia_2    = 17.3; // Diameter of 2 small ribs on either side
  valve_width    = 37;   // Width between the two metal hose retainers
  valve_depth    = 24;   // Distance from just behind handle to back of valve
  valve_backset  =  5.5; // Setback from edge of block
  block_depth    = 35;   // Depth of block (most be >= valve_depth)
  baseplate_hgt  =  4;   // Thickness of base plate

  block_hgt      = motor_body_xy / 2;   // Total height of block
  motor_y_pos    = coupler_clearance + valve_handle_depth + motor_shaft_hgt;
  
  //
  //  Base plate 
  //
  translate ([-((motor_body_xy - valve_width) / 2), -(coupler_clearance + valve_handle_depth + motor_shaft_hgt + motor_length), 0])
    cube ([motor_body_xy, block_depth + coupler_clearance + valve_handle_depth + motor_shaft_hgt + motor_length, baseplate_hgt]);
    
  translate ([0, 0, baseplate_hgt]) {
    difference () {
      cube ([valve_width, block_depth, block_hgt]);
      translate ([-0.01, valve_backset + (valve_dia_2 / 2), block_hgt])
        rotate ([0, 90, 0])
          cylinder (d = valve_dia_2, h = valve_width + 0.02);
      translate ([valve_width / 2, -0.01, block_hgt])
        rotate ([270, 00, 0])
          cylinder (d = valve_dia_1, h = valve_depth + 0.02);
    }
    
    translate ([valve_width / 2, -motor_y_pos, block_hgt])
      rotate ([270, 0, 0]) 
        motor_mount (); 
          
    if (show_coupler) {
      color (0, 0.5) {
        translate ([valve_width / 2, -(coupler_width + 1), block_hgt])
          rotate ([270, 0, 0])
            coupler ();
            
        translate ([valve_width / 2, -motor_y_pos, block_hgt])
          rotate ([270, 0, 0])
            Nema17 ();
      }
    } 
  }
}

*coupler ();
valve_holder (1);
