$fn = 90;
tee_handle_len  = 22.2; //  Length from end to end of tee handle
tee_handle_dia  =  3.9; //  Diameter of tee handle bar
tee_clearance   =  3.0; //  Clearance between tee handle and jack base
tee_depth       =  5.0; //  Depth of recess for tee handle
stud_dia        =  9.0; //  Diameter of center of tee handler
stud_depth      =  7.5; //  Depth of recess for tee stud
base_height     =  9.0; //  Thickness of base portion
knob_height     =  7.0; //  Thickness of knob portion

module knob_base () {
  difference () {
    translate ([0, 0, 0])
      cylinder (d = tee_handle_len + (tee_clearance * 2), h = base_height);
    translate ([0, 0, base_height - stud_depth])
      cylinder (d = stud_dia, h = stud_depth + 0.01);
    translate ([-tee_handle_len / 2, -tee_handle_dia / 2, base_height - tee_depth])
      cube ([tee_handle_len, tee_handle_dia, tee_depth + 0.01]);
  }
}

module knob_handle (hgt = 7) {
  linear_extrude (height = hgt) {
    difference () {
      dia = 50;
      point_dia = 5;
      cutout_dia = 35;
      cutout_offset = 36;

      hull () {
        for (i = [0:60:360]) {
          x = sin (i) * ((dia - point_dia) / 2);
          y = cos (i) * ((dia - point_dia) / 2);
          translate ([x, y, 0])
            circle (d = point_dia);
        }
      }

      for (i = [30:60:360]) {
        x = sin (i) * cutout_offset;
        y = cos (i) * cutout_offset;
        translate ([x, y, 0])
          circle (d = cutout_dia);
      }
    }
  }
}

translate ([0, 0, 0])
  knob_handle (knob_height);
translate ([0, 0, knob_height])
  knob_base ();
