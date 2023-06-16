//
//  Box 0,0 reference is with the box with the long side left to right and
//  the small diameter mounting boss in the lower left corner.
//

plate_x = 108.000; // No actual boss on the right side, but rests on edge of large ring
plate_y =  44.000; // Distance to boss in upper left corner
plate_z =   2.000; // Thickness of plate

clip_locations  = [[0, 0, 0], [0, 24.5, 0]];

module clip (rot = 0) {
  x = 5;
  y = 4;
  total_h = 9;
  slot_h = 2;
  slot_above_z = 4.0;

  rotate (rot)
    difference () {
      translate ([0, 0, total_h / 2])
        cube ([x, y, total_h], center = true);
      translate ([x / 2, -0.01, slot_above_z + (slot_h / 2)])
        cube ([x, y + 0.03, slot_h], center = true);
    }
}

module clips () {
  for (i = [0:len (clip_locations) - 1])
    translate (clip_locations [i])
      clip ();
}

module side_blocks () {
  translate ([17, -1.75, 0]) {
    translate ([0, -3, 0])
      cube ([5, 3, 6]);
    translate ([0, 28, 0])
      cube ([5, 3, 6]);
  }
}

module rj45 () {
  rj45_y = 18.5;
  rj45_z = 14.5;
  wall = 5;
  height_above_z = 4 + 1.6;

  translate ([95, 9.75 - 1.75 - wall, 0])
    difference () {
      translate ([0, 0, 0])
        cube ([wall, wall + rj45_y + wall, height_above_z + rj45_z + wall]);
      translate ([-0.01, wall, height_above_z])
        cube ([wall + 0.02, rj45_y, rj45_z]);
    }
}

module plate (mtg_ears = true) {
  radius = 2;
  o = 4;
  x_org = radius - (mtg_ears ? 12.5 : 0);
  y_org = radius;
  x_max = plate_x + (mtg_ears ? 12.5 : 0);
  y_max = plate_y;
  corners = [[x_org, y_org, 0], [x_org, y_max, 0], [x_max, y_org, 0], [x_max, y_max, 0]];
  holes = [[x_org + o, y_org + o, -0.01], [x_org + o, y_max - o, -0.01], [x_max - o, y_org + o, -0.01], [x_max - o, y_max - o, -0.01]];

  difference () {
    linear_extrude (height = plate_z)
      hull ()
        for (i = [0:len (corners) - 1])
          translate (corners [i])
            circle (r = radius, $fn = 180);
    if (mtg_ears)
      for (i = [0:len (holes) - 1])
        translate (holes [i])
          cylinder (d = 4.5, h = plate_z + 0.02, $fn = 180);
  }
}

module cover_posts (adjust = 0) {
  radius = 2;
  x_org = radius - adjust;
  y_org = radius - adjust;
  x_max = plate_x + adjust;
  y_max = plate_y + adjust;
  corners = [[x_org, y_org, 0], [x_org, y_max, 0], [x_max, y_org, 0], [x_max, y_max, 0]];

  linear_extrude (height = plate_z + 4 + 1.6 + 14.5 + 5 + (adjust ? 1 : 0))
    for (i = [0:len (corners) - 1])
      translate (corners [i])
        circle (r = radius + adjust, $fn = 180);
}

module esp32_poe_iso_mount () {
  translate ([8, 5, plate_z]) {
    clips ();
    side_blocks ();
    rj45 ();
  }
}

module base_plate () {
  plate ();
  cover_posts (0);
  color ("blue")
    esp32_poe_iso_mount ();
}

module cover () {
  difference () {
    difference () {
      translate ([0, 0, 0])
        hull ()
          cover_posts (0.75);
      translate ([0, 0, -0.01])
        hull ()
          cover_posts (0);
    }
    translate ([8, 5, plate_z])
      translate ([95, 9.75 - 1.75 - 5, 0])
        translate ([-0.01, 5, 4 + 1.6])
          cube ([15 + 0.02, 18.5, 14.5]);
  }
}

preview = false;
render_base = true;
render_cover = true;

if (preview) {
  color ("blue", 0.9)
    base_plate ();
  color ("gold", 0.6)
    cover ();
} else {
  if (render_base)
    base_plate ();
  if (render_cover)
    rotate ([180, 0, 0])
      translate ([0, render_base ? -100 : 0, -28.1])
        difference () {
          translate ([0, 0, 0])
            cover ();
          translate ([0, 0, -0.01])
            plate ();
        }
}
