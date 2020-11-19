sides = 360;
hole_size = 4.0;

//
//  No need to rotate it in the slicer if we do it here.
//  Slic3r PE on a Prusa i3 Mk3 prints this without any
//  supports or brim.
//

rotate ([180, 0, 0])  {
  difference () {
    union () {
      translate ([0, 0, 0]) // main cube
        cube ([3 + 13 + 3, 3 + 18.5 + 6.5, 3 + 13 + 3]);

      translate ([0, 0, -10]) // screw tab
        cube ([3 + 13 + 3, 5, 10]);
    }

    translate ([3, 6.5, -0.1]) // cutout
      cube ([13, 18.5, 3 + 13 + 3 + 0.2]);

    translate ([(3 + 13 + 3) / 2, -0.1, -(10 / 2)]) // screw
      rotate ([270, 0, 0])
        cylinder (d=hole_size, h=5.2, $fn = sides);
  }
}
