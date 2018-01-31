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
  } 
}
