$fn = 360;

dia = 59.0;

difference () {
  translate ([0, 0, 0])
    cylinder (d = dia, h = 20);
  translate ([0, 0, 2])
    cylinder (d = dia - 2, h = 20);
}