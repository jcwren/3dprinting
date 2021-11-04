$fn           = 180;      // Number of sides in a circle
pipe_od       =  25.9;    // OD of MaxLine (1" + 0.02" printing fudge factor)
lip           =   4.7625; // Extra lip on either side is 3/16"
bender_radius = 203.2;    // Bending radius of 3/4" Maxline is 8" (8" to 10" OK)
nut_dia       =  17.0;    // Diameter of 3/8" nut + 0.2mm
nut_len       =   9.5;    // Length of 3/8" nut + 1.2mm
washer_hgt    =   2.0;    // Thickness of 3/8" SAE washer + 0.2mm
washer_dia    =  26.3;    // Diameter of 3/8" SAE washer + 0.8mm
bar_width     =  50.8;    // End plate bar length is 2"
bar_height    =  12.9;    // End plate bar height is 1/2"
bar_thick     =   3.429;  // End plate bar thickness is 1/8" + 0.01"
hole_dia      =   5.05;   // Locator hole diameter + 0.05mm for clearance
hole_depth    =   5.3;    // Locator hole depth + 0.3mm for clearance
pin_dia       =   5.0;    // Locator pin diameter
pin_height    =   5.0;    // Locator pin depth
render_fix    =   0.01;

pipe_height = pipe_od + (lip * 2);

module wheel () {
  difference () {
    cylinder (h = pipe_height, d = bender_radius);

    union  () {
      translate ([0, 0, (pipe_height - pipe_od) / 2]) {
        difference () {
          cylinder (h = pipe_od, d = bender_radius);
          translate ([0, 0, -render_fix])
            cylinder (h = pipe_od + 0.02, d = bender_radius);
        }
      }
      rotate_extrude (convexity = 10)
        translate ([bender_radius / 2, pipe_height / 2, 0])
          circle (d = pipe_od);
    }
  }
}

module half_wheel () {
  difference () {
    wheel ();
    translate ([0, 0, pipe_height / 2])
      cylinder (d = bender_radius + pipe_od, h = (pipe_height / 2) + render_fix);
  }
}

module pin_hole (angle, distance) {
  translate ([sin (angle) * ((bender_radius / 2) - distance),
              cos (angle) * ((bender_radius / 2) - distance),
              (pipe_height / 2) - hole_depth])
    cylinder (d = hole_dia, h = hole_depth + render_fix);
}

module pin (angle, distance) {
  translate ([sin (angle) * ((bender_radius / 2) - distance),
              cos (angle) * ((bender_radius / 2) - distance),
              pipe_height / 2])
    cylinder (d = pin_dia, h = pin_height);
}

module bender (add_bar = false) {
  difference () {
    half_wheel ();

    translate ([0, 0, pipe_height / 2]) {
      rotate ([0, 90, 0])
        cylinder (d = 9.525, h = (bender_radius / 2) - pipe_od);

      translate ([(bender_radius / 2) - pipe_od, 0, 0]) {
        if (add_bar)
          translate ([0, -(bar_width / 2) + bar_thick, -(bar_height / 2)])
            cube ([bar_thick, bar_width, bar_height]);

        rotate ([0, 90, 0])
          cylinder (d = washer_dia, h = washer_hgt + render_fix);

        translate ([-nut_len, 0, 0]) {
          rotate ([0, 90, 0])
            cylinder (d = nut_dia, h = nut_len + render_fix);
          translate ([-washer_hgt, 0, 0])
            rotate ([0, 90, 0])
              cylinder (d = washer_dia, h = washer_hgt + render_fix);
        }
      }
    }

    translate ([-((bender_radius / 2) + render_fix), -((bender_radius / 2) + render_fix), -render_fix])
      cube ([bender_radius * .66, bender_radius + (render_fix * 2), pipe_height + (render_fix * 2)]);

    pin_hole (145, 25);
    pin_hole (65, 25);
    pin_hole (110, 55);
  }

  pin (35, 25);
  pin (115, 25);
  pin (70, 55);
}

bender (false);
