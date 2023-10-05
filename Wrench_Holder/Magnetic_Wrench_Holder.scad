$fn = 90;

//
//  Print in red for imperial wrenchs, grey for metric
//

num_slots     = 7;    // How many wrenchs this print will hold
width         = 30;   // Width between two peaks
depth         = 20;   // Depth of holder (where wrench handle sits)
height        = 38;   // Height of holder
top_radius    = 1.5;  // Radius of top of holder
bottom_radius = 2;    // Radius of area handle of wrench sits in
magic         = 2.15; // Needed to make wedge cutout align, somehow tied to top_radius
magnet_hgt    = 3;    // Height of 12mmx3mm magnet
magnet_dia    = 12;   // Diameter of 12mmx3mm magnet

module holder (x, z, y, top_radius, bottom_radius) {
  rotate ([90, 0, 0])
    difference () {
    linear_extrude (height = z)
      difference () {
        union () {
          //
          //  Left & right arms
          //
          for (sgn = [-1, 1])
            hull () {
              translate ([sgn * (x / 2), y - top_radius, 0])
                circle (r = top_radius);
              translate ([sgn * (x / 2), top_radius, 0])
                circle (r = top_radius);
              translate ([sgn * (bottom_radius / 2), top_radius, 0])
                circle (r = top_radius);
            }
          //
          //  Bottom
          //
          translate ([-((x / 2) + top_radius), 0, 0])
            square ([x + (top_radius * 2), y - (top_radius * 2)]);
        }
        //
        //  Wedge to remove
        //
        hull () {
          translate ([0, 6 + bottom_radius, 0])
            circle (r = bottom_radius);
          for (sgn = [-1, 1])
            translate ([sgn * ((x / 2) - (top_radius * magic)), y - (top_radius / 1), 0])
              circle (r = top_radius);
        }
        translate ([-((x / 2) + top_radius + 0.01), 0, 0])
          square ([top_radius + 0.01, y + top_radius]);
        translate ([(x / 2), 0, 0])
          square ([top_radius + 0.01, y + top_radius]);
      }
      rotate ([90, 0, 0])
        translate ([0, depth / 2, -(magnet_hgt - 0.01)])
          cylinder (d = magnet_dia, h = magnet_hgt);
    }
}

for (i = [0 : num_slots - 1])
  translate ([(width / 2) + (width * i), 0, 0])
    holder (width, depth, height, top_radius, bottom_radius);
