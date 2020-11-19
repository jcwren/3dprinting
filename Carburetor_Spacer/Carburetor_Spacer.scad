sides = 360;
thickness    = 0.2500 * 25.4; // 1/4"
stud_c_to_c  = 2.9375 * 25.4; // 2 15/16"
stud_dia     = 0.4375 * 25.4; // 7/16"
stud_wall    = 0.2000 * 25.4; // 13/64"
bore_dia     = 1.8000 * 25.4; // 1 13/16"
gasket_dia   = 2.4710 * 25.4; // 2 15/32"
cutout_width = 0.2815 * 25.4; // 9/32"
cutout_depth = 0.2215 * 25.4; // 7/32"

stud_radius   = stud_dia / 2;
bore_radius   = bore_dia / 2;
gasket_radius = gasket_dia / 2;

module outline () {
  hull () {
    translate ([0 + (stud_c_to_c / 2), 0, 0])
      cylinder (h=thickness, r=stud_radius+stud_wall, $fn=sides);
    translate ([0 - (stud_c_to_c / 2), 0, 0])
      cylinder (h=thickness, r=stud_radius+stud_wall, $fn=sides);
    translate ([0, 0, 0])
      cylinder (h=thickness, r=gasket_radius, $fn=sides);
  }
}

module holes () {
  translate ([0 + (stud_c_to_c / 2), 0, -0.1])
    cylinder (h=thickness + 0.2, r=stud_radius, $fn=sides);
  translate ([0 - (stud_c_to_c / 2), 0, -0.1])
    cylinder (h=thickness + 0.2, r=stud_radius, $fn=sides);
  translate ([0, 0, -0.1])
    cylinder (h=thickness + 0.2, r=bore_radius, $fn=sides);
}

module cutout (angle) {
  rotate (a=angle)
    hull () {
      translate ([0 + (bore_radius + (cutout_depth / 2)), 0, -0.1])
        cylinder (h=thickness + 0.2, r=cutout_width / 2, $fn=sides);
      translate ([0 - (bore_radius + (cutout_depth / 2)), 0, -0.1])
        cylinder (h=thickness + 0.2, r=cutout_width / 2, $fn=sides);
    }
}

module gasket () {
  difference () {
    outline ();
    holes ();
    cutout (22.5);
    cutout (-22.5);
  }
}

gasket ();
