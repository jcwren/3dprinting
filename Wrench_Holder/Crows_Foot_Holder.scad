function in2mm (v) = v * 25.4;
function vin2mm (v) = [in2mm (v [0]), in2mm (v [1]), in2mm (v [2])];
function infrac (a, b, c) = a + (b * (1 / c));
function sum (v, l = -1, o = 0, i = 0, r = 0) = i < l ? sum (v, l, o, i + 1, r + v [i][o]) : r;

wall   = 0.08;
cube_x = 0;
cube_y = 1;
cube_h = 2;

v = [
  [infrac (1,  0, 16), 0.43, 0.82], // 1" 
  [infrac (0,  7,  8), 0.41, 0.72], // 7/8"
  [infrac (0, 13, 16), 0.37, 0.62], // 13/16"
  [infrac (0,  3,  4), 0.36, 0.60], // 3/4"
  [infrac (0, 11, 16), 0.36, 0.58], // 11/16"
  [infrac (0,  5,  8), 0.32, 0.52], // 5/8"
  [infrac (0,  9, 16), 0.28, 0.44], // 9/16"
  [infrac (0,  1,  2), 0.28, 0.42], // 1/2"
  [infrac (0,  7, 16), 0.26, 0.40], // 7/16"
  [infrac (0,  3,  8), 0.24, 0.38], // 3/8"
];

for (i = [0 : len (v) - 1]) {
  translate (vin2mm ([-((v [i][cube_x] + 0.250) / 2), sum (v, i, cube_y) + (wall * i), 0])) {
    cube (vin2mm ([v [i][cube_x] + 0.250, wall, 0.15 + v [i][cube_h] + 0.125])); 
    translate (vin2mm ([0.125, wall, 0]))
      cube (vin2mm ([v [i][cube_x], v [i][cube_y], 0.15 + v [i][cube_h]]));
  }
}