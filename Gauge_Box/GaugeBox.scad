function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;

width = in2mm (5.5);
height = in2mm (2.75);
depth = in2mm (2.25);
wall = in2mm (0.0625);
radius = in2mm (0.250);
gauge_dia = in2mm (2.1);
sides = 360;

module box_outline (h = height) {
  difference () {
    translate ([0, 0, 0]) {
      minkowski () {
        cube ([width, depth, h]);
        cylinder (r=radius, h=0.01, $fn=sides);
      }
    }
    translate ([0, 0, wall]) {
      minkowski () {
        cube ([width, depth, h]);
        cylinder (r=(radius - wall), h=0.01, $fn=sides);
      }
    }
  }
}

module box_lid () {
  difference () {
    translate ([0, 0, 0]) {
      minkowski () {
        cube ([width, depth, wall * 3]);
        cylinder (r=radius, h=0.01, $fn=sides);
      }
    }

    translate ([0, 0, 0]) {
      minkowski () {
        cube ([width, depth, wall * 2]);
        cylinder (r=(radius - (wall * 2)), h=0.01, $fn=sides);
      }
    }
  }
}

module gauge_hole (x) {
  translate ([x, -(radius + 0.01), height / 2])
    rotate ([0, 90, 90])
      cylinder (d=gauge_dia, h=radius * 2, $fn=sides);
}

module box () {
  difference () {
    box_outline ();
    gauge_hole (in2mm (1.375));
    gauge_hole (width - in2mm (1.375));
  }
}

module lid () {
  translate ([0, 0, wall * 3]) {
    mirror ([0, 0, 1]) {
      difference () {
        box_lid ();
        box_outline (wall * 2);
      }
    }
  }
}

union () {
  translate ([0, 0, 0])
    box ();
  translate ([0, depth + in2mm (0.75), 0])
    lid ();
  translate ([0, 0, 0])
    cube ([0.01, width * 2, 0.01]);
}
