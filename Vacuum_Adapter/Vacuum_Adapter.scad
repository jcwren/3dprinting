sides=360;
wall=2.96;
port_small = [57, 58.3];
port_large = [90, 92.6];

module neck (ds, dl, flip = false) {
  translate ([0, 0, flip ? 30 : 0]) {
    rotate ([flip ? 180 : 0, 0, 0]) {
      difference () {
        cylinder (h=30, d1=dl + wall, d2=ds + wall, $fn=sides);
        cylinder (h=30, d1=dl, d2=ds, $fn=sides);
      }
    }
  }
}

module small_ports () {
  translate ([-40, 0, 0])
    neck (57, 58.3, true);
  translate ([40, 0, 0])
    neck (57, 58.3, true);
}

module plate_with_holes () {
  difference () {
    hull () {
      translate ([-40, 0, 0])
        cylinder (h=5, d=57 + wall, $fn=sides);
      translate ([40, 0, 0])
        cylinder (h=5, d=57 + wall, $fn=sides);
    }
    translate ([40, 0, 0])
      cylinder (h=5, d=57, $fn=sides);
    translate ([-40, 0, 0])
      cylinder (h=5, d=57, $fn=sides);
  }
}

module plate_without_holes () {
  difference () {
    hull () {
      translate ([-40, 0, 0])
        cylinder (h=5, d=57 + (wall * 2), $fn=sides);
      translate ([40, 0, 0])
        cylinder (h=5, d=57 + (wall * 2), $fn=sides);
    }
    hull () {
      translate ([-40, 0, 0])
        cylinder (h=5, d=57 + wall, $fn=sides);
      translate ([40, 0, 0])
        cylinder (h=5, d=57 + wall, $fn=sides);
    }
  }
}

module reducer_ex (big_hole, little_hole) {
  hull () {
    translate ([0, 0, 0])
      cylinder (h=1, d=big_hole, $fn=sides);
    translate ([0, 0, 24]) {
      translate ([-40, 0, 0])
        cylinder (h=1, d=little_hole, $fn=sides);
      translate ([40, 0, 0])
        cylinder (h=1, d=little_hole, $fn=sides);
    }
  }
}

module reducer () {
  difference () {
    reducer_ex (90 + wall, 57 + (wall * 2));
    reducer_ex (90, 57 + wall);
  }
}

module large_port () {
  neck (90, 92.6);
}

module bottom_half () {
  translate ([0, 0, 0])
    large_port ();
  translate ([0, 0, 30])
    reducer ();
  translate ([0, 0, 55])
    plate_without_holes ();
}

module top_half () {
  translate ([0, 0, 0])
    plate_with_holes ();
  translate ([0, 0, 4.99])
    small_ports ();
}

union () {
  translate ([0, 0, 0])
    bottom_half ();
  translate ([0, 100, 0])
    top_half ();
  translate ([-(wall / 2), 92.6 / 2, 0])
    cube ([wall, 24, 1]);
}
