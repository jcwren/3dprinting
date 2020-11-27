include <tsmthread4.scad>

imperial () {
  difference () {
    cylinder (d = flat () * (1 + 5/16), h = 1/2, $fn = 6);
    translate ([0, 0, -1/64]) 
      thread_npt (DMAJ = 1.050 + $ID_COMP, PITCH = 1 / 14, L = 1);
  }
  
  translate ([2, 0, 0]) {
    $fn = 180;
    difference () {
      cylinder (d = 1.2, h = 4/64);
      translate ([0, 0, -1/64])
        cylinder (d = 1.1, h = 6/64);
    }
  }
}

translate ([0, 0, 0])
  cube ([40, 0.01, 0.01]);