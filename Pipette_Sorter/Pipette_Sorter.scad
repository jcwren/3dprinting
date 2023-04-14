$fn              = 100;    // Segments in a circle
pipettes_x       =   3;    // Number of pipettes horizontally
pipettes_y       =   8;    // Number of pipettes vertically
pipette_spacing  =   9.00; // Spacing between pipettes
pipette_neck     =   6.35; // Diameter of pipette neck below flange
pipette_flange   =   7.55; // Diameter of pipette at flange
pipette_taper    =   1.50; // Height from beginning to top of flange
wall_thickness   =   3.50; // Thickness of outer walls of frame
wall_height      =   8.00; // Height of outer walls of frame
bottom_thickness =   2.50; // Thickness of bottom of frame

inner_x = (pipettes_x + 0) * pipette_spacing;
inner_y = (pipettes_y + 0) * pipette_spacing;
outer_x = inner_x + (wall_thickness * 2);
outer_y = inner_y + (wall_thickness * 2);

inner_frame = [inner_x, inner_y, wall_height];
outer_frame = [outer_x, outer_y, wall_height];

module frame () {
  difference () {
    translate ([0, 0, 0])
      cube (outer_frame);
    translate ([wall_thickness, wall_thickness, bottom_thickness])
      cube (inner_frame);
   }
 }

module single_rail () {
  translate ([0, -(pipette_neck / 2), 0])
    cube ([inner_x + wall_thickness + 0.01, pipette_neck, pipette_taper]);
  difference () {
    translate ([0, -(pipette_flange / 2), 1.5 - 0.01])
      cube ([inner_x + wall_thickness + 0.01, pipette_flange, pipette_taper * 3]);
    translate ([0, -(pipette_flange / 2), pipette_taper * 4])
      translate ([0, 0, -1.78])
        rotate ([45, 0, 0])
          cube ([wall_thickness, 2.5, 2.5]);
    translate ([0, +(pipette_flange / 2), pipette_taper * 4])
      translate ([0, 0, -1.78])
        rotate ([45, 0, 0])
          cube ([wall_thickness, 2.5, 2.5]);
  }
}

module rails () {
  translate ([-0.01, wall_thickness + (pipette_spacing / 2), -0.01]) {
    for (y = [0 : pipettes_y - 1]) {
      translate ([0, y * pipette_spacing, 0]) {
        single_rail ();
        for (x = [0 : pipettes_x - 1]) {
          translate ([wall_thickness + (pipette_spacing / 2) + (x * pipette_spacing), 0, 0])
            cylinder (d1 = pipette_neck, d2 = pipette_flange + 0, h = pipette_taper);
          translate ([wall_thickness + (pipette_spacing / 2) + (x * pipette_spacing), 0, pipette_taper])
            cylinder (d = pipette_flange + 0, h = pipette_taper);
        }
      }
    }
  }
}

module pipette_sorter () {
  difference () {
    frame ();
    rails ();
  }
}

pipette_sorter ();
cube ([5, outer_y, 0.2]);
