box_hgt    =  25.0;
box_width  = 110.0;
box_length = 110.0;
box_radius =   3.0;
wall       =   1.5;
floor      =   1.0;
post_x_wid =  95.0;
post_y_wid =  75.0;
post_inset =   6.0;
post_dia   =   8.0;
post_hgt   =   5.0;
post_drill =   3.0;
sma_dia    =   6.5;
power_dia  =  13.0;
sides      = 360;

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

module post (x, y, z, d, h, drill) {
  translate ([x, y, z]) {
    difference () {
      cylinder (d = d, h = h, $fn = sides);
      cylinder (d = drill, h = h + 0.01, $fn = sides);
    }
  }
}

module side_hole (x, d) {
  translate ([x, box_length - 0.01, box_hgt / 2])
    rotate ([270, 0, 0])
      cylinder (d = d, h = wall + 0.02, $fn = sides);
  }

module the_box () {
  difference () {
    hollow_box ();
    side_hole (35, power_dia);
    side_hole (70, sma_dia);
    side_hole (85, sma_dia);
    side_hole (100, sma_dia);
  }

  translate ([0, 0, 0]) {
    post ((box_width / 2) - (post_x_wid / 2), post_inset, 0.01, post_dia, post_hgt + floor, post_drill);
    post ((box_width / 2) + (post_x_wid / 2), post_inset, 0.01, post_dia, post_hgt + floor, post_drill);
    post ((box_width / 2) - (post_x_wid / 2), post_y_wid + post_inset, 0.01, post_dia, post_hgt + floor, post_drill);
    post ((box_width / 2) + (post_x_wid / 2), post_y_wid + post_inset, 0.01, post_dia, post_hgt + floor, post_drill);
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

//the_lid ();
the_box ();