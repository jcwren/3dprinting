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

module circletext (mytext, textsize=20, myfont="Arial", radius=100, thickness=1, degrees=360, top=true) {
  chars = len (mytext) + 1;

  for (i = [1:chars]) {
    rotate ([0, 0, (top ? 1 : -1) * (degrees / 2 - i * (degrees / chars))])
      translate ([0, (top ? 1 : -1) * radius - (top ? 0 : textsize / 2), 0])
        linear_extrude (thickness)
          text (mytext [i-1], halign="center", font=myfont, size=textsize);
  }
}

module tool_head () {
  nib_offset = ((head_dia - nib_len) / 2) + (nib_len / 2);

  intersection () {
    translate ([0, 0, -0.01])
      cylinder (d=head_dia - 0.01, h=head_hgt + nib_hgt + 0.02);
    union () {
      cylinder (d=head_dia, h=head_hgt);

      for (i = [0:45:360])
        translate ([cos (i) * nib_offset, sin (i) * nib_offset, head_hgt])
          rotate ([0, 0, i])
            cube ([nib_len * 2, nib_width, nib_hgt * 2], center=true);
    }
  }
}

module fillet (radius=1, dia=1, rotate=0) {
  rotate ([rotate, 0, 0])
    rotate_extrude (angle=360, convexity=10)
      translate ([dia, 0, 0])
        difference () {
          square (radius);
          translate ([radius, radius, 0])
            circle (r=radius);
        }
}

module tool () {
  difference () {
    union () {
      translate ([0, 0, 0])
        cylinder (d=handle_dia, h=handle_hgt + 0.01, $fn=6);
      translate ([0, 0, handle_hgt]) {
        cylinder (d=shaft_dia, h=shaft_hgt + 0.01);
        fillet (radius=(head_dia - shaft_dia) / 2, dia=shaft_dia / 2, rotate=0);
      }
      translate ([0, 0, handle_hgt + shaft_hgt]) {
        tool_head ();
        fillet (radius=(head_dia - shaft_dia) / 2, dia=shaft_dia / 2, rotate=180);
      }
    }
    translate ([0, 0, -0.01])
      cylinder (d=hole_dia, h=handle_hgt + shaft_hgt + head_hgt + 0.02);
  }
}

difference () {
  tool ();
  translate ([0, 0, handle_hgt-0.98])
    rotate ([0, 0, 0]) {
      circletext ("MOPAR", textsize=4, degrees=120, top=true, radius=11);
      circletext ("OR NO CAR", textsize=4, degrees=180, top=false, radius=13);
    }
  }
