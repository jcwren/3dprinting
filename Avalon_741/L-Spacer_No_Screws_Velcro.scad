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
    cube ([32, 27, 27]);

    // Remove cube to create vertical
    translate ([0, 0, 7]) {
      cube ([32, 20, 27]);
    }
    
    // Tie-wrap
    translate ([7.5, 0, 0]) {
      cube ([17, 27, 3]);
    }
    translate ([7.5, 24.5, 0]) {
      cube ([17, 3, 30]);
    }
  } 
}

  
