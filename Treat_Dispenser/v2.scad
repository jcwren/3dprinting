use <Auger.scad>;
use <motor_hub.scad>;

//
//  Must be global to position the NMEA-17 motor correctly. Most variables
//  can be overridden as parameters. Note that some functions use the same
//  parameters, so if they are over-ridden, multiple functions may need the
//  parameter specified (for example, bowl_rim_od is used in both bowl() and
//  motor_mount()).
//
plate_thickness  =   2.5;  // motor_mount - Thickness of motor mounting plate

sides      = $preview ? 100 : 360;
render_fix = $preview ? 0.01 : 0.00;

//
//  Standard NEMA-17 stepper motor. The body width and breadth
//  is fixed, but the length can vary.
//
module nema17 (motor_height = 40) {
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
        translate ([0, 0, motor_height])
          cylinder (h = 2, r = 11, $fn = 24);
        translate ([0, 0, motor_height  + 2])
          cylinder (h = 20, r = 2.5, $fn = 24);
      }

      for (i = [0 : 3]) {
        rotate ([0, 0, 90 * i])
          translate ([15.5, 15.5, motor_height - 4.5])
            cylinder (h = 5, r = 1.5, $fn = 24);
      }
    }
  }
}

module bowl (bowl_rim_od = 100.0,
             bowl_rim_height = 30.0,
             bowl_cone_height = 25.0,
             bowl_neck_id = 51.0,
             bowl_neck_height = 75.0,
             wall = 2.00) {
  difference () {
    bowl_rim_id = bowl_rim_od - (wall * 2);
    bowl_neck_od = bowl_neck_id + (wall * 2);

    union () {
      cylinder (d = bowl_rim_od, h = bowl_rim_height, $fn = sides);
      translate ([0, 0, bowl_rim_height]) {
        cylinder (d2 = bowl_neck_od, d1 = bowl_rim_od, h = bowl_rim_height, $fn = sides);
        translate ([0, 0, bowl_cone_height])
          cylinder (d = bowl_neck_od, h = bowl_neck_height, $fn = sides);
      }
    }
    union () {
      translate ([0, 0, -render_fix])
        cylinder (d = bowl_rim_id, h = bowl_rim_height + (render_fix * 2), $fn = sides);
      translate ([0, 0, bowl_rim_height]) {
        cylinder (d2 = bowl_neck_id, d1 = bowl_rim_id, h = bowl_rim_height + render_fix, $fn = sides);
        translate ([0, 0, bowl_cone_height])
          cylinder (d = bowl_neck_id, h = bowl_neck_height + (render_fix * 2), $fn = sides);
      }
    }
  }
}

