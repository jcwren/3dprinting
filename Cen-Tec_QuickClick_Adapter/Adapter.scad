$fn = 180;
fudge = 0.2;

difference () {
  union () {
    translate ([0, 0, 0])
      cylinder (d=39, h=30);
    translate ([0, 0, 30])
      cylinder (d=32.2, h=5);
    translate ([0, 0, 35])
      cylinder (d1=32.2, d2=31.45, h=25);
  }
  translate ([0, 0, -0.01])
    cylinder (d1=35, d2=26.75, h=70.02);
}
