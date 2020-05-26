$fn = 360;
shaftLen = 75.0;
shaftDia = 7.60;
flatOffset = 1.8;

rotate ([0, 90, 0]) {
  linear_extrude (shaftLen) {
    difference () {
      circle (d = shaftDia);
      
      translate ([flatOffset, -(shaftDia / 2), 0])
        square ([shaftDia, shaftDia]);
    }
  }
}