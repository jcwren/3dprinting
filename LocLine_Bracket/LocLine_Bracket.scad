include <tsmthread4.scad>

imperial () {
  difference () {
    cylinder (d = 1 + 21/64, h = 0.35, $fn = 180);
    translate ([0, 0, -1/64])
      thread_npt (DMAJ = 1.050 + $ID_COMP, PITCH = 1 / 14, L = 0.40);
  }

  translate ([1.5, 0, 0]) {
    $fn = 180;
    difference () {
      cylinder (d = 1 + 21/64, h = 0.35);
      translate ([0, 0, -1/64])
        cylinder (d = 1.117, h = 0.37);
    }
  }

  translate ([3, 0, 0]) {
    $fn = 180;
    difference () {
      cylinder (d = 1 + 21/64, h = 0.35);
      translate ([0, 0, -1/64])
        cylinder (d = 1.117, h = 0.37);
    }
  }}

translate ([0, 0, 0])
  cube ([80, 0.01, 0.01]);
