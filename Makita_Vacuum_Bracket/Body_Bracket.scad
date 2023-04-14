$fn            = 180;
ring_dia       = 113.0;
ring_wall      =   5.0;
ring_hgt       =  15.0;
bracket_hgt    =  50.0;
bracket_wid    =  40.0;
bracket_dep    =  10.0;
spacer_dep     =   8.0;
screw_body_dia =   4.5;  // #8 pan head screw body diameter (0.164")
screw_head_dia =   8.5;  // #8 pan head screw head diameter (0.306" to 0.0322")
screw_head_hgt =   2.8;  // #8 pan head screw head height (0.105" to 0.115")
screw_off_sts  =   8.0;
screw_off_ttb  =   8.0;

module ring () {
  difference () {
    translate ([0, 0, 0])
      cylinder (d = ring_dia + (ring_wall * 2), h = ring_hgt);
    translate ([0, 0, -0.01])
      cylinder (d = ring_dia, h = ring_hgt + 0.02);
    translate ([15, 0, -0.01])
      rotate ([0, 0, 135])
        cube ([ring_dia, ring_dia, ring_hgt + 0.02]);
  }
}

module screw (l) {
  cylinder (d = screw_body_dia, h = l + 0.02);
  cylinder (d = screw_head_dia, h = screw_head_hgt);
}

module bracket () {
  difference () {
    union () {
      translate ([ring_dia / 2, -(bracket_wid / 2), 0])
        cube ([spacer_dep, bracket_wid, ring_hgt]);
      translate ([(ring_dia / 2) + spacer_dep, -(bracket_wid / 2), 0])
        cube ([bracket_dep, bracket_wid, bracket_hgt]);
    }
    translate ([((ring_dia / 2) + spacer_dep) - 0.01,
                 -((bracket_wid / 2) - screw_off_sts),
                 bracket_hgt - screw_off_ttb])
      rotate ([90, 0, 90])
        screw (bracket_dep);
    translate ([((ring_dia / 2) + spacer_dep) - 0.01,
                 (bracket_wid / 2) - screw_off_sts,
                 bracket_hgt - screw_off_ttb])
      rotate ([90, 0, 90])
        screw (bracket_dep);
  }
}

union () {
  ring ();
  bracket ();
}
