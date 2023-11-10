$fn = 90;

base_xy          = 80;
base_thickness   =  5;
base_radius      =  5;
base_hole_offset = 73;
base_hole_dia    =  4.6;
leg_xy           = 57.0;
leg_thickness    =  2;
leg_radius       =  2;
leg_height       = 20;
leg_wall         =  4;

module base () {
  difference () {
    hull ()
      for (x = [-1, 1])
        for (y = [-1, 1])
          translate ([x * ((base_xy / 2) - base_radius), y * ((base_xy / 2) - base_radius), 0])
            cylinder (r = base_radius, h = base_thickness);
    for (x = [-1, 1])
      for (y = [-1, 1])
        translate ([x * ((base_xy / 2) - base_hole_offset), y * ((base_xy / 2) - base_hole_offset), -0.01])
          cylinder (d = base_hole_dia, h = base_thickness + 0.02);
  }
}

module leg_holder_outline (o = 17) {
  translate ([0, 0, base_thickness])
    linear_extrude (height = leg_height)
      translate ([-(base_xy / 2) + o, -(base_xy / 2) + o, 0])
        difference () {
          offset (r = leg_wall + (leg_thickness / 2)) {
            square ([leg_xy - (leg_radius / 2), 1]);
            square ([1, leg_xy - (leg_radius / 2)]);
          }
          offset (r = leg_thickness / 2) {
            square ([leg_xy - (leg_radius / 2), leg_thickness / 2]);
            square ([leg_thickness / 2, leg_xy - (leg_radius / 2)]);
          }
          translate ([2.3, 2.3, 0])
            rotate ([0, 0, 45])
              square ([4, 5], center = true);
        }
}

module leg_holder (o = 17) {
  difference () {
    leg_holder_outline (o);
    translate ([-(base_xy / 2) + o, -(base_xy / 2) + o, base_thickness]) {
      translate ([leg_xy / 2, 10, leg_height / 2])
        rotate ([90, 0, 0])
          cylinder (d = 4.6, h = 20);
      translate ([-10, leg_xy / 2, leg_height / 2])
        rotate ([0, 90, 0])
          cylinder (d = 4.6, h = 20);
    }
  }
}

translate ([0, 0, -(base_thickness + leg_height + 0.01)]) {
  base ();
  leg_holder (17);
}
