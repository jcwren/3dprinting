$fn = 90;

function in2mm (v) = v * 25.4;
function sum (v, i = 0, r = 0) = i < len (v) ? sum (v, i + 1, r + v [i]) : r;
function f0 (x, y = 128) = in2mm (x * (1 / y));
function f1 (x, y = 128) = in2mm (1 + (x * (1 / y)));
function subarray (list, begin = 0, end = -1) = [
  let (end = end < 0 ? len (list) : end)
    for (i = [begin : 1 : end - 1])
      list [i]
];

//           1-1/16"  1-1/8"      1"  15/16"    7/8"
sockets_od = [f1(64), f1(53), f1(43), f1(33), f1(25)];
padding = f0(1,16);
stem_dia = f0(1,2) + f0(1,64);
stem_height = f0(1,2);
plate_thickness = 2.00;

pos = [for (i = [1 : len (sockets_od) - 1]) (sockets_od [i - 1] / 2) + (sockets_od [i] / 2) + padding];

for (i = [0 : len (sockets_od) - 1]) {
  translate ([0,  sum (subarray (pos, 0, i)), plate_thickness]) {
    cylinder (d = stem_dia, h = stem_height - (stem_dia / 2));

    translate ([0, 0, stem_height - (stem_dia / 2)])
      sphere (d = stem_dia);
  }
}

linear_extrude (height = plate_thickness) {
  hull () {
    translate ([0, 0, 0])
      circle (d = sockets_od [0] + (padding * 2));
    translate ([0, sum (pos), 0])
      circle (d = sockets_od [len (sockets_od) - 1] + (padding * 2));
  }
}
