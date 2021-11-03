$fn         = 180;      // Number of fragments
pipe_od     =  25.9;    // OD of MaxLine (1" + 0.02" printing fudge factor)
lip         =   4.7625; // Extra lip on either side of bender and wheel is 3/16"
nut_dia     =  16.8;    // Diameter of 3/8" nut
nut_len     =   9.0;    // Length of 3/8" nut
coupler_dia =  18.5;    // Diameter of 3/8" coupler
coupler_len =  45.0;    // Length of 3/8" coupler
trod_dia    =   9.725;  // 3/8" threaded rod dia + 0.1mm for loose fit
tab_width   =  12.7;    // Width of mounting tabs
tab_thick   =   3.175;  // Thickness of mounting tabs
tab_hole    =   4.1;    // Hole size for #8 screw
pin_dia     =   5.0;    // Alignment pin diameter
pin_height  =   5.0;    // Alignment pin height
pin_inset   =   5.0;    // Alignment pin inset from edges of holder
pin_slop    =   0.05;   // Alignment pin slop so things aren't TOO tight
washer_hgt  =   1.8;    // Thickness of 3/8" SAE washer
chamfer     =   2.0;    // Edge chamfer in mm
margin      =  10.0;    // Extra space
render_fix  =   0.01;

nut_x     = margin + nut_len + margin;
nut_y     = margin + nut_dia + tab_width + margin;
coupler_x = margin + coupler_len + margin;
coupler_y = margin + coupler_dia + tab_width + margin;
biggest_x = max (nut_x, coupler_x) + 1;
biggest_y = max (nut_y, coupler_y) + 1;

function hypotenuse (a, b) = sqrt ((a * a) + (b * b));

module horizontal_chamfer (x, y, z) {
  v = [[[0, -render_fix, z + (hypotenuse (chamfer, chamfer) / 2)], [270, 0, 0], y],
       [[x, -render_fix, z + (hypotenuse (chamfer, chamfer) / 2)], [270, 0, 0], y],
       [[x + render_fix, -(hypotenuse (chamfer, chamfer) / 2), z], [0, 270, 0], x],
       [[x + render_fix, y - (hypotenuse (chamfer, chamfer) / 2), z], [0, 270, 0], x]
      ];

  for (i = [0:3])
    translate (v [i][0])
      rotate (v [i][1])
        rotate ([0, 0, 45])
          cube ([chamfer, chamfer, v [i][2] + (render_fix * 2)]);
}

module vertical_chamfer (x, y, z) {
  v = [[0, -(hypotenuse (chamfer, chamfer) / 2)],
       [x + (hypotenuse (chamfer, chamfer) / 2), 0],
       [x, y + (hypotenuse (chamfer, chamfer) / 2)],
       [-(hypotenuse (chamfer, chamfer) / 2), y]
      ];

  for (i = [0:3])
    translate ([v [i][0], v [i][1], z])
      rotate ([0, 0, (i * 90) + 45])
        cube ([chamfer, chamfer, x + (render_fix * 2)]);
}

module holder (n_len, n_dia, add_tabs, y_offset) {
  x = margin + n_len + margin;
  y = margin + n_dia + margin;
  z = (washer_hgt * add_tabs) + lip + (pipe_od / 2) + (n_dia / 2) + margin;

  translate ([0, y_offset, 0]) {
    //
    //  Basic shells
    //
    difference () {
      difference () {
        cube ([x, y, z]);
        translate ([margin, y / 2, z / 2])
          rotate ([0, 90, 0])
            cylinder (d = n_dia, h = n_len, $fn = 6);
        translate ([-render_fix, y / 2, z / 2])
          rotate ([0, 90, 0])
            cylinder (d = trod_dia, h = x + (render_fix * 2));
      }
      translate ([-render_fix, -render_fix, z / 2])
        cube ([x + (render_fix * 2), y + (render_fix * 2), (z / 2) + (render_fix * 2)]);
      translate ([pin_inset, pin_inset, (z / 2) - pin_height])
        cylinder (d = pin_dia + pin_slop, h = pin_height + 0.3);
      translate ([x - pin_inset, y - pin_inset, (z / 2) - pin_height])
        cylinder (d = pin_dia + pin_slop, h = pin_height + 0.3);

      if (!add_tabs)
        horizontal_chamfer (x, y, 0);

      vertical_chamfer (x, y, add_tabs ? tab_thick : 0);
    }

    //
    //  Add alignment posts
    //
    translate ([x - pin_inset, pin_inset, z / 2])
      cylinder (d = pin_dia, h = pin_height);
    translate ([pin_inset, y - pin_inset, z / 2])
      cylinder (d = pin_dia, h = pin_height);

    //
    //  Add mounting tabs
    //
    if (add_tabs) {
      for (yy = [-tab_width, y]) {
        difference () {
          translate ([0, yy, 0])
            cube ([x, tab_width, tab_thick]);
          translate ([tab_width / 2, yy + (tab_width / 2), -render_fix])
            cylinder (d = tab_hole, h = tab_thick + (render_fix * 2));
          translate ([x - (tab_width / 2), yy + (tab_width / 2), -render_fix])
            cylinder (d = tab_hole, h = tab_thick + (render_fix * 2));
        }
      }
    }
  }
}

module nut_holder () {
  holder (nut_len, nut_dia, 0, 0);
  holder (nut_len, nut_dia, 1, biggest_y);
}

module coupler_holder () {
  holder (coupler_len, coupler_dia, 0, 0);
  holder (coupler_len, coupler_dia, 1, biggest_y);
}

translate ([0, 0, 0])
  nut_holder ();
translate ([nut_x + 1, 0, 0])
  coupler_holder ();
