use <polyround.scad>;

$fn = 360;

function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;
function frac (x, y) = (1 / y) * x;

module cable_bracket_ell () {
  tp_w = in2mm (4.0);
  tp_h = in2mm (3.125);
  tp_x_offset = -in2mm (frac (1, 2));
  tp_y_offset = in2mm (frac (15, 16));

  translate ([-in2mm (0.5), tp_y_offset - tp_h, 0]) {
    round2d (in2mm (0.125), in2mm (0.125)) {
      difference () {
        translate ([0, 0, 0])
          square ([tp_w, tp_h]);
        translate ([in2mm (1), in2mm (1), 0])
          square ([in2mm (3.0), in2mm (3.5)]);
      }
    }
  }
}

cable_bracket_ell ();
