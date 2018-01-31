// Base is 49mm wide, 25mm deep
// Body is 39mm wide
// Tab is 16mm wide
// Locks are 6mm from back, 12mm from side, 10mm long

module screw (x, y)
{
  translate ([x, y, 0]) {
    cylinder (h=10, d=4.0, $fn=16, center=true);
  }
  translate ([x, y, 6]) {
    cylinder (h=4.5, d=7.2, $fn=16, center=true);
  }
}

translate ([-15, 0, 0]) {
  difference () {
     // Floor
    cube ([30, 47, 27]);

    // Remove cubes to create vertical
    translate ([0, 0, 7]) {
      cube ([30, 20, 27]);
    }
    translate ([0, 27, 7]) {
      cube ([30, 20, 27]);
    }
    
    // Tie-wrap
    translate ([6.5, 0, 0]) {
      cube ([17, 47, 2.75]);
    }
    
    //  Screw holes & head recesses
    screw (4.25, 10);
    screw (25.75, 37);
  } 
}
