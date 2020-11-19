//  Ring #1 is inner, #2 is middle, #3 is outer
//
//
ring_number = 1;

//
//  Constants for each ring
//
sides = 360;
sat_dia = 139;
wall_thickness = 5;
wall_height = 12.5;
pivot_hole_dia = 6.5;
pivot_pin_dia = 6;
ring_3_pivot_pin_len = 12.5;
groove_depth = 1;
ring_space = 1;
ring_inner_dia = (sat_dia - (groove_depth * 2)) + (((wall_thickness + (ring_space * 1.5)) * 2) * (ring_number - 1));
pivot_length = (ring_number == 3) ? ring_3_pivot_pin_len : (wall_thickness + ring_space);
ring_outer_dia = ring_inner_dia + (wall_thickness * 2);

module ring (id, od, hgt) {
  difference () {
  translate ([0, 0, 0])
    cylinder (d = od, h = hgt, $fn = sides);
  translate ([0, 0, -0.01])
    cylinder (d = id, h = hgt + 0.02, $fn = sides);
  }
}

module pivot_holes (od, phd, wh) {
  translate ([0, -((od / 2)+ 0.01), wh / 2])
    rotate ([270, 0, 0])
      cylinder (d = phd, h = od + 0.02, $fn = sides, center = false);
}

module pivot_pin (od, ppd, wh, pl, rs) {
  zrot = (od > 0) ? 0 : 180;

  translate ([(od / 2) - 0.01, 0, wh / 2]) {
    rotate ([0, 90, zrot])
      cylinder (d = ppd, h = pl, $fn = sides);
    rotate ([0, 90, zrot])
      cylinder (d = ppd + 3, h = rs / 1, $fn = sides);
  }
}

module pivot_pins (od, ppd, wh, pl, rs) {
  pivot_pin (od, ppd, wh, pl, rs);
  pivot_pin (-od, ppd, wh, pl, rs);
}

module torus2 (r1, r2) {
  rotate_extrude ()
    translate ([r1, 0, 0])
      circle (r2, $fn = sides);
}

module sat_groove (id, wh, gd) {
  translate ([0, 0, wh / 2])
      torus2 (id, gd);
}

union () {
  difference () {
    ring (ring_inner_dia, ring_outer_dia, wall_height);

    if (ring_number == 1)
      sat_groove (ring_inner_dia / 2, wall_height, groove_depth);
    if (ring_number != 1)
      pivot_holes (ring_outer_dia, pivot_hole_dia, wall_height);
  }

  pivot_pins (ring_outer_dia, pivot_pin_dia, wall_height, pivot_length, ring_space);
}
