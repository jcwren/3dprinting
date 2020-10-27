$fn = 360;

hgt = 16.0;
hole_dia = 21.5;
plug_dia = 20.4;
thread_dia = 14.5;

difference () {
  translate ([0, 0, 0])
    cylinder (d = hole_dia, h = hgt);
  translate ([0, 0, 2])
    cylinder (d = plug_dia, h = hgt);
  translate ([0, 0, -0.01])
    cylinder (d = thread_dia, h = hgt + 0.02);
}