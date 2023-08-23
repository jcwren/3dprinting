include <gears.scad>
use <motor_hub.scad>;

outer_diameter   = 10;   // Outer diameter of the adapter
stepper_length   = 15;   // Length of the stepper shaft
stepper_diameter =  5.3; // Diameter of the stepper shaft
stepper_d_offset =  2;   // Offset from the center of the shaft to the plane of the D

// 4mm shaft: d = 4, offset = 1.6
// 5mm shaft: d = 5, offset = 2
// 6mm shaft: d = 6, offset = 2.5

shaft_base_dia        =  22.5;      // Diameter of ring around motor shaft
shaft_base_hgt        =   2.0;      // Height of ring around motor shaft
shaft_screw_rad       =  21.92;     // Radius of motor screw holes from shaft center ((√(a² + b²)) / 2)
shaft_screw_dia       =   3.2;      // Diameter of threads for M3 mounting screw (with 0.2 fudge factor)
shaft_screw_head_dia  =   6.2;      // Diameter of head for M3 mounting screw (with 0.2 fudge factor)
motor_shaft_hgt       =  22.5;      // Total height of motor shaft stem
motor_shaft_len       =  20.0;      // Length of shaft on motor (from datasheet)
motor_length          =  30.0;      // Length of motor body
motor_body_xy         =  42.3;      // Size of NEMA 17 motor body

drive_gear_width      =   5.0;      // Width (thickness) of drive gear
valve_gear_width      =  10.0;      // Width (thickness) of valve gear
valve_gear_clearance  =   1.0;      // Clearance between motor mount and gear

$fn = 128;

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
//  Gear and adapter functions
//
module d_shaft (dia = 0, hgt = 0, grub_dia = 3) {
  if (hgt) {
    difference () {
    linear_extrude (height = hgt + 0.01)
      difference () {
        if (dia != 0)
          circle (d = dia);
        difference () {
          circle (d = stepper_diameter);
          translate ([0, stepper_d_offset + stepper_diameter / 2, 0])
            square (size = stepper_diameter, center = true);
        }
      }
      translate ([0, 0, hgt - (grub_dia + (grub_dia / 2))])
        rotate ([90, 0, 180])
          cylinder (d = grub_dia, h = (dia / 2) + 0.01);
    }
  }
}

module handle_cutout () {
  translate ([0, 0, -0.01]) {
    cylinder (d = 18.5, h = 6);
    for (i = [-1, 1])
      linear_extrude (height = 8)
        hull () {
          translate ([0, 0, 0])
            circle (d = 4.8);
          translate ([(18 - 2.4) * i, 0, 0])
            circle (d = 4.8);
        }
      }
}

module valve_gear (gear_width = valve_gear_width) {
  rotate ([0, 180, 0])
    translate ([0, 0, -10])
      difference () {
        spur_gear (modul=1, tooth_number=50, width=gear_width, bore=0, pressure_angle=20, helix_angle=20, optimized=false);
        handle_cutout ();
      }
}

module drive_gear (gear_width = drive_gear_width) {
  spur_gear (modul=1, tooth_number=25, width=gear_width, bore=outer_diameter, pressure_angle=20, helix_angle=-20, optimized=false);
  d_shaft (dia = outer_diameter, hgt = stepper_length);
}

module adapter () {
  rotate ([0, 180, 0])
    translate ([0, 0, -15])
      difference () {
        cylinder (d = 40, h = 15);
        d_shaft (dia = 0, hgt = 15.01);
        handle_cutout ();
      }
}

//
//  Function for printing valve and drive gear or adapter
//
module valve_gears (gear_drive = 1) {
  if (gear_drive) {
    translate ([0, 0, 0])
      valve_gear ();
    translate ([40, 0, 0])
      drive_gear ();
  } else
    translate ([0, 0, 0])
      adapter ();
}

//
//  Base plate with valve body and motor mount
//
module valve_holder (show_gears = 0) {
  valve_dia_1    = 16.5; // Diameter without 2 small ribs on either side
  valve_dia_2    = 17.2; // Diameter of 2 small ribs on either side
  valve_width    = 37;   // Width between the two metal hose retainers
  valve_depth    = 24;   // Distance from just behind handle to back of valve
  valve_backset  =  5.5; // Setback from edge of block
  block_depth    = 35;   // Deptch of block (most be >= valve_depth)
  block_hgt      = 28;   // Total height of block
  base_hgt       =  4;   // Thickness of base plate
  motor_x_offset = 18;   // Empirically determined :(

  difference () {
    cube ([valve_width, block_depth, block_hgt]);
    translate ([-0.01, valve_backset + (valve_dia_2 / 2), block_hgt])
      rotate ([0, 90, 0])
        cylinder (d = valve_dia_2, h = valve_width + 0.02);
    translate ([valve_width / 2, -0.01, block_hgt])
      rotate ([270, 00, 0])
        cylinder (d = valve_dia_1, h = valve_depth + 0.02);
  }

  motor_y_pos = valve_gear_clearance + ((valve_gear_width / 2) - (drive_gear_width / 2)) + motor_shaft_hgt;

  translate ([-motor_x_offset, -motor_y_pos, 25])
    rotate ([270, 0, 0])
      motor_mount ();

  if (show_gears) {
    color (0, 0.5) {
      translate ([-motor_x_offset, -motor_y_pos, 25])
        rotate ([270, 0, 0]) {
          Nema17 ();
          rotate ([0, 180, 12])
            translate ([0, 0, -motor_shaft_hgt])
              drive_gear ();
        }

      translate ([block_hgt - (valve_dia_2 / 2), -(valve_gear_width + valve_gear_clearance), block_hgt])
        rotate ([90, 0, 180])
          valve_gear ();
    }
  }

  //
  //  Base plate and cutout for valve gear clearance
  //
  difference () {
    translate ([-40, -(28 + motor_length), 0])
      cube ([40 + valve_width + 12, 28 + motor_length + block_depth, base_hgt]);
    translate ([0, -12, 1])
      cube ([valve_width, valve_gear_width + (valve_gear_clearance * 2), (base_hgt - 1) + 0.01]);
  }
}

*valve_gears ();
valve_holder ();
