height       =  42.00;  // Height of block
width        =   7.00;  // Width of block
edge         =   4.50;  // Distance from screw center to end of block
ctc          =  89.00;  // Center to center between screw holes
screw_depth  =   9.00;  // Depth of screw hole
screw_dia    =   2.90;  // Screw hole diameter
sides        = 360.00;  // Number of sides on cylinders

module screw_holes () {
  translate ([edge, width / 2, height - screw_depth])
    cylinder (d = screw_dia, h = screw_depth + .01, $fn = sides);
  translate ([edge + ctc, width / 2, height - screw_depth])
    cylinder (d = screw_dia, h = screw_depth + 0.01, $fn = sides);
  translate ([edge, width / 2, -0.01])
    cylinder (d = screw_dia, h = screw_depth + 0.01, $fn = sides);
  translate ([edge + ctc, width / 2, -0.01])
    cylinder (d = screw_dia, h = screw_depth + 0.01, $fn = sides);
}

module tb_cutouts () {
  translate ([edge * 2, -0.01, height - 2.00])
    cube ([ctc - (edge * 2), width + 0.02, 2.01]);
  translate ([edge * 2, -0.01, -0.01])
    cube ([ctc - (edge * 2), width + 0.02, 2.01]);
}

module other_cutouts () {
  bars       = 3;
  bar_width  = 5.00;
  bar_space  = ((ctc - (edge * 2)) - (bars * bar_width)) / 4;
  bar_height = 5.00 + 2.00;
  
  translate ([edge * 2, -0.01, bar_height])
    cube ([bar_space, width + 0.02, height - (bar_height * 2)]);
  translate ([(edge * 2) + ((bar_space + bar_width) * 1), -0.01, bar_height])
    cube ([bar_space, width + 0.02, height - (bar_height * 2)]);
  translate ([(edge * 2) + ((bar_space + bar_width) * 2), -0.01, bar_height])
    cube ([bar_space, width + 0.02, height - (bar_height * 2)]);
  translate ([(edge * 2) + ((bar_space + bar_width) * 3), -0.01, bar_height])
    cube ([bar_space, width + 0.02, height - (bar_height * 2)]);
}

difference () {
  cube ([ctc + (2 * edge), width, height]);
  screw_holes ();
  tb_cutouts ();
  other_cutouts ();
}