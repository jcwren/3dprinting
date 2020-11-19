$fn = 360;

function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;
function frac (x, y) = (1 / y) * x;

cube_w = in2mm (1 + frac (1, 4));
cube_h = in2mm (0.75);
cube_d = in2mm (0.75);
cube_wall = in2mm (frac (1, 8));
hole_d = in2mm (frac (5, 16));

difference () {
  cube ([cube_w, cube_d, cube_h]);
  
  translate ([-0.01, -0.01, cube_wall])
    cube ([cube_w + 0.02, cube_d - cube_wall, (cube_h - cube_wall) + 0.02]);
  
  translate ([cube_w / 2, (cube_d - cube_wall) / 2, -0.01])
    cylinder (d = hole_d, h = cube_wall + 0.02);
}