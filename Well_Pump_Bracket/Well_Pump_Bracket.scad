//
//  Box 0,0 reference is with the box with the long side left to right and
//  the small diameter mounting boss in the lower left corner. 
//

mtg_hole_x_ctc = 108.000; // No actual boss on the right side, but rests on edge of large ring
mtg_hole_y_ctc =  98.000; // Distance to boss in upper left corner
mtg_hole_dia   =   3.500; // Diameter of mounting boss screw hole
plate_overhang =   5.000; // Plate overhangs mounting bosses by 5mm
plate_z        =   3.000; // Thickness of plate
opto_hole_size =   2.759; // 4/40 screw diameter

plate_mtg_holes = [[0, 0], [0, 98], [55, 5], [55, 98]];
opto_mtg_holes  = [[0, 0], [40, 3.6]];
clip_locations  = [[0, 0, 0], [0, 24.5, 0]];

module clip (rot = 0) {
  x = 3;
  y = 3;
  total_h = 6;
  slot_h = 1.6;
  slot_above_z = 4.0;
  
  rotate (rot)
    difference () {
      translate ([0, 0, total_h / 2])
        cube ([x, y, total_h], center = true);
      translate ([slot_h / 2, -0.01, slot_above_z])
        cube ([slot_h, y + 0.03, slot_h], center = true);
    }
}

module clips () {
  translate ([5, 13, plate_z])
    for (i = [0:len (clip_locations) - 1])
      translate (clip_locations [i])
        clip ();
}

module rj_45 () {
  rj45_x = 5.0;
  rj45_y = 18.5;
  rj45_z = 14.5;
  wall = 5;
  height_above_z = 4 + 1.6;
  
  translate ([5, 13, plate_z])
    translate ([93, 9.75 - wall, 0])
      difference () {
        translate ([0, 0, 0])
          cube ([wall, wall + rj45_y + wall, height_above_z + rj45_z + wall]);
        translate ([-0.01, wall, height_above_z])
          cube ([wall + 0.02, rj45_y, rj45_z]);
      }
}

module plate () {
  radius = 2;
  x_org = -(plate_overhang - radius);
  y_org = -(plate_overhang - radius);
  x_max = mtg_hole_x_ctc + (plate_overhang - radius);
  y_max = mtg_hole_y_ctc + (plate_overhang - radius);
  corners = [[x_org, y_org, 0], [x_org, y_max, 0], [x_max, y_org, 0], [x_max, y_max, 0]];
  
  linear_extrude (height = plate_z)
    hull ()
      for (i = [0:len (corners) - 1])
        translate (corners [i])
          circle (r = radius, $fn = 180);
}

module place_holes (hole_array, offset_x = 0, offset_y = 0, hole_dia = 1) {
  translate ([0, 0, -0.01])
    for (i = [0:len (hole_array) - 1])
      translate ([offset_x + hole_array [i][0], offset_y + hole_array [i][1], 0])
        linear_extrude (height = plate_z + 0.02)
          circle (d = hole_dia, $fn = 180);
}

module mtg_holes () {
  place_holes (plate_mtg_holes, 0, 0, mtg_hole_dia);
  place_holes (opto_mtg_holes, 10, 70, opto_hole_size);
}

difference () {
  plate ();
  mtg_holes ();
}

clips ();
rj_45 ();