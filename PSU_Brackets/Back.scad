// Base is 49mm wide, 25mm deep
// Body is 39mm wide
// Tab is 16mm wide
// Locks are 6mm from back, 12mm from side, 10mm long

module screw (x, y)
{
  translate ([x, y, 0]) {
    cylinder (h=10, d=4.0, $fn=16, center=true);
  }
  translate ([x, y, 5]) {
    cylinder (h=4.5, d=7.2, $fn=16, center=true);
  }
}

translate ([-24.5, -5, 0]) {
  difference () {
    
    // Floor
    cube ([49, 25, 9]);

    // Main body of PSU cutout
    translate ([5, 5, 5]) {
      cube ([39, 20, 4]);
    }
    
    // Tab cutout
    translate ([16.5, 0, 5]) {
      cube ([16, 8, 4]);
    }

    // Slots
    translate ([16.5, 11, 2]) {
      cube ([2, 10, 4]);
    }
    translate ([30.5, 11, 2]) {
      cube ([2, 10, 4]);
    }
    
    // Screw hole & head recess
    screw (11, 15);
    screw (38, 15);
    
    // Tie-wrap slot
    translate ([0, 7, 0]) {
      cube ([49, 4.7, 1.8]);
    }
  } 
}