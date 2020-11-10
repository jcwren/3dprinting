include <rounded_corners.scad>

function in2mm (v) = v * 25.4;
function sumx (v, i, s = 0) = (i == s ? v [i][0] : v [i][0] + sumx (v, i - 1, s));

bw      = in2mm (6.0);   // Width of box
bd      = in2mm (2.5);   // Depth of box
bh      = in2mm (4.25);  // Height of box
margin  = in2mm (0.25);  // Minimum distance from hole to edge of box

scissors_1   = [in2mm ((1 / 64) * 26), in2mm ((1 / 64) * 57), in2mm (4.0)];
scissors_2   = [in2mm ((1 / 64) * 17), in2mm ((1 / 64) * 50), in2mm (4.0)];
brush        = [in2mm ((1 / 64) * 44), in2mm ((1 / 64) * 58), in2mm (4.0)];
desolder     = [in2mm ((1 / 64) * 53), in2mm ((1 / 64) * 53), in2mm (4.0)];
screwdriver  = [in2mm ((1 / 16) *  8), in2mm ((1 / 16) *  8), in2mm (3.0)];

holes_table = [scissors_1, scissors_2, brush, desolder, screwdriver ];

spacing = (bw - sumx (holes_table, len (holes_table) - 1)) / (len (holes_table) + 1);

loc_table = [[(spacing *  1) + 0,                     (bd - holes_table [0][1]) / 2, (bh - holes_table [0][2]) + 0.01], //  0
             [(spacing *  2) + sumx (holes_table, 0), (bd - holes_table [1][1]) / 2, (bh - holes_table [1][2]) + 0.01], //  0 + 3
             [(spacing *  3) + sumx (holes_table, 1), (bd - holes_table [2][1]) / 2, (bh - holes_table [2][2]) + 0.01], //  3 + 3
             [(spacing *  4) + sumx (holes_table, 2), (bd - holes_table [3][1]) / 2, (bh - holes_table [3][2]) + 0.01], //  6 + 8
             [(spacing *  5) + sumx (holes_table, 3), (bd - holes_table [4][1]) / 2, (bh - holes_table [4][2]) + 0.01],
            ];

difference () {
  roundedcube ([bw, bd, bh], radius = in2mm (0.125), apply_to="zmax");

  for (i = [0 : len (holes_table) - 1]) {
    translate (loc_table [i])
      cube (holes_table [i]);
  }
}
