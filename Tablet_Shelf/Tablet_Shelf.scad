function i2c (i) = i * 25.4;

$fn             = 180;
shelf_width     = i2c (8);     // Width of shelf
shelf_depth     = i2c (4.5);   // Depth of shelf
shelf_thickness = i2c (0.175); // Thickness of shelf
shelf_radius    = i2c (0.125); // Radius on corners of shelf
screw_head_dia  = 8.5;         // Diameter of #8 screw head
screw_body_dia  = 4.5;         // Diameter of #8 screw body
screw_wall      = i2c (0.25);  // Wall between screw head and back of leg
leg_dia         = i2c (0.375); // Diameter of leg between top and bottom shelf
leg_pin         = i2c (0.25);  // Diameter of pin on leg
leg_hgt         = i2c (1.5);   // Height of leg
leg_inset       = i2c (0.5);   // Distance leg inset from edges
mtg_tab_wid     = i2c (1);     // Width of mounting tab
mtg_tab_dep     = i2c (0.5);   // Depth of mounting tab
mtg_tab_hgt     = i2c (0.5);   // Height of mounting tab
mtg_tab_inset   = i2c (1);     // Distance mounting tab inset from edge
cable_dia       = 4;           // Power cord is 3.5mm in diameter
hole_fudge      = 0.3;         // Holes are always undersized so add fudge factor
show_mode       = 4;           // 1=top, 2=bottom, 3=both, 4=as built

module shelf_without_cutout () {
  hull ()
    for (x = [-1, 1])
      for (y = [-1, 1])
        translate ([x * ((shelf_width / 2) - (shelf_radius / 2)), y * ((shelf_depth / 2) - (shelf_radius / 2)), 0])
          cylinder (d = shelf_radius, h = shelf_thickness);
}

module shelf_with_cutout () {
  difference () {
    translate ([0, 0, 0])
      shelf_without_cutout ();

    //
    //  Create cutout for power cable
    //
    translate ([0, -(shelf_depth / 2), -0.01])
      hull () {
        translate ([0, -cable_dia / 2, 0])
          cylinder (d = cable_dia, h = shelf_thickness + 0.02);
        translate ([0, cable_dia / 2, 0])
          cylinder (d = cable_dia, h = shelf_thickness + 0.02);
      }
  }
}

module mounting_tab () {
  difference () {
    translate ([0, 0, 0])
      cube ([mtg_tab_wid, mtg_tab_dep, mtg_tab_hgt]);
    translate ([mtg_tab_wid / 2, mtg_tab_dep + 0.01, mtg_tab_hgt / 2])
      rotate ([90, 0, 0]) {
        cylinder (d = screw_body_dia, h = mtg_tab_dep + 0.02);
        cylinder (d = screw_head_dia, h = mtg_tab_dep - screw_wall);
      }
  }
}

module mounting_tabs () {
  translate ([0, -(shelf_depth / 2), 0]) {
    translate ([-((shelf_width / 2) - mtg_tab_inset), 0, 0])
      mounting_tab ();
    translate ([(shelf_width / 2) - mtg_tab_inset - mtg_tab_wid, 0, 0])
      mounting_tab ();
  }
}

module bottom_shelf () {
  difference () {
    shelf_with_cutout ();

    //
    //  Holes for top shelf legs
    //
    for (x = [-1, 1])
      for (y = [-1, 1])
        translate ([x * ((shelf_width / 2) - leg_inset), y * ((shelf_depth / 2) - leg_inset), shelf_thickness / 2])
          cylinder (d = leg_pin + hole_fudge, h = (shelf_thickness / 2) + 0.01);
  }

  //
  //  Legs are inset 1.25" from edges
  //
  translate ([0, 0, shelf_thickness])
    mounting_tabs ();
}

module top_shelf () {
  shelf_with_cutout ();

  //
  //  Round legs to connect top and bottom shelf, inset from edges
  //
  for (x = [-1, 1])
    for (y = [-1, 1])
      translate ([x * ((shelf_width / 2) - leg_inset), y * ((shelf_depth / 2) - leg_inset), shelf_thickness]) {
        cylinder (d = leg_dia, h = leg_hgt);
        cylinder (d = leg_pin, h = leg_hgt + (shelf_thickness / 2));
      }
}

//
//
//
module shelf (show = 4) {
  if (show == 1)
    bottom_shelf ();
  else if (show == 3)
    translate ([0, 0, 0])
      bottom_shelf ();

  if (show == 2)
    top_shelf ();
  else if (show == 3)
    translate ([0, shelf_depth + 12.5, 0])
      top_shelf ();

  if (show == 4) {
    rotate ([0, 180, 0])
      translate ([0, 0, -((shelf_thickness * 2) + leg_hgt)]) {
        translate ([0, 0, 0])
          bottom_shelf ();
        rotate ([0, 180, 0])
          translate ([0, 0, -((shelf_thickness * 2) + leg_hgt)])
            top_shelf ();
      }
  }
}

shelf (show_mode);
