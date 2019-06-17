sides     = 360;
height    = 50.000;
outer_dia = 52.000;
inner_dia = 44.750;

difference () {
  translate ([0, 0, 0])
    cylinder (d = outer_dia, h = height, $fn = sides);
  translate ([0, 0, -0.01])
    cylinder (d = inner_dia, h = height + 0.02, $fn = sides);
}
