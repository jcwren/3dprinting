function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;

width = in2mm (5.5);
height = in2mm (2.75);
depth = in2mm (2.25);
wall = in2mm (0.0625);
radius = in2mm (0.250);
gauge_dia = in2mm (2.1);
sides = 360;

module box () {
  difference () {
    translate ([0, 0, 0]) {
      minkowski () {
        cube ([width, depth, height]);
        cylinder (r=radius, h=1, $fn=sides);
      }
    }
    translate ([0, 0, wall]) {
      minkowski () {
        cube ([width, depth, height]);
        cylinder (r=(radius - wall), h=1, $fn=sides);
      }
    }
  }
}

module gauge_hole (x) {
  translate ([x, -(radius + 0.01), height / 2])
    rotate ([0, 90, 90])
      cylinder (d=gauge_dia, h=radius * 2, $fn=sides);
}

difference () {
  box ();
  gauge_hole (in2mm (1.375));
  gauge_hole (width - in2mm (1.375));
}