//
//  Mounting plate for NEMA-17 stepper motor and a ring to
//  accomodate mounting a pipe. The defaults are for PVC
//  schedule 40 1-1/2".
//
module motor_mount (plate_xy = 43.00,
                    plate_thickness = 2.5,
                    plate_radius = 0.5,
                    wall = 2.00,
                    side_walls = 0,
                    shaft_screw_dia = 3.2,
                    shaft_screw_rad = 21.9,
                    shaft_base_dia = 22.5,
                    bowl_rim_od = 100.0,
                    arm_width = 5.0,
                    arm_nib_height = 8.0) {
  difference () {
    union () {
      linear_extrude (plate_thickness + side_walls) {
        hull () {
          p = ((plate_xy + wall) / 2) - plate_radius;

          translate ([-p, -p, 0])
            circle (r = plate_radius, $fn = sides);
          translate ([-p, p, 0])
            circle (r = plate_radius, $fn = sides);
          translate ([p, -p, 0])
            circle (r = plate_radius, $fn = sides);
          translate ([p, p, 0])
            circle (r = plate_radius, $fn = sides);
        }
      }

      if (side_walls == 0) {
        px = [
          [ [ 0,          arm_width, 0], [ arm_width,          0, 0] ],
          [ [ arm_width,          0, 0], [ 0,         -arm_width, 0] ],
          [ [ 0,         -arm_width, 0], [-arm_width,          0, 0] ],
          [ [-arm_width,          0, 0], [ 0,          arm_width, 0] ]
        ];
        arm_len = bowl_rim_od / 2;

        //
        //  Create the arms
        //
        for (i = [0 : 3]) {
          a = (i * 90) + 45;

          hull () {
            for (j = [0 : 1]) {
              translate (px [i][j]) {
                translate ([0, 0, -arm_nib_height]) {
                  cylinder (d = 2, h = arm_nib_height + plate_thickness, $fn = sides);
                  translate ([sin (a) * arm_len, cos (a) * arm_len, 0])
                    cylinder (d = 2, h = arm_nib_height + plate_thickness, $fn = sides);
                }
              }
            }
          }
        }
      }
    }

    if (side_walls) {
      translate ([0, 0, plate_thickness]) {
        union () {
          linear_extrude (plate_thickness + side_walls + render_fix) {
            hull () {
              p = (plate_xy / 2) - plate_radius;

              translate ([-p, -p, 0])
                circle (r = plate_radius, $fn = sides);
              translate ([-p, p, 0])
                circle (r = plate_radius, $fn = sides);
              translate ([p, -p, 0])
                circle (r = plate_radius, $fn = sides);
              translate ([p, p, 0])
                circle (r = plate_radius, $fn = sides);
            }
          }
        }
      }
    }

    //
    //  Shaft hole
    //
    translate ([0, 0, -render_fix])
      cylinder (d = shaft_base_dia, h = plate_thickness + (render_fix * 2), $fn = sides);

    //
    //  Screw holes for motor
    //
    for (i = [45:90:359]) {
      translate ([sin (i) * shaft_screw_rad, cos (i) * shaft_screw_rad, -render_fix])
        cylinder (d = shaft_screw_dia, h = plate_thickness + (render_fix * 2), $fn = sides);
    }

    //
    //  Create a cylinder the size of the outside of the bowl to trim the
    //  arm nibs to the correct diameter and give them a bit of curvature.
    //
    if (side_walls == 0) {
      translate ([0, 0, -(arm_nib_height + render_fix)])
        cylinder (d = bowl_rim_od, h = arm_nib_height + (render_fix * 2), $fn = sides);
    }
  }
}

//
//  Creates an auger, and adds the motor shaft hub
//
module auger_with_hub (auger_len = 120,
                       auger_diameter = 50.0,
                       auger_shaft_radius = 6.0,
                       auger_twist = 360 * 4,
                       rotation_angle = 0,
                       motor_shaft_len = 20.0) {
  auger_num_flights           = 1;          // The number of "flights" [1:5]
  auger_flight_thickness      = 1;          // The thickness of the "flight" (in the direction of height) [0.2:Thin, 1:Medium, 10:Thick]
  auger_handedness            = "right";    // The twist direction ["right":Right, "left":Left]
  auger_perimeter_thickness   = 0.0;        // The thickness of perimeter support material [0:None, 0.8:Thin, 2:Thick]
  printer_overhang_capability = 20;         // The overhang angle your printer is capable of [0:40]

  //
  //  Calculate variables
  //
  auger_flight_length = auger_len;
  auger_flight_radius = (auger_diameter / 2) - auger_shaft_radius;

  difference () {
    rotate ([0, 0, rotation_angle]) {
      auger (
                      r1 = auger_shaft_radius,
                      r2 = auger_shaft_radius + auger_flight_radius,
                       h = auger_flight_length,
           overhangAngle = printer_overhang_capability,
              multiStart = auger_num_flights,
         flightThickness = auger_flight_thickness,
                   turns = auger_twist / 360,
                   pitch = 0,
        supportThickness = auger_perimeter_thickness,
              handedness = auger_handedness,
                     $fn = sides,
                     $fa = 12,
                     $fs = 5
      );
    }

    //
    //  Remove material where motor shaft will be placed later
    //
    translate ([0, 0, -0.01])
      cylinder (h = motor_shaft_len + 0.01, r = auger_shaft_radius , $fn = sides);
  }

  //
  //  Place motor hub
  //
  translate ([0, 0, motor_shaft_len])
    rotate ([180, 0, 135])
      motor_hub (auger_shaft_radius * 2, motor_shaft_len);
}

%translate ([0, 0, plate_thickness])
  rotate ([0, 180, 0])
    nema17 ();

%motor_mount (plate_thickness = plate_thickness);

rotate ([0, 180, 0]) {
  %auger_with_hub ();
  %bowl ();
}
