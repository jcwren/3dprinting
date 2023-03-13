$fn        = 180.0;
nib_width  =   1.4;
nib_len    =   2.0;
nib_hgt    =   1.4;
head_hgt   =   5.0;
head_dia   =  19.4;
shaft_dia  =  14.3;
shaft_hgt  =  25.4;
handle_dia =  38.1;
handle_hgt =   6.3;
hole_dia   =   9.5;

module tool_head () {
  nib_offset = ((head_dia - nib_len) / 2) + (nib_len / 2);

  intersection () {
    translate ([0, 0, -0.01])
      cylinder (d=head_dia - 0.01, h=head_hgt + nib_hgt + 0.02);
    for (i = [0:45:360])
      translate ([cos (i) * nib_offset, sin (i) * nib_offset, 0])
        rotate ([0, 0, i])
          cube ([nib_len * 2, nib_width, nib_hgt * 2], center=true);
  }
}

module fillet (radius=1, dia=1, rotate=0) {
  rotate ([rotate, 0, 0])
    translate ([dia, 0, 0])
      difference () {
        square (radius);
        translate ([radius, radius, 0])
          circle (r=radius);
      }
}

module tool () {
  rotate_extrude (angle=360, convexity=10, $fn=6)
    translate ([hole_dia / 2, 0, 0])
      square ([(handle_dia - hole_dia) / 2, handle_hgt]);
  rotate_extrude (angle=360, convexity=10) {
    translate ([hole_dia / 2, handle_hgt, 0]) {
      fillet (radius=hole_dia / 4, dia=hole_dia / 4, rotate=0);
      square ([(shaft_dia - hole_dia) / 2, shaft_hgt]);
    }
    translate ([hole_dia / 2, handle_hgt + shaft_hgt, 0]) {
      square ([(head_dia - hole_dia) / 2, head_hgt]);
      fillet (radius=hole_dia / 4, dia=hole_dia / 4, rotate=180);
    }
  }
  translate ([0, 0, handle_hgt + shaft_hgt + head_hgt])
    tool_head ();
}

tool ();
