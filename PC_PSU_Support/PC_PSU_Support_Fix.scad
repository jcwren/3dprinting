sides=360;

module screw (x, y)
{
  translate ([x, y, 0]) {
    cylinder (h=10, d=4.0, $fn=sides, center=true);
  }
  translate ([x, y, 5]) {
    cylinder (h=4.5, d=7.2, $fn=sides, center=true);
  }
}

difference () {
  union () {
    difference () {
      union () {
        cube ([20, 20, 5]);
        translate ([5, 5, 0]) {
          cube ([20, 20, 5]);
        }
      }
      screw (15, 15);
    }
    translate ([-3, -3, 0]) {
      cube ([3, 18, 18]);
    }
    translate ([-3, -3, 0]) {
      cube ([18, 3, 18]);
    }
  }
  translate ([-0.5, -0.5, 5]) {
    cube ([3, 3, 18]);
  }
}
