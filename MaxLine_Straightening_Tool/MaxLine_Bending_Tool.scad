$fn           = 180;    // Number of sides in a circle
pipe_od       = 25.9;   // OD of MaxLine (1" + 0.02" printing fudge factor)
lip           = 4.7625; // Extra lip on either side is 3/16"
bender_radius = 203.2;  // Bending radius of 3/4" Maxline is 8" (8" to 10" OK)

pipe_height = pipe_od + (lip * 2);
render_fix  = 0.01;

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
  hole_dia   = 5.05;
  hole_depth = 5.3;

  translate ([sin (angle) * ((bender_radius / 2) - distance),
              cos (angle) * ((bender_radius / 2) - distance),
              (pipe_height / 2) - hole_depth])
    cylinder (d = hole_dia, h = hole_depth + render_fix);
}

module pin (angle, distance) {
  pin_dia    = 5;
  pin_height = 5;

  translate ([sin (angle) * ((bender_radius / 2) - distance),
              cos (angle) * ((bender_radius / 2) - distance),
              pipe_height / 2])
    cylinder (d = pin_dia, h = pin_height);
}

module bender () {
  bar_width  = 50.8;  // 2"
  bar_height = 12.9;  // 1/2"
  bar_thick  = 3.429; // 1/8" + 0.01"
  fudge      = 0.3;   // Threaded rod hole was past end of bar (but why?)

  difference () {
    half_wheel ();
    translate ([-((bender_radius / 2) + render_fix), -((bender_radius / 2) + render_fix), -render_fix])
      cube ([bender_radius * .66, bender_radius + (render_fix * 2), pipe_height + (render_fix * 2)]);
    translate ([-((bender_radius / 2) - pipe_od), 0, pipe_height / 2])
      rotate ([0, 90, 0])
        cylinder (d = 9.525, h = (bender_radius / 2) + (pipe_od * 2) - fudge);
    translate ([((bender_radius / 2) - (pipe_od + (bar_thick / 2))), -(bar_width / 2), (pipe_height - bar_height) / 2])
      cube ([bar_thick, bar_width, bar_height]);
    pin_hole (145, 25);
    pin_hole (65, 25);
    pin_hole (110, 55);
  }

  pin (35, 25);
  pin (115, 25);
  pin (70, 55);
}

bender ();
