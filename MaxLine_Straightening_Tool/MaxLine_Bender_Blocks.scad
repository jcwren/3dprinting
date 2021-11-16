$fn          = 180;     // Number of fragments
pipe_od      = 25.9;    // OD of MaxLine (1" + 0.02" printing fudge factor)
lip          =  4.7625; // Extra lip on either side is 3/16"
block_x      = 30;      // Block width
block_y      = 40;      // Block depth
axle         =  9.525;  // 3/8" screw for axle
chamfer      =  2;      // Edge chamfer in mm

block_height = pipe_od + (lip * 2);

function hypotenuse (a, b) = sqrt ((a * a) + (b * b));

module block () {
  difference () {
    cube ([block_x, block_y, block_height]);
    translate ([-0.01, 0, block_height / 2])
      rotate ([0, 90, 0])
        cylinder (d = pipe_od, h = block_x + (0.01 * 2));
    translate ([block_x / 2, (block_y - (pipe_od / 2)), -0.01])
      cylinder (d = axle, h = block_height + (0.01 * 2));
  }
}

module vertical_chamfer () {
  x = [[0, -(hypotenuse (chamfer, chamfer) / 2)],
       [block_x + (hypotenuse (chamfer, chamfer) / 2), 0],
       [block_x, block_y + (hypotenuse (chamfer, chamfer) / 2)],
       [-(hypotenuse (chamfer, chamfer) / 2), block_y]
      ];

  for (i = [0:3])
    translate ([x [i][0], x [i][1], -0.01])
      rotate ([0, 0, (i * 90) + 45])
        cube ([chamfer, chamfer, block_height + 0.02]);
}

module horizontal_chamfer (z) {
  x = [[[0, -0.01, z + (hypotenuse (chamfer, chamfer) / 2)], [270, 0, 0], block_y],
       [[block_x, -0.01, z + (hypotenuse (chamfer, chamfer) / 2)], [270, 0, 0], block_y],
       [[block_x + 0.01, -(hypotenuse (chamfer, chamfer) / 2), z], [0, 270, 0], block_x],
       [[block_x + 0.01, block_y - (hypotenuse (chamfer, chamfer) / 2), z], [0, 270, 0], block_x]
      ];

  for (i = [0:3])
    translate (x [i][0])
      rotate (x [i][1])
        rotate ([0, 0, 45])
          cube ([chamfer, chamfer, x[i][2] + 0.02]);
}

module chamfer () {
  vertical_chamfer ();
  horizontal_chamfer (0);
  horizontal_chamfer (block_height);
}

//
//  Rotate so block doesn't need to be rotated in slicer
//
rotate ([270, 0, 0]) {
  difference () {
    block ();
    chamfer ();
  }
}
