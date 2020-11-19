$fn = 360;
od  = 23.0;
id  = 21.2;
hgt = 50.0;

difference () {
  translate ([0, 0, 0])
    cylinder (d = od, h = hgt);
  translate ([0, 0, -0.01])
    cylinder (d = id, h = hgt + .02);
}
