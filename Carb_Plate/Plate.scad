use <polyround.scad>;

$fn = 360;

function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;
function frac (x, y) = (1 / y) * x;

stud_dia = in2mm (frac (11, 32));
stud_space_x = in2mm (5 + frac (5, 32));
stud_space_y = in2mm (3.5);

STUD_LL = 0;
STUD_UL = 1;
STUD_UR = 2;
STUD_LR = 3;

stud_loc = [
  [-(stud_space_x / 2), -(stud_space_y / 2)], // Lower left
  [-(stud_space_x / 2),  (stud_space_y / 2)], // Upper left
  [ (stud_space_x / 2),  (stud_space_y / 2)], // Upper right
  [ (stud_space_x / 2), -(stud_space_y / 2)]  // Lower right
];

module rounded_box (size, r) {
  w = size [0];
  h = size [1];
  
  hull () {
    translate ([r, r, 0])
      circle (r);
    translate ([r, h - r, 0])
      circle (r);
    translate ([w - r, h - r, 0])
      circle (r);
    translate ([w - r, r, 0])
      circle (r);
  }
}

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
  adjust = 5;
  
  ear (stud_loc [STUD_LL],  45 - adjust);
  ear (stud_loc [STUD_UL], 135 + adjust);
  ear (stud_loc [STUD_UR], 225 - adjust);
  ear (stud_loc [STUD_LR], 315 + adjust);
}

module cutout (w, h, y_offset, radius) {  
  hull () {
    translate ([-(w / 2), (-(h / 2)) + y_offset, 0])
      circle (d = radius);
    translate ([-(w / 2), (h / 2) + y_offset, 0])
      circle (d = radius);
    translate ([w / 2, (h / 2) + y_offset, 0])
      circle (d = radius);
    translate ([w / 2, (-(h / 2)) + y_offset, 0])
      circle (d = radius);
  }
}

//
//  cut_offset should be calculatable, but I can't figure out what
//  it should be. For now, it's imperically derived.
//
module carb_base () {
  difference () {
    top_offset = in2mm (frac (17, 32)); 
    bot_offset = in2mm (frac (5, 16)); 
    box_h = stud_space_y - (top_offset + bot_offset);
    box_w = stud_space_x + in2mm (frac (1, 16) * 2);
    cut_w = box_w - (in2mm (0.50) * 2);
    cut_h = box_h - (in2mm (0.50) * 2);
    cut_offset = -in2mm (0.1);
    cut_radius = in2mm (0.25);
    
    union () {
      ears ();
      translate ([-(box_w / 2), -((stud_space_y / 2) - bot_offset), 0])
        square ([box_w, box_h]);
    }
    cutout (cut_w, cut_h, cut_offset, cut_radius);
  }
}

module cable_bracket () {
  translate ([stud_loc [STUD_UR][0], stud_loc [STUD_UR][1], 0]) {
    difference () {
      translate ([-in2mm (0.5), -in2mm (0.5), 0]) {
        round2d (in2mm (0.125), in2mm (0.125)) {
          difference () {
            square ([in2mm (2.5), in2mm (3.5)]);
              translate ([in2mm (1), in2mm (0), 0])
            square ([in2mm (2.5), in2mm (2.5)]);
          }
        }
      }
      translate ([0, 0, 0])
        circle (d = stud_dia);
    }
  }
}

module throttle_bracket () {
  union () {
    carb_base ();
    cable_bracket ();
  }
}

linear_extrude (height = in2mm (frac (3, 32)), center = true, convexity = 10, twist = 0)
  throttle_bracket ();

