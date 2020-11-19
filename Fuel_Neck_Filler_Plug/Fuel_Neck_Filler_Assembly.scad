sides = 360;
wall = 1.5;
top_od = 54.229;
top_height = 12.7;
base_od = top_od + (wall * 2);
base_height = 25.4;
shaft_dia = 12.45;
shaft_depth = 12.7 / 2;
shaft_len = 50.8;


module top () {
  difference () {
    cylinder (d = top_od, h = top_height , $fn = sides);
    translate ([0, 0, shaft_depth])
      cylinder (d = shaft_dia, h = top_height + 0.1, $fn = sides);
  }
}

module bottom () {
  difference () {
    union () {
      cylinder (d = base_od, h = base_height / 2, $fn = sides);
      cylinder (d = top_od, h = base_height, $fn = sides);
    }
    translate ([0, 0, base_height - shaft_depth])
      cylinder (d = shaft_dia, h = shaft_depth + 0.1, $fn = sides);
  }
}

module shaft () {
  cylinder (d = shaft_dia, h = shaft_len, $fn = sides);
}

translate ([0, 0, 0])
  top ();
translate ([60, 0, 0])
  bottom ();
translate ([100, 0, 0])
  shaft ();
translate ([0, 0, 0])
  cube ([100, 0.01, 0.01]);
