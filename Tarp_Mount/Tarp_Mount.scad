function i2c (i) = i * 25.4;

$fn            = 180;
bot_wid        = i2c (3.625);
bot_dep        = i2c (1.45);
bot_hgt        = i2c (1.00);
top_wid        = i2c (4.00);
top_dep        = bot_dep;
top_hgt        = i2c (0.125);
dia            = i2c (0.86);
rad_small      = i2c (0.125);
rad_large      = i2c (0.625);
adj            = i2c (0.1875);
screw_body_dia = 4.5;  // #8 pan head screw body diameter (0.164")
screw_head_dia = 8.6;  // #8 pan head screw head diameter (0.306" to 0.0322")
screw_head_hgt = 2.8;  // #8 pan head screw head height (0.105" to 0.115")

module base () {
  difference () {
    union () {
      hull () {
        for (x = [rad_small / 2, bot_wid - rad_small / 2])
          translate ([x, rad_small / 2, 0])
            cylinder (d = rad_small, h = bot_hgt);
        for (x = [(rad_large / 2) + adj, (bot_wid - (rad_large / 2)) - adj])
          translate ([x, bot_dep - rad_large / 2, 0])
            cylinder (d = rad_large, h = bot_hgt);
      }
      translate ([-(top_wid - bot_wid) / 2, 0, bot_hgt])
        cube ([top_wid, top_dep, top_hgt]);
    }
    translate ([bot_wid / 2, bot_dep / 2, -0.01])
      cylinder (d = dia, h = bot_hgt + top_hgt + 0.02);
  }
}

module n8_screw () {
  translate ([(bot_wid / 2) + 23, -4, bot_hgt / 2])
    rotate ([0, 90, 45 + 90]) {
      cylinder (d = screw_body_dia, h = 30);
      cylinder (d = screw_head_dia, h = 14);
    }
}

module mount () {
  difference () {
    base ();
    n8_screw ();
  }
}

/*
translate ([-bot_wid / 2, -top_dep, -25])

difference () {
  mount ();
  translate ([-(((top_wid - bot_wid) / 2) + 0.01), -0.01, 2])
    cube ([top_wid + 0.02, top_dep + 0.02, bot_hgt + top_hgt]);
}
*/

mount ();
