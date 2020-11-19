$fn = 360;

function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;
function frac (x, y) = (1 / y) * x;

radius      = 24;
plate_x     = 74;
plate_y     = 74;
main_hole   = 42;
bolt_hole   =  9;
bolt_offset = 37;

module thing (w, h, radius) {
  translate ([radius / 2, radius / 2, 0]) {
    hull () {
      translate ([0, 0, 0])
        circle (d = radius);
      translate ([0, h - radius, 0])
        circle (d = radius);
      translate ([w - radius, h - radius, 0])
        circle (d = radius);
      translate ([w - radius, 0, 0])
        circle (d = radius);
    }
  }
}

linear_extrude (height = in2mm (frac (1, 16)), center = true, convexity = 10, twist = 0)
difference () {
  translate ([-(plate_x / 2), -(plate_y / 2), 0])
    thing (plate_x, plate_y, radius);
  translate ([0, 0, 0])
    circle (d = main_hole);
  translate ([sin (45) * bolt_offset, cos (45) * bolt_offset, 0])
    circle (d = bolt_hole);
  translate ([sin (225) * bolt_offset, cos (225) * bolt_offset, 0])
    circle (d = bolt_hole);
  }
