module screw (x, y)
{
  translate ([x, y, 0]) {
    cylinder (h=10, d=4.0, $fn=16, center=true);
  }
  translate ([x, y, 6]) {
    cylinder (h=4.5, d=7.2, $fn=16, center=true);
  }
}

translate ([-16, 0, 0]) {
  difference () {
     // Floor
    cube ([32, 47, 27]);

    // Remove cubes to create vertical
    translate ([0, 0, 7]) {
      cube ([32, 20, 27]);
    }
    translate ([0, 27, 7]) {
      cube ([32, 20, 27]);
    }
    
    // Tie-wrap
    translate ([7.5, 0, 0]) {
      cube ([17, 47, 3]);
    }
    
    //  Screw holes & head recesses
    screw (4.25, 10);
    screw (27.75, 37);
  } 
}
