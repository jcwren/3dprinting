can_dia    = 67.5;  // Diameter of typical soda can
ears_dia   = 75.0;  // Diameter to fit snuggly in caup holder ears
holder_dia = 79.5;  // Diameter of outer wall of cup holder
height     = 55.0;  // Height from bottom of cup holder to above retaining tabs
tab_height =  3.0;  // Height of anti-wobble tabs

difference () {
  union () {
    translate ([0, 0, 0])
      cylinder (h=height, d=ears_dia, $fn=360);
    translate ([0, 0, tab_height / 2]) {
      cube ([10, holder_dia, tab_height], center = true);
      rotate ([0, 0, 90])
        cube ([10, holder_dia, tab_height], center = true);
    }
  }
  translate ([0, 0, -0.01])
    cylinder (h=height + 0.02, d=can_dia, $fn=360);
  translate ([0, 0, height - (ears_dia - can_dia)])
    cylinder (h=(ears_dia - can_dia)+ 0.01, d1=can_dia, d2=ears_dia - ((ears_dia - can_dia) / 2), $fn=360);
};
