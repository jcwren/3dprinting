function in2mm (v) = v * 25.4;
function f0 (x, y = 128) = in2mm (x * (1 / y));
function f1 (x, y = 128) = (f0 (x, y) / sqrt (3)) * 2;

$fn          =  64;
plate_wid    = 155;
plate_len    =  90;
plate_hgt    =   1.6;
plate_radius =   2;
stem_radius  =   1;
round_stem   =   0;
cap_stem     =   1;

stem_250 = [round_stem, f0( 1, 4) + f0(1,128), f0( 3, 8)];
stem_375 = [round_stem, f0( 3, 8) + f0(1,128), f0(35,64)];
stem_500 = [round_stem, f0( 1, 2) + f0(1,128), f0( 3, 4)];
cap_250  = [cap_stem,   f1( 7,16) + f0(1,128), f0( 1, 4)];
cap_375  = [cap_stem,   f1( 9,16) + f0(1, 64), f0( 5,16)];
cap_500  = [cap_stem,   f1( 3, 4) + f0(1, 64), f0( 3, 8)];

stems = [
  [ 15, 15, cap_500], // special
  [ 40, 15, cap_375], // special
  [ 65, 15, cap_250], // special
  [ 90, 15, stem_375],
  [115, 15, stem_375],
  [140, 15, stem_375],

  [ 15, 45, stem_375],
  [ 40, 45, stem_375],
  [ 65, 45, stem_375],
  [ 90, 45, stem_500],
  [115, 45, stem_375],
  [140, 45, stem_375],

  [ 15, 75, stem_375],
  [ 40, 75, stem_375],
  [ 65, 75, stem_375],
  [ 90, 75, stem_375],
  [115, 75, stem_500],
  [140, 75, stem_375],
];

module socket_stem_round (pos, size)
{
  stem_dia = size [1];
  stem_height = size [2];

  translate (pos) {
    cylinder (d = stem_dia, h = stem_height - (stem_dia / 2));

    translate ([0, 0, stem_height - (stem_dia / 2)])
      sphere (d = stem_dia);
  }
}

module socket_stem_cap (pos, size)
{
  cap_dia = size [1];
  cap_height = size [2];

  translate (pos) {
    difference () {
      cylinder (d = cap_dia + 1.5, h = cap_height, $fn = 6);
      cylinder (d = cap_dia, h = cap_height + 0.01, $fn = 6);
    }
  }
}

module socket_plate ()
{
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
        if (stems [i][2][0] == 0)
          socket_stem_round ([stems [i][0], stems [i][1], 0], stems [i][2]);
        else if (stems [i][2][0] == 1)
          socket_stem_cap ([stems [i][0], stems [i][1], 0], stems [i][2]);
        else
          echo ("Don't know how to handle", stems [i][2][0]);
  }
}

module cap_test ()
{
  translate ([-33, -10.5, -0.98])
    cube ([58, 21, 1]);
  socket_stem_cap ([-21, 0, 0], cap_500);
  socket_stem_cap ([  0, 0, 0], cap_375);
  socket_stem_cap ([ 17, 0, 0], cap_250);
}

socket_plate ();
