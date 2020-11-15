$fn      = 180;
top_w    =  88.0;
top_d    =  31.0;
bot_w    =  83.0;
bot_d    =  26.0;
height   =  57.0;
side     =  17.0;
frnt_rad =   8.8;
rear_rad =   1.6;
hole_x   =  26.0;
hole_y   =   3.4;
hole_z   =  40.0;
hole_rot = 360.0 - 35.0;
hole_ang =   0.0;

top_left  = -top_w / 2;
top_right =  top_w / 2;
top_frnt  =  top_d / 2;
top_rear  = -top_d / 2;

bot_left  = -bot_w / 2;
bot_right =  bot_w / 2;
bot_frnt  =  bot_d / 2;
bot_rear  = -bot_d / 2;

frnt_dia  = frnt_rad * 2;
rear_dia  = rear_rad * 2;

module base_raw () {
  hull () {
    translate ([bot_left  + rear_rad, bot_rear + rear_rad, 0])      sphere (r = rear_rad);
    translate ([bot_right - rear_rad, bot_rear + rear_rad, 0])      sphere (r = rear_rad);
    translate ([top_left  + rear_rad, top_rear + rear_rad, height]) sphere (r = rear_rad);
    translate ([top_right - rear_rad, top_rear + rear_rad, height]) sphere (r = rear_rad);

    translate ([bot_left  + frnt_rad, bot_frnt - frnt_rad, 0])      sphere (r = frnt_rad);
    translate ([bot_right - frnt_rad, bot_frnt - frnt_rad, 0])      sphere (r = frnt_rad);
    translate ([top_left  + frnt_rad, top_frnt - frnt_rad, height]) sphere (r = frnt_rad);
    translate ([top_right - frnt_rad, top_frnt - frnt_rad, height]) sphere (r = frnt_rad);
  }
}

module base () {
  difference () {
    translate ([0, 0, 0])
      base_raw ();
    translate ([top_left - 0.01, top_rear - 0.01, -frnt_rad - 0.01])
      cube ([top_w + 0.02, top_d + 0.02, frnt_rad + 0.01]);
    translate ([top_left - 0.01, top_rear - 0.01, height])
      cube ([top_w + 0.02, top_d + 0.02, frnt_rad + 0.01]);
    translate ([-9.0, bot_frnt - 4, -0.01])
      cube ([18.0, 5, 12.5]);
    rotate (a = [0, 0, hole_rot])
      translate ([-hole_x / 2, -hole_y / 2, height - hole_z])
        cube ([hole_x, hole_y, hole_z + 0.01]);
  }
}

module stem (hgt = 12) {
  difference () {
    cylinder (d = 7, h = hgt);
    cylinder (d = 5, h = hgt + 0.01);
  }
}

module top_slice () {
  difference () {
    translate ([0, 0, 0])
      base ();
    translate ([top_left - 0.01, top_rear - 0.01, -frnt_rad - 0.01])
      cube ([top_w + 0.02, top_d + 0.02, frnt_rad + 0.01 + 56]);
  }

  translate ([0, 0, 56])
    stem ();
}

module bottom_slice (nostem = 0) {
  difference () {
    translate ([0, 0, 0])
      base ();
    translate ([top_left - 0.01, top_rear - 0.01, 1])
      cube ([top_w + 0.02, top_d + 0.02, frnt_rad + 0.01 + 56]);
  }

  if (!nostem)
    translate ([0, 0, 0])
      stem ();
}

module top_bottom_slice () {
  translate ([0, 30, -56])
    top_slice ();
  translate ([0, 0, 0])
    bottom_slice ();
  translate ([0, 0, 0])
    cube ([0.01, 30, 0.01]);
}

module hole_test () {
  difference () {
    translate ([-40.0 / 2, -10.0 / 2, 0])
      cube ([40.0, 10.0, 1.0]);
    translate ([-hole_x / 2, -hole_y / 2, -0.01])
      cube ([hole_x, hole_y, 25]);
  }
}

// top_bottom_slice ();
// hole_test ();
base ();
