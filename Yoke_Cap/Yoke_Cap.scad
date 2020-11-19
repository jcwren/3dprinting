function in2mm (v) = v * 25.4;

$fn          = 180.0;
yoke_dia     = in2mm (1.50);
yoke_height  = in2mm (1.50);
shaft_dia    = in2mm (1.17);
shaft_height = in2mm (0.50);
wall         = 1.5;

difference () {
  translate ([0, 0, 0])
    cylinder (d = yoke_dia, h = yoke_height);
  translate ([0, 0, wall])
    cylinder (d = shaft_dia, h = shaft_height + 0.01);
  translate ([0, 0, shaft_height + wall])
    cylinder (d = yoke_dia - (wall * 2), h = yoke_height);
}