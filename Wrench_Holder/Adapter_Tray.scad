function in2mm (v) = v * 25.4;
function f0 (x, y = 128) = in2mm (x * (1 / y));

$fn          =  64;
plate_wid    = 115;
plate_len    =  90;
plate_hgt    =   1.6;
plate_radius =   2;
stem_radius  =   1;
square_stems =   0;

//          Round stems                       Square stems  
stem_250 = [[f0(1,4) + f0(1,128), f0( 3, 8)], [6.35,  7]];
stem_375 = [[f0(3,8) + f0(1,128), f0(35,64)], [9.50,  9]];
stem_500 = [[f0(1,2) + f0(1,128), f0( 3, 4)], [12.65, 14]];

stems = [
  [ 20, 10, stem_250],
  [ 20, 25, stem_250],
  [ 20, 45, stem_375],
  [ 20, 75, stem_500],
  [ 50, 15, stem_500],
  [ 50, 45, stem_500],
  [ 50, 75, stem_500],
  [ 75, 15, stem_375],
  [ 75, 45, stem_375],
  [ 75, 75, stem_375],
  [100, 45, stem_250],
  [100, 75, stem_375]
];  

module socket_stem_square (pos, size)
{
  translate (pos) {
    hf = (size [0] / 2) - stem_radius;
    hgt = size [1];
    
    hull () {
      for (x = [-1, 1])
        for (y = [-1, 1])
          translate ([hf * x, hf * y, 0]) {
            cylinder (r = stem_radius, h = 1);
            translate ([0, 0, hgt])
              sphere (r = stem_radius);
          }
    }
  }
}

module socket_stem_round (pos, size)
{
  stem_dia = size [0];
  stem_height = size [1];
  
  translate (pos) {
    cylinder (d = stem_dia, h = stem_height - (stem_dia / 2));
    
    translate ([0, 0, stem_height - (stem_dia / 2)])
      sphere (d = stem_dia);
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
        if (square_stems == 1)
          socket_stem_square ([stems [i][0], stems [i][1], 0], stems [i][2][1]);
        else
          socket_stem_round ([stems [i][0], stems [i][1], 0], stems [i][2][0]);
  }
}

socket_plate ();
