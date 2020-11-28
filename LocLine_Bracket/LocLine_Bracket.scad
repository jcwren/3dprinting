include <tsmthread4.scad>

$fn = 184;

imperial () {
  translate ([0, 0, 0]) {
    difference () {
      cylinder (d = 1 + 21/64, h = 0.35);
      translate ([0, 0, -1/64])
        thread_npt (DMAJ = 1.050 + $ID_COMP, PITCH = 1 / 14, L = 0.40);
    }
  }

  translate ([1.5, 0, 0]) {
    difference () {
      cylinder (d = 1 + 21/64, h = 0.35);
      translate ([0, 0, -1/64])
        thread_npt (DMAJ = 1.050 + $ID_COMP, PITCH = 1 / 14, L = 0.40);
    }
  }

  translate ([0, 1.5, 0]) {
    difference () {
      cylinder (d = 1 + 21/64, h = 0.35);
      translate ([0, 0, -1/64])
        cylinder (d = 1.117, h = 0.37);
    }
  }

  translate ([1.5, 1.5, 0]) {
    difference () {
      cylinder (d = 1 + 21/64, h = 0.35);
      translate ([0, 0, -1/64])
        cylinder (d = 1.117, h = 0.37);
    }
  }
}

difference () {
  translate ([0, 0, 0])
    cube ([40.00, 40.00, 0.01]);
  translate ([0.01, 0.01, -0.01])
    cube ([39.98, 39.98, 0.03]);
}
