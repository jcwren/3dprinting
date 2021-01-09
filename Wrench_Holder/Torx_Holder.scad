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

sockets38_od = [f0(96), f0(96), f0(96), f0(96), f0(96)];
sockets14_od = [f0(64), f0(64), f0(64), f0(64), f0(64), f0(64)];
stem38_dia = f0(3,8) + f0(1,128);
stem14_dia = f0(1,4) + f0(1,128);
stem38_height = f0(7,16);
stem14_height = f0(5,16);
padding = f0(1,16);
plate_thickness = 2.00;

pos38 = [for (i = [1 : len (sockets38_od) - 1]) (sockets38_od [i - 1] / 2) + (sockets38_od [i] / 2) + padding];
pos14 = [for (i = [0 : len (sockets38_od)]) sum (pos38) / (len (pos38) + 1)];

for (i = [0 : len (sockets38_od) - 1]) {
  translate ([0,  sum (subarray (pos38, 0, i)), plate_thickness]) {
    cylinder (d = stem38_dia, h = stem38_height - (stem38_dia / 2));

    translate ([0, 0, stem38_height - (stem38_dia / 2)])
      sphere (d = stem38_dia);
  }
}

for (i = [0 : len (sockets14_od) - 1]) {
  translate ([in2mm (1),  sum (subarray (pos14, 0, i)), plate_thickness]) {
    cylinder (d = stem14_dia, h = stem14_height - (stem14_dia / 2));

    translate ([0, 0, stem14_height - (stem14_dia / 2)])
      sphere (d = stem14_dia);
  }
}

linear_extrude (height = plate_thickness) {
  hull () {
    for (x = [in2mm (0), in2mm (1)]) {
      translate ([x, 0, 0])
        circle (d = sockets38_od [0] + (padding * 2));
      translate ([x, sum (pos38), 0])
        circle (d = sockets38_od [len (sockets38_od) - 1] + (padding * 2));
    }
  }
}
