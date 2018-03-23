sides = 360;
hole_size = 4.4;
head_size = 6.6;

//
//  No need to rotate it in the slicer if we do it here.
//  Slic3r PE on a Prusa i3 Mk3 prints this without any
//  supports or brim.
//

rotate ([0, 270, 0])  {
  difference () {
    union () {
      translate ([0, 0, 0])  // top
        cube ([3, 53, 18]);

      translate ([3, 0, 0])  // front leg
        cube ([15, 3, 18]);

      translate ([3, 28.5, 0])  // middle leg
        cube ([13, 3, 18]);

      translate ([3, 50, 0])  // back leg
        cube ([18.5, 3, 18]);

      translate ([3, 3, 15]) // side
        cube ([13, 25.5, 3]);
    }

    translate ([(30 / 2) - 4.5, -0.1, 7.5]) // hole
      rotate ([270, 0, 0])
        cylinder (d1=head_size, d2=hole_size, h=3.2, $fn = sides);
  }
}