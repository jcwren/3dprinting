function i2c (i) = i * 25.4;

$fn       = 180;
pipe_dia  = i2c (0.860);
saw_dia   = i2c (0.250);
width     = i2c (3.000);
depth     = i2c (1.250);
height    = i2c (1.250);
clamp_dep = i2c (1.000);
clamp_hgt = i2c (0.250);

translate ([0, 0, height / 2])
  difference () {
    cube ([width, depth, height], center=true);
    cylinder (d=saw_dia, h=height + 0.02, center=true);
    rotate ([0, 90, 0])
      cylinder (d=pipe_dia, h=width + 0.02, center=true);
  }

translate ([-(width / 2), -((depth / 2) + clamp_dep), -clamp_hgt])
  cube ([width, depth + (clamp_dep * 2), clamp_hgt]);
