include <rounded_corners.scad>

function in2mm (v) = v * 25.4;
function sumx (v, i, s = 0) = (i == s ? v [i][0] : v [i][0] + sumx (v, i - 1, s));

bw      = in2mm (9.0);   // Width of box
bd      = in2mm (2.5);   // Depth of box
bh      = in2mm (4.25);  // Height of box
margin  = in2mm (0.25);  // Minimum distance from hole to edge of box

hole_caliper_1   = [in2mm ((1 / 32) *  9), in2mm ((1 / 16) * 11), in2mm (4.0)];
hole_caliper_2   = [in2mm ((1 / 16) *  4), in2mm ((1 / 16) * 10), in2mm (4.0)];
hole_exxcelta    = [in2mm ((1 / 16) * 10), in2mm (2.00), in2mm (3.0)];
hole_xcelite     = [in2mm ((1 / 16) *  8), in2mm (2.00), in2mm (3.0)];
hole_xuron       = [in2mm ((1 / 16) *  8), in2mm (1.50), in2mm (3.0)];
hole_sears_short = [in2mm ((1 / 16) *  5), in2mm (0.50), in2mm (1.5)];
hole_blue        = [in2mm ((1 / 16) *  5), in2mm (0.55), in2mm (2.5)];
hole_sears_long  = [in2mm ((1 / 16) *  5), in2mm (0.50), in2mm (2.5)];
hole_stripper_1  = [in2mm ((1 / 16) *  8), in2mm (1.75), in2mm (3.0)];
hole_stripper_2  = [in2mm ((1 / 16) *  8), in2mm (1.75), in2mm (3.0)];
hole_screwdriver = [in2mm ((1 / 16) *  8), in2mm ((1 / 16) * 8), in2mm (3.0)];

holes_table = [hole_caliper_1,  hole_caliper_2,  hole_exxcelta,
               hole_xcelite,    hole_xuron,      hole_sears_short,
               hole_blue,       hole_sears_long, hole_stripper_1,
               hole_stripper_2, hole_screwdriver
              ];

spacing = (bw - sumx (holes_table, len (holes_table) - 1)) / (len (holes_table) - 1);

loc_table = [[(spacing *  1) + 0,                     (bd - margin) - holes_table [0][1], (bh - holes_table [ 0][2]) + 0.01], //  0
             [(spacing *  2) + sumx (holes_table, 0), (bd - margin) - holes_table [1][1], (bh - holes_table [ 1][2]) + 0.01], //  0 + 3
             [(spacing *  3) + sumx (holes_table, 1), (bd - holes_table [ 2][1]) / 2,     (bh - holes_table [ 2][2]) + 0.01], //  3 + 3
             [(spacing *  4) + sumx (holes_table, 2), (bd - holes_table [ 3][1]) / 2,     (bh - holes_table [ 3][2]) + 0.01], //  6 + 8
             [(spacing *  5) + sumx (holes_table, 3), (bd - holes_table [ 4][1]) / 2,     (bh - holes_table [ 4][2]) + 0.01], // 14 + 8
             [(spacing *  6) + sumx (holes_table, 4), (bd - holes_table [ 5][1]) / 2,     (bh - holes_table [ 5][2]) + 0.01], // 22 + 8
             [(spacing *  7) + sumx (holes_table, 5), (bd - holes_table [ 6][1]) / 2,     (bh - holes_table [ 6][2]) + 0.01], // 30 + 5
             [(spacing *  8) + sumx (holes_table, 6), (bd - holes_table [ 7][1]) / 2,     (bh - holes_table [ 7][2]) + 0.01], // 35 + 5
             [(spacing *  9) + sumx (holes_table, 7), (bd - holes_table [ 8][1]) / 2,     (bh - holes_table [ 8][2]) + 0.01], // 40 + 5
             [(spacing * 10) + sumx (holes_table, 8), (bd - holes_table [ 9][1]) / 2,     (bh - holes_table [ 9][2]) + 0.01], // 45 + 8
             [(spacing *  1) + in2mm ((1 / 16) * 3),  margin + in2mm (0.25),              (bh - holes_table [10][2]) + 0.01],
            ];

difference () {             
  roundedcube ([bw, bd, bh], radius = in2mm (0.125), apply_to="zmax");

  for (i = [0 : len (holes_table) - 1]) {
    translate (loc_table [i])
      cube (holes_table [i]);
  }
}