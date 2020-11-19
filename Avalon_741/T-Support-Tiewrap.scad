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

translate ([0, 0, 0]) {
  difference () {
     // Floor
    cube ([30, 27, 27]);

    // Remove cube to create vertical
    translate ([0, 0, 7]) {
      cube ([30, 20, 27]);
    }
    
    // Tie-wrap
    translate ([10.25, 0, 0]) {
      cube ([9.5, 27, 2.75]);
    }
    translate ([10.25, 24.5, 0]) {
      cube ([9.5, 2.75, 30]);
    }
    /*
    translate ([15, 24.5, 2.5]) {
      rotate (a=90, v=[0,1,0]) {
        cylinder (h=9, d=4, $fn=16, center=true);
      }
    }
    */
    
    //  Screw holes & head recesses
    screw (6, 10);
    screw (24, 10);
  } 
}

  
