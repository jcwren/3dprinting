module screw (x, y)
{
  translate ([x, y, 0]) {
    cylinder (h=10, d=4.0, $fn=16, center=true);
  }
  translate ([x, y, 5]) {
    cylinder (h=4.5, d=7.2, $fn=16, center=true);
  }
}

translate ([-6, 0, 0]) {
  difference () {

    // Floor
    cube ([12, 25, 5]);

    // Slot
    translate ([5, 0, 1]) {
      cube ([2, 6.5, 4]);
    }

    //  Screw hole & head recess
    screw (6, 15);
  }
}
