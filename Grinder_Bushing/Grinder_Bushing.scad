sides = 360;

difference () {
  translate ([0, 0, 0])
    cylinder (d=25.35, h=31.0, $fn=sides);
  translate ([0, 0, -0.01])
    cylinder (d=16.12, h=31.02, $fn=sides);
}
