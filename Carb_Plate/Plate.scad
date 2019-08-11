use <polyround.scad>;

$fn = 360;

function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;
function frac (x, y) = (1 / y) * x;

stud_dia = in2mm (frac (11, 32));
stud_space_x = in2mm (5 + frac (5, 32));
stud_space_y = in2mm (3 + frac (15, 32));

module ear (v, angle)
{
  x = v [0];
  y = v [1];
  l = in2mm (1 + frac (5, 8));
  nx = x + (sin (angle) * l);
  ny = y + (cos (angle) * l);
  d1 = in2mm (frac (3, 4));
  d2 = in2mm (1 + frac (2, 16));
  
  difference ()
  {
    hull () {
      translate ([x, y, 0])
        circle (d = d1);
      translate ([nx, ny, 0])
        circle (d = d2);
    }
    translate ([x, y, 0])
      circle (d = stud_dia);
  }
}

module ears () {
  adjust = 6;
  
  ear ([0,            0],             45 - adjust);
  ear ([0,            stud_space_y], 135 + adjust);
  ear ([stud_space_x, stud_space_y], 225 - adjust);
  ear ([stud_space_x, 0],             315 + adjust);
}

module cutout (w, h, radius) {  
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

module carb_base () {
  difference () {
    x = 0;
    y = 0;
    
    box_w = in2mm (5 + frac (1, 4));
    box_h = in2mm (2 + frac (5, 8));
    box_x_offset = -in2mm (frac (3, 64));
    box_y_offset = in2mm (frac (17, 32));
    
    cut_w = in2mm (4 + frac (5, 16));
    cut_h = in2mm (1 + frac (7, 8));
    cut_x_offset = in2mm (frac (9, 16));
    cut_y_offset = in2mm (1 + frac (1, 32));
    cut_radius = in2mm (0.25);
    
    union () {
      ears ();
      translate ([x + box_x_offset, y + box_y_offset, 0])
        square ([box_w, box_h]);
    }
    translate ([x + cut_x_offset, y + cut_y_offset, 0])
      cutout (cut_w, cut_h, cut_radius);
  }
}

module cable_bracket () {
  difference () {
    tp_w = in2mm (3.0);
    tp_h = in2mm (4.5);
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
    //
    //  Enable for accellerator pump cutout
    //
    if (1) {
      hull () {
        translate ([-in2mm (frac (1, 2)), -in2mm (frac (9, 16)), 0])
          circle (d = in2mm (0.125));
        translate ([-in2mm (frac (1, 2)), -in2mm (frac (17, 16)), 0])
          circle (d = in2mm (0.125));
      }
    }
    translate ([0, 0, 0])
      circle (d = stud_dia);
  }
}

module throttle_bracket () {
  union () {
    translate ([0, 0, 0])
      carb_base ();
    translate ([stud_space_x, 0, 0])
      cable_bracket ();
  }
}

linear_extrude (height = 0.6, center = true, convexity = 10, twist = 0)
  throttle_bracket ();