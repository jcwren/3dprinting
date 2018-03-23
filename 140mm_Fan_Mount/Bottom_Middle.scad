sides = 360;
hole_size = 4.4;
head_size = 6.6;

//
//  No need to rotate it in the slicer if we do it here.
//  Slic3r PE on a Prusa i3 Mk3 prints this without any
//  supports or brim.
//

rotate ([0, 0, 0])  {
  difference () {
    union () {
      translate ([0, 0, 0])  // top
        cube ([3, 31.5, 30]);

      translate ([3, 0, 0])  // front leg
        cube ([15, 3, 30]);

      translate ([3, 28.5, 0])  // middle leg
        cube ([13, 3, 30]);

      translate ([-13.2, 0, 0]) // bottom
        cube ([13.2, 31.5, 30]);
    }

    translate ([-13.3, (31.5 - 18.5) / 2, -0.1]) // bottom cutout
      cube ([13.3, 18.5, 30.2]);

    translate ([(30 / 2) - 4.5, -0.1, 13 + 3 + 6.5]) // left top hole
      rotate ([270, 0, 0])
        cylinder (d1=head_size, d2=hole_size, h=3.2, $fn = sides);

    translate ([(30 / 2) - 4.5, -0.1, 7.5]) // right top hole
      rotate ([270, 0, 0])
        cylinder (d1=head_size, d2=hole_size, h=3.2, $fn = sides);

    translate ([-6.5, -0.1, (31.5 / 2)])
      rotate ([270, 0, 0])
        cylinder (d=hole_size, h=6.7, $fn = sides);
  }
}