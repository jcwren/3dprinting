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
margin      =  10.0;    // Extra space
render_fix  =   0.01;

module holder (n_len, n_dia, add_ears, y_offset) {
  x = margin + n_len + margin;
  y = margin + n_dia + margin;
  z = lip + (pipe_od / 2) + (n_dia / 2) + margin;
  
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
    }
    
    //
    //  Add alignment posts
    //
    translate ([x - pin_inset, pin_inset, z / 2])
      cylinder (d = pin_dia, h = pin_height);
    translate ([pin_inset, y - pin_inset, z / 2])
      cylinder (d = pin_dia, h = pin_height);
    
    //
    //  Add mounting ears
    //
    if (add_ears) {
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
  holder (nut_len, nut_dia, 1, 60);
}

module coupler_holder () {
  holder (coupler_len, coupler_dia, 0, 0);
  holder (coupler_len, coupler_dia, 1, 60);
}

translate ([0, 0, 0])
  nut_holder ();
translate ([40, 0, 0])
  coupler_holder ();