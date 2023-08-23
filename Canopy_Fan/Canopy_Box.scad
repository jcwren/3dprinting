box_l         = 120.0;  // Length of box interior
box_w         =  55.0;  // Width of box interior
box_h         =  42.0;  // Height of box interior (needs to be 4mm more than actual!)
baseplate_hgt =   2.0;  // Thickness of base plate
radius        =   4.0;  // Corner radius (wall thickness will be half of radius)

$fn = $preview ? 32 : 128;

module box_hull (radius = 2) {
  if (radius == 0)
    cube ([box_l, box_w, box_h]);
  else
    hull ()
      for (l = [0, box_l])
        for (w = [0, box_w])
          for (h = [0, box_h])
            translate ([l, w, h])
              sphere (d = radius);
}

module power_switch () {
  cylinder (d = 20.6, h = (radius / 2) + 0.02);
  translate ([0, 20.6 / 2, (radius / 4) + 0.01])
    cube ([2.0, 0.8, (radius / 2) + 0.02], center = true);
}

module cover () {
  difference () {
    box_hull (radius);
    box_hull (0);

    //
    //  Cut bottom of box off
    //
    translate ([-((radius / 2) + 0.01), -((radius / 2) + 0.01), box_h - 0.01])
      cube ([box_l + radius + 0.02, box_w + radius, radius + 0.02]);
    translate ([-((radius / 2) + 0.01), 0, box_h - (radius / 2)])
      cube ([box_l + radius + 0.02, box_w, (radius / 2) + 0.01]);

    translate ([12.6, 0, -((radius / 2) + 0.01)]) {
      translate ([0, (box_w / 4) * 1, 0])
        power_switch ();
      translate ([0, (box_w / 4) * 3, 0])
        cylinder (d = 6.9, h = (radius / 2) + 0.02);
    }

    //
    //  Holes for M3-6 screws, 10mm from sides, 4mm from top edge
    //
    translate ([-((radius / 2) + 0.01), 0, box_h - (radius + 4)]) {
      for (x = [0, box_l])
        for (y = [10, box_w - 10])
          translate ([x, y, 0])
            rotate ([0, 90, 0])
              cylinder (d = 3.2, h = radius + 0.02);
      for (x = [0, box_l])
        translate ([x, box_w / 2, 2])
          rotate ([0, 90, 0])
            cylinder (d = 4.5, h = radius + 0.02);
    }
  }
}

module base_plate () {
  plate_points = [
    [(box_l / 2) + (radius / 2), (box_w / 2) - (radius / 2)],
    [(box_l / 2) + 12.6, (box_w / 2) - (radius / 2) - 12.6],
  ];

  translate ([0, 0, box_h - (radius / 2)]) {
    difference () {
      hull ()
        linear_extrude (height = baseplate_hgt)
          translate ([box_l / 2, box_w / 2, 0])
            for (i = [0 : len (plate_points) - 1])
              for (x = [-1, 1])
                for (y = [-1, 1])
                  translate ([plate_points [i][0] * x, plate_points [i][1] * y, 0])
                    circle (d = radius);

      translate ([-((12.6 / 2) + (radius / 2)), 0, -0.01])
        for (x = [0, box_l + 12.6 + radius])
          translate ([x, box_w / 2, 0])
            cylinder (d = 4.5, h = (radius / 2) + 0.02);
    }

    //
    // Blocks should be 9mm wide (3 + 3 + 3), 10mm tall (4 + 3 + 3), 4mm thick
    //
    for (x = [0, box_l - 4])
      for (y = [5.5, box_w - 14.5])
        translate ([x, y, -10])
          difference () {
            cube ([4, 9, 10]);
            translate ([-0.01, 4.5, 4 - 0.01])
              rotate ([0, 90, 0])
                cylinder (d = 3, h = (6 - (radius / 2)) + 0.02);
          }
  }
}

*cover ();
base_plate ();
