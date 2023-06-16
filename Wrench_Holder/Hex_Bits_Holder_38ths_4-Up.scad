function in2mm (v) = v * 25.4;
function f0 (x, y = 128) = in2mm (x * (1 / y));

$fn          =  64;
plate_wid    = 114;
plate_len    =  92;
plate_hgt    =   1.6;
plate_radius =   2;
stem_radius  =   1;
round_stem   =   0;
cap_stem     =   1;

stem_250 = [round_stem, f0( 1, 4) + f0(1,128), f0( 3, 8)];
stem_375 = [round_stem, f0( 3, 8) + f0(1,128), f0(35,64)];
stem_500 = [round_stem, f0( 1, 2) + f0(1,128), f0( 3, 4)];

stems = [
  for (y = [11.5, 31.5, 60.5, 80.5])
    for (x = [0.5 : 1 : 5.5]) [x * 19, y, stem_375]
];

module socket_stem_round (pos, size) {
  stem_dia = size [1];
  stem_height = size [2];

  translate (pos) {
    cylinder (d = stem_dia, h = stem_height - (stem_dia / 2));

    translate ([0, 0, stem_height - (stem_dia / 2)])
      sphere (d = stem_dia);
  }
}

module socket_plate () {
  union () {
    plate_x = (plate_wid / 2) - plate_radius;
    plate_y = (plate_len / 2) - plate_radius;

    hull ()
      for (x = [-1, 1])
        for (y = [-1, 1])
          translate ([plate_x * x, plate_y * y, 0])
            cylinder (h = plate_hgt, r = plate_radius);

    translate ([-plate_wid / 2, -plate_len / 2, plate_hgt - 0.02])
      for (i = [0 : len (stems) - 1])
        socket_stem_round ([stems [i][0], stems [i][1], 0], stems [i][2]);
  }
}

socket_plate ();
