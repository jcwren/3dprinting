opening   = 35.0;  // Width of opening where PC sits
thickness =  3.0;  // Thickness of part
width     = 15.0;  // Width of part
depth     = 15.0;  // Depth of seating pocket
hole_dia  =  4.6;  // #8 screw hole

//
//
//
translate ([0, -thickness, 0]) {
  //
  //  Top bar
  //
  translate ([depth, 0, 0])
    cube ([thickness, opening + thickness, width]);

  //
  //  Middle bar
  //
  translate ([0, opening + thickness, 0])
    cube ([depth + thickness, thickness, width]);

  //
  //  Bottom bar
  //
  hole_x_pos = (depth + thickness) + (((depth * 2) - (depth + thickness)) / 2);

  difference () {
    cube ([depth * 2, thickness, width]);
    translate ([hole_x_pos, thickness / 2, width / 2])
      rotate ([90, 0, 0])
        cylinder (h=thickness + 0.02, d=hole_dia, $fn=64, center=true);
  };
}
