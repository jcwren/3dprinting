$fn = 64;
washer_rad       = 0.33;    // Radius of Holley carb washers
tab_width        = 0.65;    // Width of tab with guide hole
tab_length       = 1.25;    // Height of tab from bend
stud_center      = 5.16;    // Center to center distance of carb studs
stud_dia         = 0.3125;  // Diameter of carb stud
ball_stud_offset = 2.1;     // Offset from stud center to cable ball
guide_offset     = 1.0;     // Distance from bend to center of hole cable guide
guide_dia        = 0.23;    // Diameter of hole for cable guide
corner_radius    = 0.1;     // Radius of corners

tab_edge_right = -(ball_stud_offset - (tab_width / 2));
tab_edge_left  = tab_edge_right - tab_width;

function in2mm(x) = x * 25.4;

module crosshairs (x = 0, y = 0) {
  translate ([x, y, 0]) {
    rotate ([0, 0, 0])
      square ([2, .1], true);
    rotate ([0, 0, 90])
      square ([2, .1], true);
  }
}

difference () {
  union () {
    //
    //  Left tab
    //
    translate ([in2mm (0), in2mm (0), in2mm (0)]) {
      difference () {
        hull () {
          translate ([in2mm (0), in2mm (0), in2mm (0)])
            circle (r = in2mm (washer_rad));
          translate ([in2mm (0), in2mm (-(washer_rad * 2)), in2mm (0)])
            circle (r = in2mm (washer_rad));
        }
        circle (d = in2mm (stud_dia));
      }
    }
    //
    //  Right tab
    //
    translate ([in2mm (stud_center), in2mm (0), in2mm (0)]) {
      difference () {
        hull () {
          translate ([in2mm (0), in2mm (0), in2mm (0)])
            circle (r = in2mm (washer_rad));
          translate ([in2mm (0), in2mm (-(washer_rad * 2)), in2mm (0)])
            circle (r = in2mm (washer_rad));
        }
        circle (d = in2mm (stud_dia));
      }
    }
    //
    //  Horizontal bar
    //
    translate ([in2mm ((stud_center + washer_rad)), in2mm (-washer_rad), in2mm (0)]) {
      hull () {
        translate ([in2mm (-corner_radius), in2mm (0), in2mm (0)])
          circle (r = in2mm (corner_radius));
        translate ([in2mm (-corner_radius), in2mm (-((washer_rad * 2) - corner_radius)), in2mm (0)])
          circle (r = in2mm (corner_radius));
        translate ([in2mm (-((stud_center - tab_edge_left) - corner_radius)), in2mm (0), in2mm (0)])
          circle (r = in2mm (corner_radius));
        translate ([in2mm (-((stud_center - tab_edge_left) - corner_radius)), in2mm (-((washer_rad * 2) - corner_radius)), in2mm (0)])
          circle (r = in2mm (corner_radius));
      }  
    }
    //
    //  Tab
    //
    translate ([in2mm (tab_edge_right), in2mm (-washer_rad), in2mm (0)]) {
      difference () {
        hull () {
          translate ([in2mm (0), in2mm (0), in2mm (0)])
            circle (r = in2mm (corner_radius));
          translate ([in2mm (-tab_width), in2mm (0), in2mm (0)])
            circle (r = in2mm (corner_radius));
          translate ([in2mm (0), in2mm (-(tab_length + (washer_rad * 2))), in2mm (0)])
            circle (r = in2mm (corner_radius));
          translate ([in2mm (-tab_width), in2mm (-(tab_length + (washer_rad * 2))), in2mm (0)])
            circle (r = in2mm (corner_radius));
        }
        translate ([in2mm (-tab_width / 2), in2mm (-(guide_offset + (washer_rad * 2))), in2mm (0)])
          circle (d = in2mm (guide_dia));
      }
    }
  }
}

//
//  Don't like doing it this way, but the crosshairs get differenced out if they're
//  placed when the circles are drawn.  And why do I have to add 0.13" to get the
//  last crosshair correctly places?
//
crosshairs (0, 0);
crosshairs (in2mm (stud_center), 0);
crosshairs (-in2mm (2.1), -in2mm (ball_stud_offset - (guide_dia) / 2) - 0.13);
