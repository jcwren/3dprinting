include <rounded_corners.scad>

function in2mm (v) = v * 25.4;
function sumx (v, i = 0, s = 0) = (i == s ? v [i][0] : v [i][0] + sumx (v, i - 1, s));
function sumy (v, i = 0, s = 0) = (i == s ? v [i][1] : v [i][1] + sumy (v, i - 1, s));
function sumz (v, i = 0, s = 0) = (i == s ? v [i][2] : v [i][2] + sumz (v, i - 1, s));
function summ (v, i = 0, s = 0, axis = 0) = (i == s ? v [i][axis] : v [i][axis] + sumz (v, i - 1, s, axis));
function maxx (v, i = 0) = (i < len (v) - 1) ? max (v [i][0], maxx (v, i + 1)) : 0;
function maxy (v, i = 0) = (i < len (v) - 1) ? max (v [i][1], maxy (v, i + 1)) : 0;
function maxz (v, i = 0) = (i < len (v) - 1) ? max (v [i][2], maxz (v, i + 1)) : 0;
function maxm (v, i = 0, axis = 0) = (i < len (v) - 1) ? max (v [i][axis], maxz (v, i + 1, axis)) : 0;

$fn     = 360;
margin  = in2mm (0.25);  // Minimum distance from hole to edge of box

alcohol  = [in2mm (2.125), in2mm (2.125), in2mm (0.75), false];
flux     = [in2mm (1.000), in2mm (1.000), in2mm (0.75), true];
selecta  = [in2mm (0.400), in2mm (0.200), in2mm (1.50), false];
xcelite  = [in2mm (0.400), in2mm (0.200), in2mm (1.50), false];
pinch    = [in2mm (0.300), in2mm (0.120), in2mm (1.50), false];
knife    = [in2mm (0.350), in2mm (0.350), in2mm (2.25), true];
screwdrv = [in2mm (0.120), in2mm (0.120), in2mm (2.25), true];
hemos    = [in2mm (0.300), in2mm (0.300), in2mm (2.25), false];

holes_table_1 = [alcohol, flux];
holes_table_2 = [selecta, selecta, pinch, xcelite];
holes_table_3 = [knife, knife, screwdrv, hemos];
holes_table   = [holes_table_1, holes_table_2, holes_table_3];

b1 = [margin + sumx (holes_table_1, len (holes_table_1) - 1) + ((len (holes_table_1) - 1) * margin) + margin,
      margin + maxy (holes_table_1) + margin,
      margin + maxz (holes_table_1)
     ];
b2 = [margin + in2mm (0.400) + margin + in2mm (0.400) + margin,
      margin + maxy (holes_table_2) + margin,
      margin + maxz (holes_table_2)
     ];
b3 = [margin + in2mm (0.350) + margin + in2mm (0.300) + margin,
      margin + maxy (holes_table_3) + margin,
      margin + maxz (holes_table_3)
     ];
b_table = [b1, b2, b3];
by = maxy (b_table);

loc_table_1 = [[margin,                               (by - holes_table_1 [0][1]) / 2,      (b1 [2] - holes_table_1 [0][2]) + 0.01],
               [(margin *  2) + holes_table_1 [0][0], (by - margin) - holes_table_1 [1][1], (b1 [2] - holes_table_1 [1][2]) + 0.01],
              ];
loc_table_2 = [[margin,                               margin * 2,                                 (b2 [2] - holes_table_2 [0][2]) + 0.01],
               [margin,                               (by - (margin * 2)) - holes_table_2 [1][1], (b2 [2] - holes_table_2 [1][2]) + 0.01],
               [(margin *  2) + holes_table_2 [0][0], margin * 2,                                 (b2 [2] - holes_table_2 [2][2]) + 0.01],
               [(margin *  2) + holes_table_2 [0][0], (by - (margin * 2)) - holes_table_2 [3][1], (b2 [2] - holes_table_2 [3][2]) + 0.01],
              ];
loc_table_3 = [[margin,                               margin * 2,                                 (b3 [2] - holes_table_3 [0][2]) + 0.01],
               [(margin *  2) + holes_table_3 [0][0], margin * 2,                                 (b3 [2] - holes_table_3 [2][2]) + 0.01],
               [margin,                               (by - (margin * 2)) - holes_table_3 [1][1], (b3 [2] - holes_table_3 [1][2]) + 0.01],
               [(margin *  2) + holes_table_3 [0][0], (by - (margin * 2)) - holes_table_3 [3][1], (b3 [2] - holes_table_3 [3][2]) + 0.01],
              ];
loc_table   = [loc_table_1, loc_table_2, loc_table_3];

xpos_table  = [[0, 0, 0], [b1 [0], 0, 0], [b1 [0] + b2 [0], 0, 0]];
cube_table  = [[sumx (b_table, 2), by, b1 [2]], [sumx (b_table, 2, 1), by, b2 [2]], [b3 [0], by, b3 [2]]];

difference () {
  union ()
    for (x = [0 : len (xpos_table) - 1])
      translate (xpos_table [x])
        roundedcube (cube_table [x], radius = in2mm (0.125), apply_to = "zmax");

    union () {
    for (x = [0 : len (xpos_table) - 1]) {
      translate (xpos_table [x]) {
        for (i = [0 : len (holes_table [x]) - 1]) {
          translate (loc_table [x][i]) {
            if (holes_table [x][i][3] == 0) {
              cube ([holes_table [x][i][0], holes_table [x][i][1], holes_table [x][i][2]]);
            } else {
              translate ([holes_table [x][i][0] / 2, holes_table [x][i][0] / 2, 0])
                cylinder (d = holes_table [x][i][0], h = holes_table [x][i][2]);
            }
          }
        }
      }
    }
  }
}

