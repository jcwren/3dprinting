$fn            = 180;
screw_body_dia =   4.5;  // #8 pan head screw body diameter (0.164")
screw_head_dia =   8.5;  // #8 pan head screw head diameter (0.306" to 0.0322")
screw_head_hgt =   2.8;  // #8 pan head screw head height (0.105" to 0.115")
screw_off_sts  =   8.0;
screw_off_ttb  =   8.0;
tube_wall      =   5.0;
tube_dia       =  32.0;
tube_hgt       =  10.0;
spacer_hgt     =  35.0;
spacer_dep     =  10.0;
foot_wid       =  tube_dia;
foot_len       =  25.0;
foot_hgt       =   5.0;

module screw (l) {
  cylinder (d = screw_body_dia, h = l + 0.02);
  cylinder (d = screw_head_dia, h = screw_head_hgt);
}

module ring () {
  difference () {
    translate ([0, 0, 0])
      cylinder (d = tube_dia + (tube_wall * 2), h = tube_hgt);
    translate ([0, 0, -0.01])
      cylinder (d = tube_dia, h = tube_hgt + 0.02);
    translate ([10, 0, -0.01])
      rotate ([0, 0, 135])
        cube ([tube_dia, tube_dia, tube_hgt + 0.02]);
  }
}

module bracket () {
  translate ([0, 0, spacer_hgt + (tube_dia / 2)])
    rotate ([270, 90, 0])
      ring ();
  translate ([-(tube_dia / 4), 0, 0])
    cube ([tube_dia / 2, spacer_dep, spacer_hgt]);
  translate ([-(foot_wid / 2), 0, 0])
    cube ([foot_wid, foot_len, foot_hgt]);
}

rotate ([90, 0, 0])
  difference () {
    bracket ();
    translate ([-((foot_wid / 2) - screw_off_sts), foot_len - screw_off_ttb, foot_hgt + 0.01])
      rotate ([0, 180, 0])
        screw (foot_hgt);
    translate ([((foot_wid / 2) - screw_off_sts), foot_len - screw_off_ttb, foot_hgt + 0.01])
      rotate ([0, 180, 0])
        screw (foot_hgt);
  }