//
//  Fits 1/2 CVPC pipe
//

$fn = 180;

pipe_inner_dia  = 12.4;
pipe_height     = 10.0;
guide_dia       = 60.0;
guide_thickness =  2.0;

union () {
  cylinder (d = guide_dia, h = guide_thickness);
  cylinder (d = pipe_inner_dia, h = pipe_height + guide_thickness);
}
