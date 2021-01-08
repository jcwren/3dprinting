//                   22     21     19     18     17     15     14     13     12     11     10      9      8      7      6
widths        = [  8.95,  8.75,  8.50,  8.55,  7.90,  7.35,  6.75,  6.40,  5.75,  4.05,  3.65,  3.40,  2.85,  2.75,  2.75];
spacing       = [ 11,    11,     8,    12,     8,     9,     8,     8,     8,     7,     7,     7,     7,     7,     7];
pocket_depth  = [ 18,    16,    15,    14,    14,    13,    12,    11,    10,     9,     9,     8,     7,     7,     7];

base_width   = 65.0;
rail_width   =  5.0;
rail_height  = 30.0;
cross_height =  3.0;
cross_bars   =  4;

function sum (v, i = 0, r = 0) = i < len (v) ? sum (v, i + 1, r + v [i]) : r;
function subarray (list, begin = 0, end = -1) = [
  let (end = end < 0 ? len (list) : end)
    for (i = [begin : 1 : end - 1])
      list [i]
];

length = sum (widths) + sum (spacing) + 16;

difference () {
  union () {
    for (i = [0 : cross_bars - 1])
      translate ([i == 0 ? 0 : ((length / (cross_bars - 1)) * i) - (i == (cross_bars - 1) ? 8 : 4), 0, 0])
        cube ([8, base_width, cross_height]);
    translate ([0, 0, 0])
      cube ([length, rail_width, rail_height]);
    translate ([0, base_width - rail_width, 0])
      cube ([length, rail_width, rail_height]);
  }

  for (i = [0 : len (widths) - 1]) {
    translate ([21 + sum (subarray (spacing, 0, i)) + sum (subarray (widths, 0, i)), -0.01, rail_height - pocket_depth [i]])
      rotate ([0, 315, 0])
        cube ([widths [i], base_width + 0.02, 25]);
  }
}
