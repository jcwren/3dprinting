//
// Custom battery tray - bigclive.com
//
$fn = 90;

//
// You can adjust these variables.
//
//   AA  - 14.6mm
//  AAA  - 11.0mm
//    C  - 25.8mm
//    D  - 33.5mm
//
width     =  5;   // Number of horizontal cups
height    =  6;   // Number of vertical cups
depth     = 10;   // Internal depth of cups (10 for AA/AAA, 15 for C/D)
diameter  = 14.8; // Diameter of cylinder (see table above)
thickness =  1;   // Thickness of wall
base      =  1;   // Thickness of cup bases

//
// Don't adjust stuff below here
//
columns = width - 1;
rows    = height - 1;
wall    = thickness * 2;
dia     = diameter + thickness;
cup     = depth + base;

difference () {
  union () {
    for (x = [0:columns]) {
      for (y = [0:rows]) {
        translate ([x * dia, y * dia, 0])
          cylinder (h = cup, d = diameter + wall);
      }
    }
  }

  for (x = [0:columns]) {
    for (y = [0:rows]) {
      translate ([x * dia, y * dia, base])
        cylinder (h = cup, d = diameter);
    }
  }
}
