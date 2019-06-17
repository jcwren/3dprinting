height = 2.500;
width  = 7.000;
depth  = 3.000;
wall   = 0.125;
plate  = 0.125;

mheight = height * 25.4;
mwidth  = width  * 25.4;
mdepth  = depth  * 25.4;
mwall   = wall   * 25.4;
mplate  = plate  * 25.4;

//
//  Top & bottom
//
translate ([0, 0, 0])
  cube ([mwidth, mdepth, mplate]);
translate ([0, 0, mheight - mplate])
  cube ([mwidth, mdepth, mplate]);

//
//  Vertical supports
//
translate ([0, 0, 0])
  cube ([mwall, mdepth, mheight]);
translate ([((mwidth / 3) * 1) - (mwall / 2), 0, 0])
  cube ([mwall, mdepth, mheight]);
translate ([((mwidth / 3) * 2) - (mwall / 2), 0, 0])
  cube ([mwall, mdepth, mheight]);
translate ([mwidth - mwall, 0, 0])
  cube ([mwall, mdepth, mheight]);
