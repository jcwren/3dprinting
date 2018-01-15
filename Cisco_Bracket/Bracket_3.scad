//
//  Top bar
//
translate ([20, 0, 0]) {
  cube ([5, 49.23, 20]);
};

//
//  Middle bar
//
translate ([0, 49.23, 0]) {
  cube ([25, 5, 20]);
};
//
//  Bottom bar
//
difference () {
  cube ([40, 5, 20]);
  translate ([32.5, 0, 10]) {
    rotate ([90, 0, 0]) {
      cylinder (h=11, d=4.6, $fn=16, center=true);
    }
  }
};
