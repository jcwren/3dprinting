//
// Phone (P_* variables):
//   162mm wide
//    11mm thick
//    40mm tall (to USB jack)
//     5mm inset (case to screen)
//
// Holder (c_* variables):
//   10mm thick base
//    3mm walls
//
p_width  = 162.0; // Phone width (including case)
p_thick  =  11.1; // Phone thickness (including case)
p_height =  30.0; // Phone height (including case, up to USB jack)
p_bezel  =   4.0; // Edge of case to phone screen distance

h_thick  =  10.0; // Thickness of base (not including bezel)
h_walls  =   3.0; // Thickness of bezel walls

nut_d    = 12.85; // Diameter of 1/4-20 nut
nut_h    =  5.00; // Height of 1/4-20 nut

pin_d    =  4.3;  // Index pin diameter
pin_h    =  4.0;  // Index pin height
pin_off  = 14.0;  // Index pin offset from center of 1/4-20 nut

module phone_holder_side (x = 0) {
  translate ([x, 0, h_thick]) {
    difference () {
      translate ([0, 0, 0])
        cube ([p_bezel + h_walls, h_walls + p_thick + h_walls, p_height]);
      translate ([h_walls, h_walls, 0])
        cube ([p_bezel, p_thick, p_height]);
    }
    translate ([p_bezel + h_walls, h_walls + p_thick, 0])
      cube ([h_walls, h_walls, p_height]);
  }
}

module phone_holder_left_side (x = 0) {
  phone_holder_side (x);
}

module phone_holder_right_side (x = 0) {
  mirror ([1, 0, 0])
    phone_holder_side (-((h_walls * 2) + x));
}

module phone_holder_base () {
  difference () {
    translate ([0, 0, 0])
      cube ([(h_walls * 2) + p_width, (h_walls * 2) + p_thick, h_thick + p_bezel]);
    translate ([0, h_walls, h_thick])
      cube ([(h_walls * 2) + p_width, p_thick, p_bezel]);
  }
}

module phone_holder () {
  difference () {
    union () {
      phone_holder_base ();
      phone_holder_left_side (0);
      phone_holder_right_side (p_width);
    }
    translate ([((h_walls * 2) + p_width) / 2, ((h_walls * 2) + p_thick) / 2, 0])
      cylinder (h = nut_h, d = nut_d, $fn = 6);
    translate ([(((h_walls * 2) + p_width) / 2) + pin_off, ((h_walls * 2) + p_thick) / 2, 0])
      cylinder (h = pin_h, d = pin_d, $fn = 360);
  }
}

union () {
  phone_holder ();
  
  translate ([-7, -7, 0])
    cube ([14, 14 +  (h_walls * 2) + p_thick, 0.5]);
  translate ([((h_walls * 2) + p_width) - 7, -7, 0])
    cube ([14, 14 +  (h_walls * 2) + p_thick, 0.5]);
}