sides = 360;
pivot_hole_dia = 6.5;
pivot_pin_dia = 6;
pivot_pin_len = 12.5;
height = 100;
no_6_screw_dia = 4.0;
no_6_screw_recess_dia = 7.2;
leg_width = 25;
leg_depth = pivot_pin_len;
leg_height = 100;
mtg_tab_height = 3.5;
mtg_tab_width = 15;

module mounting_ears () {
  difference () {
    translate ([-((leg_width / 2) + mtg_tab_width), 0, 0])
      cube ([leg_width + (mtg_tab_width * 2), pivot_pin_len, 3.5]);
    translate ([-((leg_width / 2) + (mtg_tab_width / 2)), pivot_pin_len / 2, -0.01])
      cylinder (d = no_6_screw_dia, h = mtg_tab_height + 0.02, $fn = sides);
    translate ([(leg_width / 2) + (mtg_tab_width / 2), pivot_pin_len / 2, -0.01])
      cylinder (d = no_6_screw_dia, h = mtg_tab_height + 0.02, $fn = sides);
  }
}

module leg () {
  difference () {
    translate ([-(leg_width / 2), 0, 0])
      cube ([leg_width, pivot_pin_len, leg_height]);
    translate ([0, -0.01, leg_height - (pivot_hole_dia / 2)])
      rotate ([270, 0, 0])
        cylinder (d = pivot_hole_dia, h = leg_depth + 0.02, $fn = sides);
    translate ([-(pivot_hole_dia / 2), -0.01, leg_height - (pivot_hole_dia / 2)])
        cube ([pivot_hole_dia, leg_depth + 0.02, (pivot_hole_dia / 2) + 0.01]);
  }

  mounting_ears ();
}

leg ();
