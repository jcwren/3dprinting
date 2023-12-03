$fn=128;

text_font = "Source Code Pro:style=Bold";
text_size = 6;

module head () {
  intersection () {
    translate ([0, 0 ,-18])
      sphere (40);
    sphere (25);
  }
}

module base () {
  difference () {
    translate ([0, 0, -50])
      cylinder (40, 8, 16);
    translate ([0, 0, -61])
      cylinder (h=35, r1=4, r2=4);
  }
}

module texts () {
  translate ([0, 0, -18]) {
    rotate ([14, 12, 0])
      linear_extrude (60)
        text ("4", text_size, valign="center", halign="center", font=text_font);
    rotate ([14, 0, 0])
      linear_extrude (60)
        text ("2", text_size, valign="center", halign="center", font=text_font);
    rotate ([-14, 12, 0])
      linear_extrude (60)
        text ("3", text_size, valign="center", halign="center", font=text_font);
    rotate ([-14, 0, 0])
      linear_extrude (60)
        text ("1", text_size, valign="center", halign="center", font=text_font);
    rotate ([-14, -12, 0])
      linear_extrude (60)
        text ("R", text_size, valign="center", halign="center", font=text_font);
  }
}

module lines () {
  translate ([0, 0, -18]) {
      rotate ([0, -12, 0])
        translate ([0, 3, 0])
          cube ([1, 6, 100], center=true);
      rotate ([0, 0, 0])
        cube ([1, 12, 100], center=true);
      rotate ([0, 12, 0])
        cube ([1, 12, 100], center=true);
  }

  hull () {
    translate ([0, 0, -18]) {
      difference () {
        rotate ([0, -12, 0])
          cube ([1, 1, 100], center=true);
        translate ([0, 0, -20])
        cube ([60, 60, 80], center=true);
      }

      difference () {
        rotate ([0, 12, 0])
          cube ([1, 1, 100], center=true);
        translate ([0, 0, -20])
          cube ([60, 60, 80], center=true);
      }
    }
  }
}

module lines_diff () {
  difference () {
    lines ();
    translate ([0,0,-18])
      sphere (39);
    translate ([0, 0, -40])
      cube ([60, 60, 60], center=true);
  }
}

module text_diff () {
  difference () {
    texts ();
    translate ([0,0,-18])
      sphere (39);
  }
}

difference () {
  head ();
  lines_diff ();
  text_diff ();
}

base ();
