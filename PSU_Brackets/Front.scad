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
    cube ([49, 25, 10]);

    // Main body of PSU cutout
    translate ([5, 5, 6]) {
      cube ([39, 20, 4]);
    }

    // Connector cutout
    translate ([28.5, 0, 6]) {
      cube ([13, 5, 4]);
    }
    translate ([28.5, 0, 5]) {
      cube ([13, 2, 1]);
    }

    //  Screw hole & head recess
    screw (11, 15);
    screw (38, 15);

    // Tie-wrap slot
    translate ([0, 7, 0]) {
      cube ([49, 4.7, 1.8]);
    }
  }
}
