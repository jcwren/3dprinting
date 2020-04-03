include <Configuration.scad>;
use <Auger.scad>;
use <motor_hub.scad>;
include <pvc_s40.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

//
//  Limit the value of $fn in preview mode
//
sides = $preview ? 100 : 360;

//
//  Standard NEMA-17 stepper motor. The body width and breadth
//  is fixed, but the length can vary.
//
module Nema17 (motor_height = 40) {
  translate ([0, 0, -motor_height]) {
    difference () {
      union (){
        translate ([0, 0, motor_height / 2]) {
          intersection () {
            cube ([42.3, 42.3, motor_height], center = true);
            rotate ([0, 0, 45])
              translate ([0, 0, -1])
                cube ([74.3 * sin (45), 73.3 * sin (45), motor_height + 2], center = true);
          }
        }
        translate ([0, 0, motor_height])
          cylinder (h = 2, r = 11, $fn = 24);
        translate ([0, 0, motor_height  +2])
          cylinder(h = 20, r = 2.5, $fn = 24);
      }

      for (i = [0 : 3]) {
        rotate ([0, 0, 90  *i])
          translate ([15.5, 15.5, motor_height  -4.5])
            cylinder (h = 5, r = 1.5, $fn = 24);
      }
    }
  }
}

//
//  Creates an auger, and adds the motor shaft hub
//
module auger_with_hub (auger_len = 120) {
  Auger_twist                 = 360 * 5;    // The total amount of twist, in degrees
  Auger_diameter              = 40.0;       // The final diameter of the auger
  Auger_num_flights           = 1;          // The number of "flights" [1:5]
  Auger_flight_length         = auger_len;  // The height, from top to bottom of the "shaft" [10:200]
  Auger_shaft_radius          = 5;          // The radius of the auger's "shaft" [1:25]
  Auger_flight_thickness      = 1;          // The thickness of the "flight" (in the direction of height) [0.2:Thin, 1:Medium, 10:Thick]
  Auger_handedness            = "right";    // The twist direction ["right":Right, "left":Left]
  Auger_perimeter_thickness   = 0.0;        // The thickness of perimeter support material [0:None, 0.8:Thin, 2:Thick]
  Printer_overhang_capability = 20;         // The overhang angle your printer is capable of [0:40]
  Motor_shaft_len             = 20.0;       // The length of the shaft on the motor

  //
  //  Calculate variables
  //
  Auger_flight_radius = (Auger_diameter / 2) - Auger_shaft_radius;

  //
  //  Constants
  //
  sides = $preview ? 100 : 360;
  M_PI  = 3.14159;
  mm    = 1;
  inch  = 25.4 * mm;

  difference () {
    auger (
                    r1 = Auger_shaft_radius,
                    r2 = Auger_shaft_radius + Auger_flight_radius,
                     h = Auger_flight_length,
         overhangAngle = Printer_overhang_capability,
            multiStart = Auger_num_flights,
       flightThickness = Auger_flight_thickness,
                 turns = Auger_twist / 360,
                 pitch = 0,
      supportThickness = Auger_perimeter_thickness,
            handedness = Auger_handedness,
                   $fn = sides,
                   $fa = 12,
                   $fs = 5
    );

    //
    //  Remove material where motor shaft will be placed later
    //
    translate ([0, 0, -0.01])
      cylinder (h = Motor_shaft_len + 0.01, r = Auger_shaft_radius , $fn = sides);
  }

  //
  //  Place motor hub
  //
  translate ([0, 0, Motor_shaft_len])
    rotate ([180, 0, 135])
      motor_hub (Auger_shaft_radius * 2, Motor_shaft_len);
}

//
//  More of a tee pipe, but we use it as a hopper. Defaults are for the main
//  part of the body to be PVC schedule 40 1-1/2" and the tee to be 1-1/4".
//
module hopper (od = 48.26, id = 40.38, len = 100, tee_od = 42.16, tee_id = 34.54, tee_offset = 40.00, tee_height = 60.00) {
  difference () {
    union () {
      cylinder (d = od, h = len, $fn = sides);
      rotate ([0, 90, 0])
        translate ([-tee_offset, 0, 0])
          cylinder (d = tee_od, h = tee_height + render_fix, $fn = sides);
    }
    union () {
      cylinder (d = id, h = len + render_fix, $fn = sides);
      rotate ([0, 90, 0])
        translate ([-tee_offset, 0, 0])
          cylinder (d = tee_id, h = tee_height + (render_fix * 2), $fn = sides);
    }
  }
}

//
//  Creates a chute that attaches to the end of the hopper. Default
//  is for it to fit over a section of PVC schedule 40 1-1/2" pipe.
//
module chute (od = 56.13, id = 48.26, chute_ring = 25.00) {
  wall = 2.00;
  pipe_rad = od / 2;

  difference () {
    union () {
      cylinder (d = od, h = chute_ring, $fn = sides);

      translate ([-od / 2, -od / 2, chute_ring - wall])
        cube ([od, od / 2, wall]);
    }

    translate ([0, 0, -render_fix])
      cylinder (d = id, h = chute_ring + wall + (render_fix * 2), $fn = sides);
  }

  chute_len   = 60.0;  // Length of chute, in mm (actual length, not Z)
  chute_drop  = 40.0;  // How far end of chute is below center of ring
  chute_width = 25.0;  // Width of chute exit point
  chute_lip   = 12.0;  // Height of lip at chute exit point
  chute_wall  =  2.0;  // Thickness of chute wall

