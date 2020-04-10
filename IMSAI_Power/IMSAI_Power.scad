width        = 35.0;  // Width of box (x axis)
flange       = 10.0;  // Width of each flange (x axis)
breadth      = 65.0;  // Breadth of box (y axis)
height       = 35.0;  // Height of box (z axis)
wall         =  1.5;  // Thickess of walls and flanges
pem_width    = 28.0;  // Width of the cutout of the power entry module (x axis)
pem_breadth  = 48.0;  // Breadth of the cutout for the power entry module (y axis)
screw_dia    =  3.2;  // Diameter of hole for screws
screw_x_ctc  = 47.0;  // Center to center distance between screws on x axis
screw_y_ctc  = 25.0;  // Center to center distance between screws on y axis

total_width  = flange + width + flange;
center_x     = total_width / 2;
center_y     = breadth / 2;
half_wall    = wall / 2;

sides        = $preview ? 100 : 360;
render_fix   = $preview ? 0.01 : 0.00;

box_table = [
  [                flange + half_wall,            half_wall, 0 ],
  [                flange + half_wall,  breadth - half_wall, 0 ],
  [ total_width - (flange + half_wall),           half_wall, 0 ],
  [ total_width - (flange + half_wall), breadth - half_wall, 0 ]
];

flange_table = [
  [          half_wall,           half_wall, 0 ],
  [          half_wall, breadth - half_wall, 0 ],
  [ flange + half_wall,           half_wall, 0 ],
  [ flange + half_wall, breadth - half_wall, 0 ],
];

screw_table = [
  [ center_x - (screw_x_ctc / 2), center_y - screw_y_ctc, -render_fix ],
  [ center_x - (screw_x_ctc / 2), center_y +           0, -render_fix ],
  [ center_x - (screw_x_ctc / 2), center_y + screw_y_ctc, -render_fix ],
  [ center_x + (screw_x_ctc / 2), center_y - screw_y_ctc, -render_fix ],
  [ center_x + (screw_x_ctc / 2), center_y +           0, -render_fix ],
  [ center_x + (screw_x_ctc / 2), center_y + screw_y_ctc, -render_fix ],
];


module rounded_box () {
  difference () {
    union () {
      //
      //  Create the main box
      //
      hull () {
        for (i = [0 : len (box_table) - 1]) {
          translate (box_table [i]) {
            cylinder (d = wall, h = height - half_wall, $fn = sides);
            translate ([0, 0, height - half_wall])
              sphere (d = wall, $fn = sides);
          }
        }
      }

      //
      //  Add flanges
      //
      for (j = [0 : 1]) {
        translate ([j * ((flange + width) - wall), 0, 0]) {
          hull () {
            for (i = [0 : len (flange_table) - 1] ) {
              translate (flange_table [i])
                cylinder (d = wall, h = wall, $fn = sides);
            }
          }
        }
      }
    }

    //
    //  Remove interior of cube
    //
    translate ([center_x, center_y, -(wall + render_fix)])
      cube ([width - (wall * 2), breadth - (wall * 2), height * 2], center = true);

    //
    //  Remove opening for power entry module
    //
    translate ([center_x, center_y, height - (wall + 0)])
      cube ([pem_width, pem_breadth, (wall * 2) + (render_fix * 2)], center = true);

    //
    //  Create screw holes
    //
    for (i = [0 : len (screw_table) - 1]) {
      translate (screw_table [i])
        cylinder (d = screw_dia, h = wall + (render_fix * 2), $fn = sides);
    }
  }
}

module square_box () {
  difference () {
    cube ([total_width, breadth, height]);

    //
    //  Remove material so we have flanges
    //
    translate ([-render_fix, -render_fix, wall])
      cube ([flange + (render_fix * 2), breadth + (render_fix * 2), height]);
    translate ([total_width - (flange + render_fix), -render_fix, wall])
      cube ([flange + (render_fix * 2), breadth + (render_fix * 2), height]);

    //
    //  Remove interior of cube
    //
    translate ([center_x, center_y, -(wall + render_fix)])
      cube ([width - (wall * 2), breadth - (wall * 2), height * 2], center = true);

    //
    //  Remove opening for power entry module
    //
    translate ([center_x, center_y, height - (wall + 0)])
      cube ([pem_width, pem_breadth, (wall * 2) + (render_fix * 2)], center = true);

    //
    //  Make screw holes
    //
    px = [
      [ center_x - (screw_x_ctc / 2), center_y - screw_y_ctc, -render_fix ],
      [ center_x - (screw_x_ctc / 2), center_y +           0, -render_fix ],
      [ center_x - (screw_x_ctc / 2), center_y + screw_y_ctc, -render_fix ],
      [ center_x + (screw_x_ctc / 2), center_y - screw_y_ctc, -render_fix ],
      [ center_x + (screw_x_ctc / 2), center_y +           0, -render_fix ],
      [ center_x + (screw_x_ctc / 2), center_y + screw_y_ctc, -render_fix ],
    ];

    for (i = [0 : len (px) - 1]) {
      translate (px [i])
        cylinder (d = screw_dia, h = wall + (render_fix * 2), $fn = sides);
    }
  }
}

rounded_box ();
