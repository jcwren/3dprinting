function sum (v, l = -1, o = 0, i = 0, r = 0) = i < l ? sum (v, l, o, i + 1, r + v [i][o]) : r;

wall   = 3.00;
cube_x = 0;
cube_y = 1;
cube_h = 2;

v = [
//  W     T     H (Width, Thickness, Height)
  [19, 9.40, 16.0], // 19mm
  [17, 9.20, 15.5], // 17mm
  [15, 8.90, 13.0], // 15mm
  [14, 6.90, 12.5], // 14mm
  [13, 6.70, 11.5], // 13mm
  [12, 6.80, 11.0], // 12mm
  [10, 6.20,  8.5], // 10mm
];

for (i = [0 : len (v) - 1]) {
  translate ([-((v [i][cube_x] + (wall * 2)) / 2), sum (v, i, cube_y) + (wall * i), 0]) {
    cube ([v [i][cube_x] + (wall * 2), wall, 3.75 + v [i][cube_h] + wall]);

    translate ([wall, wall, 0]) {
      cube ([v [i][cube_x], v [i][cube_y], 3.75 + v [i][cube_h]]);

      if (i == len (v) - 1) {
        translate ([-wall, v [i][cube_y], 0])
          cube ([v [i][cube_x] + (wall * 2), wall, 3.75 + v [i][cube_h] + wall]);
      }
    }
  }
}
