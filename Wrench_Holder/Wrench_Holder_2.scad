width = [10, 10,  8,  8,  8,  7,  6, 5.5, 5.5,  5,  5];
space = [12, 12, 11, 11, 10, 10,  9,   9,   9,  8,  8];
vrtcl = [ 0,  0,  1,  1,  1,  2,  3,   3,   3,  4,  4];

function sum (v, i = 0, r = 0) = i < len (v) ? sum (v, i + 1, r + v [i]) : r;
function reverse (list) = [for (i = [len (list) - 1: -1 : 0]) list [i]];
function subarray (list, begin = 0, end = -1) = [
  let (end = end < 0 ? len (list) : end)
    for (i = [begin : 1 : end - 1])
      list [i]
];

rwidth = reverse (width);
rspace = reverse (space);

module base () {
  translate ([0, 0, 0])
    cube ([195, 70, 2]);
  translate ([0, 0, 0])
    cube ([195, 5, 20]);
  translate ([0, 65, 0])
    cube ([195, 5, 20]);
}

difference () {
  base ();

  for (i = [0 : len (width) - 1]) {
    translate ([15 + sum (subarray (space, 0, i)) + sum (subarray (width, 0, i)), -0.01, 8 + vrtcl [i]])
      rotate ([0, 315, 0])
        cube ([width [i], 70.02, 25]);
  }
}
