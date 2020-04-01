screw_od              =  50.5;  // I.D. of schedule 40 2" PVC pipe
screw_len             = 100.0;  // Length of screw
screw_wall_thickness  =   2.5;  // Thickness of screw wall
screw_shaft_dia       =  10.0;  // Diameter of inner shaft
screw_twist           =   2.0;  // Number of twists per 360 degrees
screw_trim            =   3.0;  // Amount to trim from ends to get clean edges
motor_shaft_len       =  20.0;  // Length of shaft on motor (from datasheet)

sides = $preview ? 100 : 360;

use <motor_hub.scad>;

difference () {
  union () {
    //
    //  Spiral
    //
    for (z = [0:(719 + 0)]) {
      rotate (z * screw_twist)
        translate ([0, 0, z * .1393]) // .1393 == 50mm@0..359, .1393 == 100mm@0..719 (bottom edge)
          rotate ([90, 0, 0])
            cube (size = [screw_od / 2, screw_wall_thickness, 1], center = false);
    }

    //
    //  Center shaft
    //
    translate ([0, 0, motor_shaft_len])
      cylinder (h = (screw_len + screw_wall_thickness) - motor_shaft_len, d = screw_shaft_dia, $fn = sides);
  }

  //
  //  Remove material where motor shaft will be placed later
  //
  translate ([0, 0, -0.01])
    cylinder (h = motor_shaft_len + 0.01, d = screw_shaft_dia, $fn = sides);

  //
  //  Flush cut both ends
  //
  *translate ([-((screw_od / 2) + 1), -((screw_od / 2) + 1), -0.01]) {
    cube ([screw_od + 2, screw_od + 2, trim + 0.01]);
    translate ([0, 0, screw_len + screw_trim + .01])
      cube ([screw_od + 2, screw_od + 2, screw_trim + -0.01]);
  }
}

//
//  Place motor hub
//
translate ([0, 0, motor_shaft_len])
  rotate ([180, 0, 0])
    motor_hub (screw_shaft_dia, motor_shaft_len);
