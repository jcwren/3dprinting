posts        =   4.00;  // Number of posts
height       =  42.00;  // Height of block
width        =   7.00;  // Width of block
edge         =   4.50;  // Distance from screw center to end of block
ctc          =  50.50;  // Center to center between screw holes
relief       =   2.00;  // Relief cuts in top and bottom
bar_height   =   5.00;  // Height of interconnecting bars
screw_depth  =   9.00;  // Depth of screw hole
screw_dia    =   2.90;  // Screw hole diameter
sides        = 360.00;  // Number of sides on cylinders

module screw_holes () {
  for (i = [0:(posts - 1)]) {
    translate ([(ctc * i) + edge, width / 2, height - screw_depth])
      cylinder (d = screw_dia, h = screw_depth + .01, $fn = sides);
    translate ([(ctc * i) + edge, width / 2, -0.01])
      cylinder (d = screw_dia, h = screw_depth + 0.01, $fn = sides);
  }
}

module relief_cutouts () {
  for (i = [0:(posts - 2)]) {
    translate ([(ctc *  i) + (edge * 2), -0.01, height - relief])
      cube ([ctc - (edge * 2), width + 0.02, relief + 0.01]);
    translate ([(ctc * i) + (edge * 2), -0.01, -0.01])
      cube ([ctc - (edge * 2), width + 0.02, relief + 0.01]);  
  }
}

module other_cutouts () {
  for (i = [0:(posts - 2)])
    translate ([(ctc * i) + (edge * 2), -0.01, bar_height + relief])
      cube ([ctc - (edge * 2), width + 0.02, height - ((bar_height + relief) * 2)]); 
}

difference () {
  cube ([(ctc * (posts - 1)) + (edge * 2), width, height]);
  screw_holes ();
  relief_cutouts ();
  other_cutouts ();
}