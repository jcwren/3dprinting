//               11/16  11/16    5/8    5/8    5/8   9/16    1/2    1/2   7/16   7/16    3/8    3/8   5/16    1/4
widths        = [ 8.63,  8.63,  8.16,  8.16,  8.16,  6.88,  5.13,  5.13,  4.63,  4.63,  4.01,  4.01,  3.08,  2.89];
spacing       = [11,    11,    11,    11,    11,     8,    10,    10,     7,     7,     8,     8,     7,     7];
pocket_depth  = [13,    13,    12,    12,    12,    11,    10,    10,     9,     9,     8,     8,     7,     7];
imprint_width = [98,    98,    87,    87,    87,    77,    66,    66,    55,    55,    55,    55,    55,    55];

base_width  = 75.0;
rail_width  =  3.0;
rail_height = 25.0;
cross_bars  =  5;

function sum (v, i = 0, r = 0) = i < len (v) ? sum (v, i + 1, r + v [i]) : r;
function subarray (list, begin = 0, end = -1) = [
  let (end = end < 0 ? len (list) : end)
    for (i = [begin : 1 : end - 1])
      list [i]
];

length = sum (widths) + sum (spacing) + 13;

difference () {
  union () {
    for (i = [0 : cross_bars - 1])
      translate ([i == 0 ? 0 : ((length / (cross_bars - 1)) * i) - (i == (cross_bars - 1) ? 8 : 4), 0, 0])
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
