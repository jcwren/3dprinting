include <gears.scad>

outer_diameter   = 10;   // Outer diameter of the adapter
stepper_length   = 10;   // Length of the stepper shaft
stepper_diameter =  5.3; // Diameter of the stepper shaft
stepper_d_offset =  2;   // Offset from the center of the shaft to the plane of the D

// 4mm shaft: d = 4, offset = 1.6
// 5mm shaft: d = 5, offset = 2
// 6mm shaft: d = 6, offset = 2.5

$fn = 128;

module d_shaft (dia = 0, hgt = 0) {
  if (hgt) {
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

module valve_gear () {
  rotate ([0, 180, 0])
    translate ([0, 0, -10])
      difference () {
        spur_gear (modul=1, tooth_number=50, width=10, bore=0, pressure_angle=20, helix_angle=20, optimized=false);
        handle_cutout ();
      }
}

module motor_gear () {
  spur_gear (modul=1, tooth_number=25, width=5, bore=outer_diameter, pressure_angle=20, helix_angle=-20, optimized=false);
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

module valve_gears (gear_drive = 0) {
  if (gear_drive) {
    translate ([0, 0, 0])
      valve_gear ();
    translate ([40, 0, 0])
      motor_gear ();
  } else
    translate ([0, 0, 0])
      adapter ();
}

*valve_gears (1);
