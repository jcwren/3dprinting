include <Configuration.scad>;
use <Auger.scad>;
use <motor_hub.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

motor_housing     =  42.3;    // Size of motor housing
motor_height      =  40.0;    // Height of motor
plate_margin      =  10.0;    // How far to extend plate past motor housing
plate_thickness   =   2.0;    // Thickless for mounting plate
corner_radius     =   2;      // Radius on corners of plate
ring_id           =  48.46;   // Nominal OD of 1.5" (48.26mm) schedule 40 PVC + fudge factor
ring_hgt          =  12.5;    // Height of ring pipe fits into
ring_wall         =   2.0;    // Thickness of ring wall
mtg_screw_offset  =  35.0;    // Distance from center to mounting hole (FIXME!)
pipe_od           =   1.900;  // Outside diameter of 1.5" schedule 40 PVC pipe (inches!)
pipe_id           =   1.590;  // Inside diameter of 1.5" schedule 40 PVC pipe (inches!)
chute_ring_len    =   1.000;  // Length of chute mounting ring

sides    = $preview ? 100 : 360;
plate_xy = (plate_margin * 2) + motor_housing;

function i_to_mm (i = 1) = i * 25.4;

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

module myAuger () {
  Auger_twist                 = 360 * 5; // The total amount of twist, in degrees
  Auger_diameter              = 40.5;    // The final diameter of the auger
  Auger_num_flights           = 1;       // The number of "flights" [1:5]
  Auger_flight_length         = 100;     // The height, from top to bottom of the "shaft" [10:200]
  Auger_shaft_radius          = 5;       // The radius of the auger's "shaft" [1:25]
  Auger_flight_thickness      = 1;       // The thickness of the "flight" (in the direction of height) [0.2:Thin, 1:Medium, 10:Thick]
  Auger_handedness            = "right"; // The twist direction ["right":Right, "left":Left]
  Auger_perimeter_thickness   = 0.0;     // The thickness of perimeter support material [0:None, 0.8:Thin, 2:Thick]
  Printer_overhang_capability = 20;      // The overhang angle your printer is capable of [0:40]
  Motor_shaft_len             = 20.0;    // The length of the shaft on the motor

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

module motor_mount () {
  difference () {
    union () {
      linear_extrude (plate_thickness) {
        hull () {
          translate ([-(plate_xy / 2) + 2, (-plate_xy / 2) + 2, 0])
            circle (r = 2, $fn = sides);
          translate ([-(plate_xy / 2) + 2, (plate_xy / 2) - 2, 0])
            circle (r = 2, $fn = sides);
          translate ([(plate_xy / 2) - 2, (-plate_xy / 2) + 2, 0])
            circle (r = 2, $fn = sides);
          translate ([(plate_xy / 2) - 2, (plate_xy / 2) - 2, 0])
            circle (r = 2, $fn = sides);
        }
      }

      translate ([0, 0, plate_thickness - 0.01]) {
        difference () {
          cylinder (d = ring_id + (ring_wall * 2), h = ring_hgt, $fn = sides);
          cylinder (d = ring_id, h = ring_hgt + 0.01, $fn = sides);
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
      x = sin (i) * (((ring_id + ring_wall) / 2) - render_fix);
      y = cos (i) * (((ring_id + ring_wall) / 2) - render_fix);

      translate ([x, y, plate_thickness + (ring_hgt / 2)])
        rotate ([sin (i) * 90, cos (i) * 90, 90])
          cylinder (d = shaft_screw_dia, h = ring_wall + (render_fix * 2), $fn = sides, center = true);
    }
  }
}

module pvc_pipe (od = 1.900, id = 1.590, len = 100) {
  difference () {
    cylinder (d = i_to_mm (od), h = len, $fn = sides);
    cylinder (d = i_to_mm (id), h = len + render_fix, $fn = sides);
  }
}

module hopper (od = 1.900, id = 1.590, len = 100, tee_offset = 40, tee_height = 60) {
  difference () {
    pvc_pipe (od = od, id = id, len = len);
    rotate ([0, 90, 0])
      translate ([-tee_offset, 0, id / 2])
        cylinder (d = id * 25.4, h = 60, $fn = sides);
  }

  rotate ([0, 90, 0])
    translate ([-tee_offset, 0, id / 2])
      pvc_pipe (od = od, id = id, len = tee_height);
}

module chute (od = 2.210, id = 1.900, chute_ring_ = 1.00) {
  od_mm = od * 25.4;
  id_mm = id * 25.4;
  chute_ring__mm = chute_ring_ * 25.4;
  wall = 2.00;

  difference () {
    union () {
      cylinder (d = od_mm, h = chute_ring__mm, $fn = sides);

      translate ([-od_mm / 2, -od_mm / 2, chute_ring__mm - wall])
        cube ([od_mm, od_mm / 2, wall]);
    }

    translate ([0, 0, -render_fix])
      cylinder (d = id_mm, h = chute_ring__mm + wall + (render_fix * 2), $fn = sides);
  }

  points = [
    [(od_mm / 2) - 0,                0, chute_ring__mm - 0],
    [(od_mm / 2) - 2,                0, chute_ring__mm - 0],
    [(od_mm / 2) - 0, -(od_mm / 2) + 2, chute_ring__mm - 0],
    [(od_mm / 2) - 2, -(od_mm / 2) + 2, chute_ring__mm - 0],
    [12.5,                         -60,                 55],
    [10.5,                         -60,                 55],
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
    [ (od_mm / 2) - 0, -(od_mm / 2) + 2, chute_ring__mm - 0],
    [ 12.5,                         -60,                 55],
    [-12.5,                         -60,                 55],
    [-(od_mm / 2) - 0, -(od_mm / 2) + 2, chute_ring__mm - 0],
    [ (od_mm / 2) - 0, -(od_mm / 2) + 0, chute_ring__mm - 0],
    [ 12.5,                         -62,                 55],
    [-12.5,                         -62,                 55],
    [-(od_mm / 2) - 0, -(od_mm / 2) + 0, chute_ring__mm - 0],
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
//  Lay some pipe :)
//
%Nema17 (motor_height);

translate ([0, 0, plate_thickness]) {
  %myAuger ();
  %hopper ();

  translate ([0, 0, 100 - i_to_mm (chute_ring_len)])
    rotate ([0, 0, 270])
      chute ();
}

%motor_mount ();
