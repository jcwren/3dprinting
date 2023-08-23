include <Drain_Valve_Direct.scad>

box_x         = 136;
box_y         = 136;
ac_detector_x =  71.6;
ac_detector_y =  15.25;
ac_detector_z =  20;

module box_plate_holes (h = 2) {
  translate ([0, 0, -0.01])
    linear_extrude (height = h + 0.02)
      for (x = [-54, 54])
        for (y = [-54, 54])
          translate ([x, y, 0])
            circle (d = 4.85);
}

module box_plate_base (h = 2)
{
  coords = [
    [-67,  57, 0],
    [-57,  67, 0],
    [ 57,  67, 0],
    [ 67,  57, 0],
    [ 67, -57, 0],
    [ 57, -67, 0],
    [-57, -67, 0],
    [-67, -57, 0],
  ];

  linear_extrude (height = h)
    hull ()
      for (i = [0 : len (coords) - 1])
        translate (coords [i])
          circle (d = 2);
}

module base_plate (h = 2) {
  difference () {
    box_plate_base (h);
    box_plate_holes (h);
  }
}

module hour_meter (base_h = 0) {
  width     = 54;
  cutout_w  = 37;
  cutout_d  = 24;
  cutout_h  = 76;
  screw_ctc = 44.5;
  tab_w     = 10;
  tab_d     =  4;
  tab_h     = 30;

  width2     = width / 2;
  cutout_w2  = cutout_w / 2;
  cutout_d2  = cutout_d / 2;
  screw_ctc2 = screw_ctc / 2;
  tab_w2     = tab_w / 2;
  col_w      = (width - cutout_w) / 2;

  difference () {
    union () {
      translate ([-(cutout_w2 + col_w), -cutout_d2, 0])
        cube ([col_w, cutout_d, cutout_h]);
      translate ([width2 - col_w, -cutout_d2, 0])
        cube ([col_w, cutout_d, cutout_h]);
      translate ([-tab_w2, -(cutout_d2 + tab_d), 0])
        cube ([tab_w, tab_d, tab_h]);
    }
    translate ([-screw_ctc2, 0, 50])
      cylinder (d = m3_screw_dia_tight, h = tab_h);
    translate ([screw_ctc2, 0, 50])
      cylinder (d = m3_screw_dia_tight, h = tab_h);
  }

  if (base_h)
    translate ([-width2, -(cutout_d2 + tab_d), -base_h])
      cube ([width, tab_d + cutout_d, base_h]);
}

module power_supply_holes (base_h = 0, shadow = 1) {
  ps_w        = 109;
  ps_d        =  52;
  screw_ctc_x =  98;
  screw_ctc_y =  33;

  ps_w2 = ps_w / 2;
  ps_d2 = ps_d / 2;
  screw_ctc_x2 = screw_ctc_x / 2;
  screw_ctc_y2 = screw_ctc_y / 2;

  if (shadow)
    translate ([-ps_w2, -ps_d2, base_h])
      %cube ([ps_w, ps_d, 34]);

  for (x = [-screw_ctc_x2, screw_ctc_x2])
    for (y = [-screw_ctc_y2, screw_ctc_y2])
      translate ([x, y, -1])
        cylinder (d = m3_screw_dia_loose, h = base_h + 2);
}

module ac_detector (base_h = 0, shadow = 1) {
  post_dia = 5;
  post_z   = 6;

  if (shadow)
    translate ([0, 0, base_h])
      %cube ([ac_detector_x, ac_detector_y, ac_detector_z]);
  for (v = [[15.5, 12.75, base_h], [56.1, 8.75, base_h]])
    translate (v)
      difference () {
        cylinder (d = post_dia, h = post_z);
        cylinder (d = m3_screw_dia_tight, h = post_z + base_h + 0.02);
      }
}

module plate (shadow = 0) {
  difference () {
    union () {
      base_plate (baseplate_hgt);

      translate ([71.5, 39.5, 0])  // Set "origin" of motor mount to 0,0
        translate ([-50.5, 7.5, 0])
          rotate ([0, 0, 270])
            color (shadow ? "blue" : "gold")
              valve_holder (show_coupler = 0, elevate = 21);

      rotate ([0, 0, 180])
        translate ([-ac_detector_x / 2, 49, 0])
          ac_detector (baseplate_hgt, shadow);
    }
    translate ([0, -20, 0])
      power_supply_holes (baseplate_hgt, shadow);
  }
}

plate ();
