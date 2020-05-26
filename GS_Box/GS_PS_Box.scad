box_hgt    =  25.0;
box_width  =  25.0;
box_length =  70.0;
box_radius =   3.0;
wall       =   1.5;
floor      =   1.0;
cable_dia  =   5.0;
power_dia  =  13.0;
sides      = 360.0;

module box (width, length, hgt) {
  hull () {
    translate ([box_radius, box_radius, 0])
      cylinder (r = box_radius, h = hgt, $fn = sides);
    translate ([width - box_radius, box_radius, 0])
      cylinder (r = box_radius, h = hgt, $fn = sides);
    translate ([width - box_radius, length - box_radius, 0])
      cylinder (r = box_radius, h = hgt, $fn = sides);
    translate ([box_radius, length - box_radius, 0])
      cylinder (r = box_radius, h = hgt, $fn = sides);
  }
}

module hollow_box () {
  difference () {
    translate ([-wall, -wall, -floor])
      box (box_width + (wall * 2), box_length + (wall * 2), box_hgt + floor);
    box (box_width, box_length, box_hgt + 0.01);
  }
}

module side_hole (x, y, d) {
  translate ([x, y - 0.01, box_hgt / 2])
    rotate ([270, 0, 0])
      cylinder (d = d, h = wall + 0.02, $fn = sides);
  }

module the_box () {
  difference () {
    hollow_box ();
    side_hole (box_width / 2, box_length, power_dia);
    side_hole (box_width / 2, -wall, cable_dia);
  }
}

module the_lid () {
  translate ([-wall, -wall, -floor])
    box (box_width + (wall * 2), box_length + (wall * 2), floor);
  difference () {
    translate ([0, 0, 0])
      box (box_width, box_length, floor * 3);
    translate ([wall, wall, 0])
      box (box_width - (wall * 2), box_length - (wall * 2), floor + 3.01);
  }
}

//
//  Draw the box and the lid, connect with unprintably small line to make manifold.
//
translate ([0, 0, 0])
  the_box ();
translate ([box_width + 5, 0, 0])
  the_lid ();
translate ([box_width - 0.01, box_length / 2, 0])
  cube ([5.01, 0.01, 0.01]);
