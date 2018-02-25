sides = 360;
hole_size = 4.2;

//
//  No need to rotate it in the slicer if we do it here. 
//  Slic3r PE on a Prusa i3 Mk3 prints this without any
//  supports or brim.
//
rotate ([0, 270, 0]) {
  difference () {
    cube ([30, 3 + 25 + 3, 13 + 3 + 15]);
    
    translate ([-0.1, 2.6, 13 + 3]) // top cutout
      cube ([30.2, 25.6, 15.1]);
    
    translate ([-0.1, (31 - 20) / 2, -0.1]) // bottom cutout
      cube ([30.2, 20, 13.2]);
    
    translate ([(30 / 2) - 8, -0.1, 13 + 3 + 7.5]) // left top hole
      rotate ([270, 0, 0])
        cylinder (d=hole_size, h=3 + 25 + 3 + 0.2, $fn = sides);
    
    translate ([(30 / 2) + 8, -0.1, 13 + 3 + 7.5]) // right top hole
      rotate ([270, 0, 0])
        cylinder (d=hole_size, h=3 + 25 + 3 + 0.2, $fn = sides);
    
    translate ([(30 / 2), -0.1, 6.5]) // mounting hole
      rotate ([270, 0, 0])
        cylinder (d=hole_size, h=3 + 25 + 3 + 0.2, $fn = sides);
  }
}