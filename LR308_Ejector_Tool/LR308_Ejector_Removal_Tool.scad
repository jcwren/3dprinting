sides=360;              // Circles have 360 sides, not 16
holder_width=28;        // Total width
holder_height=26;       // Total height
holder_length=40;       // Total length, WITHOUT waist support
holder_wall=3;          // Thickness of sidewalls
holder_end=10;          // Thickness of bolt and nut walls
holder_floor=5;         // Thickness of floor
bolt_end_thickness=8.6; // Thickness of LR-308 bolt wall
bolt_dia=16.66;         // Diameter of LR-10 bolt body measured just behind locking lugs
bolt_face_dia=11.75;    // Diameter of face of bolt, less 0.2 for ABS expansion
bolt_h_offset=5;        // Horizontal offset
bolt_v_offset=17;       // Vertical offset
ejector_pin_offset=5;   // Pin is 5mm back from the back of the lugs, and 5mm from the edge
ejector_pin_dia=4;      // Size of hole for ejector pin to fall through
waist_dia=9.5;          // Diameter at narrowest part of waist
waist_offset=39.6;      // From back of lugs to edge of waist
waist_support_wall=6.15;// Thickness of waist support on holder
nut_end_thickness=10;   // Thickness of nut wall
nut_dia=14.7;           // 3/8-18 nut diameter (measure across points, not flats!)
nut_thickness=7.1;      // 3/8-18 nut thickness
nut_h_offset=13;        // Horizontal offset to center with firing pin hole
screw_dia=7.7;          // Outside diameter of 3/8-18 screw threads

//
// Nut diameter has 0.4mm added, nut thickness has 0.2mm added, and
// screw thread diameter has 0.4mm added to allow for ABS shrinkage.
// Extra 0.1 and 0.2 values are so that preview rendering won't do
// that annoying moire' pattern.
//

//
// May need to tweak the inner diameter of the cap by changing the
// "+ 0" below to "+ 0.1", "- 0.1", etc. Four different bolts all
// required different size inner diameters to fit snuggly. 7.7mm
// fit the 3/8" x 1" x 18 thumbscrew best.
//
module cap (x=0, y=0) {
  translate ([x, y, 0])
    difference () {
      cylinder (d=bolt_face_dia, h=10, $fn=sides);
      translate ([0, 0, 3])
        cylinder (d=screw_dia + 0, h=8, $fn=sides);
    }
}

module no6_screw (x, y, z=0)
{
  translate ([x, y, z])
    cylinder (h=10, d=4.0, $fn=sides, center=true);
  translate ([x, y, z+5])
    cylinder (h=4.5, d=7.2, $fn=sides, center=true);
}

module holder (x=0, y=0) {
  translate ([x, y, 0]) {
    difference () {
      union () {
        translate ([0, 0, 0])
          cube ([holder_width, bolt_end_thickness, holder_height]); // Bolt wall
        translate ([0, holder_length - holder_end, 0])
          cube ([holder_width, nut_end_thickness, holder_height]);  // Nut wall
        translate ([0, 0, 0])
          cube ([holder_wall, holder_length, holder_height]);       // Side wall
        translate ([holder_width-holder_wall, 0, 0])
          cube ([holder_wall, holder_length, holder_height]);       // Side wall
        translate ([0, 0, 0])
          cube ([holder_width, holder_length, holder_floor]);       // Floor
      }

      no6_screw (holder_width / 2, (holder_length - nut_end_thickness) - 6);

      translate ([bolt_h_offset + (bolt_dia / 2), bolt_end_thickness + 0.1, bolt_v_offset])
        rotate ([90, 0, 0])
          cylinder (d=bolt_dia, h=bolt_end_thickness + 0.2, $fn=sides);                     // Bolt cutout
      translate ([bolt_h_offset, -0.1, bolt_v_offset])
        cube ([bolt_dia, bolt_end_thickness + 0.2, (holder_height - bolt_v_offset) + 0.1]); // Bolt cutout

      translate ([nut_h_offset, (holder_length - holder_end) + nut_thickness - 0.1, bolt_v_offset])
        rotate ([90, 30, 0])
          cylinder (d=nut_dia, h=nut_thickness, $fn=6);                 // 3/8-18 nut
      translate ([nut_h_offset, holder_length + 0.1, bolt_v_offset])
        rotate ([90, 0, 0])
          cylinder (d=screw_dia + 0.4, h=holder_end + 0.2, $fn=sides);  // 3/8-18 screw hole plus some clearance

      translate ([(bolt_h_offset + bolt_dia) - ejector_pin_offset, bolt_end_thickness - ejector_pin_offset, -0.1])
        rotate ([0, 0, 90])
          cylinder (d=ejector_pin_dia, h=holder_height, $fn=sides); // Ejector pin hole
    }

    //
    //  Fixes bolt cutout to account for flat space on bolt
    //
    translate ([bolt_h_offset, 0, 12])
      cube ([1, bolt_end_thickness, holder_height - 12]);
    translate ([holder_wall, 0, 0])
      cube ([1.5, holder_length, holder_height]);

    //
    //  Waist support
    //
    difference () {
      translate ([0, -(waist_offset - bolt_end_thickness), 0])
        cube ([holder_width, waist_offset - bolt_end_thickness, holder_floor]);
      no6_screw (holder_width / 2, -23, -1);
    }

    difference () {
      fudge=0.4;
      translate ([0, -((waist_offset - bolt_end_thickness) + waist_support_wall), 0])
        cube ([holder_width, waist_support_wall, bolt_v_offset + fudge]);
      translate ([bolt_h_offset + (bolt_dia / 2), -((waist_offset - bolt_end_thickness) + (waist_support_wall / 2)), bolt_v_offset + fudge])
        rotate ([270, 0, 0])
          difference() {
            cylinder (r=(waist_dia + waist_support_wall) / 2, h=waist_dia + 0.1, center=true);
            rotate_extrude (angle=180, convexity=10, $fn=sides)
              translate ([(waist_dia + waist_support_wall) / 2, 0, 0])
                circle (d=waist_support_wall, $fn=sides);
          }
    }
  }
}

holder ();
cap (45, 0);
cube ([45, 0.01, 0.01]);
