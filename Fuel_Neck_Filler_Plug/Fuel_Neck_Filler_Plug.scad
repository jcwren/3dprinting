//
//  2.470 inches == 62.738mm
//  2.130 inches == 54.102mm
//  2.135 inches == 54.229mm
//  2.140 inches == 54.356mm
//  2.150 inches == 54.610mm
//
translate ([0, 0, 0]) {
  difference () {
    translate ([0, 0, 0])
      cylinder (d=54.135, h=12.7, $fn=360);
    translate ([0, 0, -0.01])
      cylinder (d=25, h=12.72, $fn=360);
  }
}

translate ([60, 0, 0]) {
  difference () {
    translate ([0, 0, 0])
      cylinder (d=54.356, h=12.7, $fn=360);
    translate ([0, 0, -0.01])
      cylinder (d=25, h=12.72, $fn=360);
  }
}

translate ([20, 0, 0]) {
  cube ([20, 0.01, 0.01]);
}