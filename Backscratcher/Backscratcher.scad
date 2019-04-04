module tri (d, x, y) {
  translate ([x, y, 0])
    polyhedron (
      points = [[d, d, 0], [d,-d, 0], [-d, -d, 0], [-d, d, 0], // the four points at base
                [ 0, 0, d]],                                   // the apex point 
      faces = [[0, 1, 4], [1, 2, 4], [2, 3, 4], [3, 0, 4],     // each triangle side
               [1, 0, 3], [2, 1, 3]]                           // two triangles for square base
     );
}

s = 5;
base_height = 5;

translate ([0, 0, base_height]) {
  for (x = [s:s * 2:100]) {
    for (y = [s:s * 2:100]) {
      tri (s, x, y);
    }
  }
}

cube ([100, 100, base_height]);
