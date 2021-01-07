//                  3/4    5/8   9/16    1/2   7/16    3/8   5/16
widths        = [  6.40,  5.85,  5.25,  5.10,  4.30,  3.90,  4.00];
spacing       = [ 11,    11.5,   9,    10,     7,     8,     8];
pocket_depth  = [ 15,    14,    13,    12,    10.5,  10,     9];

base_width  = 60.0;
rail_width  =  3.0;
rail_height = 25.0;
cross_bars  =  4;

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
