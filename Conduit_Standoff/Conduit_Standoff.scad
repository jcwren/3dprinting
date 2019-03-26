dia = 55.8;       // 2.197" conduit diameter
height = 50.8;    // 2.000" block height
width = 50.8;     // 2.000" block width
standoff = 31.75; // 1.250" from edge to conduit

inset = (dia - width) / 2;

difference () {
  cube ([dia, dia, height]);
  /*
  polyhedron (
    points = [
      [   0,       inset,      0 ],
      [ dia,           0,      0 ],
      [ dia,         dia,      0 ],
      [   0, dia - inset,      0 ],
      [   0,       inset, height ],
      [ dia,           0, height ],
      [ dia,         dia, height ],
      [   0, dia - inset, height ],
    ],
    faces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]   // left
    ],
    convexity = 10
  );
  */
  translate ([standoff + (dia / 2), dia / 2, -0.1]) 
    cylinder (h = height + 0.2, d = dia, $fn = 360);
}