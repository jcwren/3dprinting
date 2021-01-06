widths        = [ 11,  8.50,  8.40,  7.50];
spacing       = [  7,     7,     7,     5];
pocket_depth  = [  9,     7,   6.5,     6];

base_width  = 65.0;
rail_width  =  5.0;
rail_height = 20.0;
cross_bars  =  3;
bar_width   =  8.0;

function sum (v, i = 0, r = 0) = i < len (v) ? sum (v, i + 1, r + v [i]) : r;
function subarray (list, begin = 0, end = -1) = [
  let (end = end < 0 ? len (list) : end)
    for (i = [begin : 1 : end - 1])
      list [i]
];

length = sum (widths) + sum (spacing) + 5;

difference () {
  union () {
    for (i = [0 : cross_bars - 1])
      translate ([i == 0 ? 0 : ((length / (cross_bars - 1)) * i) - (i == (cross_bars - 1) ? bar_width : (bar_width / 2)), 0, 0])
        cube ([bar_width, base_width, 3]);
    translate ([0, 0, 0])
      cube ([length, rail_width, rail_height]);
    translate ([0, base_width - rail_width, 0])
      cube ([length, rail_width, rail_height]);
  }

  for (i = [0 : len (widths) - 1]) {
    translate ([5 + sum (subarray (spacing, 0, i)) + sum (subarray (widths, 0, i)), -0.01, rail_height - pocket_depth [i]])
      cube ([widths [i], base_width + 0.02, 25]);
  }
}
