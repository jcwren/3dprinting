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

difference () {
  union () {
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