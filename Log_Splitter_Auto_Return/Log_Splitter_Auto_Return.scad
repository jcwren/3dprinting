$fn        = 360;
cyl_dia    = 118.0;   // Diameter of hydraulic cylinder
pipe_dia   =  21.5;   // 1/2" PVC OD is 0.84"
reduce     =  18.0;   // Prevents bracket from going all the way to cyl_dia / 2.
thickness  =  10.0;   // Thickness of bracket
fix_render =   0.01;  // Fudge factor to make render correctly

pipe_y = (cyl_dia / 2) + (((cyl_dia - reduce) - (cyl_dia / 2)) / 2);

difference () {
  scale ([1.0, 2.0, thickness])
    cylinder (d = cyl_dia - reduce);

  translate ([0, pipe_y, -fix_render])
    cylinder (d = pipe_dia, h = thickness + (fix_render * 2));

  translate ([0, 0, -fix_render])
    cylinder (d = cyl_dia, h = thickness + (fix_render * 2));

  translate ([-(cyl_dia / 2), -(cyl_dia - reduce), -fix_render])
    cube ([cyl_dia, cyl_dia - reduce, thickness + (fix_render * 2)]);
}
