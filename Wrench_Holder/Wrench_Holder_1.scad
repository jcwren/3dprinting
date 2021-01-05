widths        = [  8.77,  8.75,  7.91,  7.61,  6.85,  4.53,  4.10,  3.75,  3.31,  3.22,  2.85];
spacing       = [ 11,    11,    11,    11,     8,    10,     7,     8,     8,     7,     7];
pocket_depth  = [ 15,    14,    13,    12,    11,    10,     9,     8,     7,     7,     7];
imprint_width = [111,   109,    98,    87,    77,    66,    55,    55,    55,    55,    55];

base_width  = 75.0;
rail_width  =  3.0;
rail_height = 25.0;

function sum (v, i = 0, r = 0) = i < len (v) ? sum (v, i + 1, r + v [i]) : r;
function subarray (list, begin = 0, end = -1) = [
  let (end = end < 0 ? len (list) : end)
    for (i = [begin : 1 : end - 1])
      list [i]
];

length = sum (widths) + sum (spacing) + 13;

difference () {
  union () {
    for (i = [0 : 3])
      translate ([i == 0 ? 0 : ((length / 3) * i) - (i == 3 ? 8 : 4), 0, 0])
        cube ([8, base_width, 1.5]);
    translate ([0, 0, 0])
      cube ([length, rail_width, rail_height]);
    translate ([0, base_width - rail_width, 0])
      cube ([length, rail_width, rail_height]);
  }

  for (i = [0 : len (widths) - 1]) {
    translate ([18 + sum (subarray (spacing, 0, i)) + sum (subarray (widths, 0, i)), -0.01, rail_height - pocket_depth [i]])
      rotate ([0, 315, 0])
        cube ([widths [i], base_width + 0.02, 25]);
  }
}