  chute_exit = chute_width / 2;

  points = [
    [pipe_rad - 0,                                    0, chute_ring],
    [pipe_rad - chute_wall,                           0, chute_ring],
    [pipe_rad - 0,               -pipe_rad + chute_wall, chute_ring],
    [pipe_rad - chute_wall,      -pipe_rad + chute_wall, chute_ring],
    [chute_exit,              -(chute_drop - chute_lip),  chute_len],
    [chute_exit - chute_wall, -(chute_drop - chute_lip),  chute_len],
    [chute_exit,                            -chute_drop,  chute_len],
    [chute_exit - chute_wall,               -chute_drop,  chute_len],
  ];

  for (i = [-1 : 2 : 1]) {
    hull () {
      for (j = [0 : len (points) - 1]) {
        translate ([points [j].x * i, points [j].y, points [j].z])
          sphere (d = .001);
      }
    }
  }

  polypoints = [
    [ pipe_rad,     -(pipe_rad - chute_wall), chute_ring],
    [ chute_exit,          -(chute_drop + 0),  chute_len],
    [-chute_exit,          -(chute_drop + 0),  chute_len],
    [-pipe_rad,     -(pipe_rad - chute_wall), chute_ring],
    [ pipe_rad,              -(pipe_rad - 0), chute_ring],
    [ chute_exit, -(chute_drop + chute_wall),  chute_len],
    [-chute_exit, -(chute_drop + chute_wall),  chute_len],
    [-pipe_rad,              -(pipe_rad - 0), chute_ring],
  ];

  polyfaces = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3],  // left
  ];

  polyhedron (points = polypoints, faces = polyfaces, convexity = 10);
}

//
//  Mounting plate for NEMA-17 stepper motor and a ring to
//  accomodate mounting a pipe. The defaults are for PVC
//  schedule 40 1-1/2".
//
module motor_mount (plate_xy = 60.00, plate_thickness = 2.0, plate_radius = 2.00, pipe_dia = 48.26, pipe_hgt = 12.70, pipe_wall = 2.00) {
  difference () {
    union () {
      linear_extrude (plate_thickness) {
        hull () {
          plate_xy2 = plate_xy / 2;

          translate ([-(plate_xy2 - plate_radius), -(plate_xy2 - plate_radius), 0])
            circle (r = plate_radius, $fn = sides);
          translate ([-(plate_xy2 - plate_radius), plate_xy2 - plate_radius, 0])
            circle (r = plate_radius, $fn = sides);
          translate ([plate_xy2 - plate_radius, -(plate_xy2 - plate_radius), 0])
            circle (r = plate_radius, $fn = sides);
          translate ([plate_xy2 - plate_radius, plate_xy2 - plate_radius, 0])
            circle (r = plate_radius, $fn = sides);
        }
      }

      translate ([0, 0, plate_thickness - render_fix]) {
        difference () {
          cylinder (d = pipe_dia + (pipe_wall * 2), h = pipe_hgt, $fn = sides);
          cylinder (d = pipe_dia, h = pipe_hgt + render_fix, $fn = sides);
        }
      }
    }

    //
    //  Shaft hole
    //
    translate ([0, 0, -render_fix])
      cylinder (d = shaft_base_dia, h = shaft_base_hgt + (render_fix * 2), $fn = sides);

    //
    //  Screw holes for motor
    //
    for (i = [45:90:359]) {
      x = sin (i) * shaft_screw_rad;
      y = cos (i) * shaft_screw_rad;

      translate ([x, y, -render_fix])
        cylinder (d = shaft_screw_dia, h = plate_thickness + (render_fix * 2), $fn = sides);
    }

    //
    //  Screw holes for mounting plate
    //
    mtg_screw_offset = 35.0; // Distance from center to mounting hole (FIXME!)

    for (i = [45:90:359]) {
      x = sin (i) * mtg_screw_offset;
      y = cos (i) * mtg_screw_offset;

      translate ([x, y, -render_fix])
        cylinder (d = shaft_screw_dia, h = plate_thickness + (render_fix * 2), $fn = sides);
    }

    //
    //  Screw holes for pipe
    //
    for (i = [0:90:359]) {
      render_fix = 0.1;
      x = sin (i) * (((pipe_dia + pipe_wall) / 2) - render_fix);
      y = cos (i) * (((pipe_dia + pipe_wall) / 2) - render_fix);

      translate ([x, y, plate_thickness + (pipe_hgt / 2)])
        rotate ([sin (i) * 90, cos (i) * 90, 90])
          cylinder (d = shaft_screw_dia, h = pipe_wall + (render_fix * 2), $fn = sides, center = true);
    }
  }
}

//
//  Lay some pipe :)
//
//  Reminder:
//    % - Render the part in gray and no STL output
//    * - Disable the part
//    # - Highlight the part in light red
//
auger_len             =  120.0; // Length of auger
chute_ring_len        =   25.0; // Length of chute mounting ring
motor_height          =   40.0; // Height of motor
motor_plate_thickness =    2.0; // Thickless for mounting plate

%Nema17 (motor_height);

translate ([0, 0, motor_plate_thickness]) {
  %auger_with_hub (auger_len = auger_len);
  %hopper (len = auger_len);

  translate ([0, 0, auger_len - chute_ring_len])
    rotate ([0, 0, 270])
      %chute (id = 48.26 + 0.25);
}

%motor_mount (pipe_dia = 48.26 + 0.25);
