$fn         = 360.0;  // Number of sides (64 for test, 360 to render)
width       =  30.0;  // Overall width of bracket
length      =  40.0;  // Distance between inside walls of vertical sections
overhang    =  12.5;  // Base extension past end of vertical sections
height      =  43.0;  // Height of vertical sections
vert_thick  =   2.0;  // Thickness of vertical sections
base_thick  =   3.0;  // Thickness of base
h1_dia      =  21.9;  // Diameter of valve body behind inlet port nut
h2_dia      =  15.3;  // Diameter of valve body behind 3/4-16 UNF threads
center      =  32.0;  // Height of inlet port centerline from bottom of base plate

module triangle (o_len, a_len, depth, center = false)
{
  centroid = center ? [-a_len / 3, -o_len / 3, -depth / 2] : [0, 0, 0];

  translate(centroid) linear_extrude (height = depth)
    polygon (points = [[0, 0] ,[a_len, 0], [0, o_len]], paths = [[0, 1, 2]]);
}

module bracket () {
  translate ([0, 0, base_thick])
    cube ([width, vert_thick, height]);
  translate ([0, vert_thick + length, base_thick])
    cube ([width, vert_thick, height]);
  translate ([0, -overhang, 0])
    cube ([width, (vert_thick * 2) + length + (overhang * 2), base_thick]);
}

module hole (hole_dia, y_pos) {
  translate ([width / 2, y_pos + -0.01, center]) {
    rotate ([90, 0, 180]) {
      hull () {
        cylinder (d = hole_dia, h = 0.01 + vert_thick + 0.01);
        translate ([0, hole_dia * 2, 0])
          cylinder (d = hole_dia, h = 0.01 + vert_thick + 0.01);
      }
    }
  }
}

module gusset (y_offset = 0, gusset_thick = vert_thick, o_scale = 1.5) {
  translate ([0, y_offset, base_thick])
    rotate ([180, 270, 0])
      triangle (overhang, overhang * o_scale, gusset_thick);

  translate ([width - gusset_thick, y_offset, base_thick])
    rotate ([180, 270, 0])
      triangle (overhang, overhang * o_scale, gusset_thick);

  translate ([gusset_thick, y_offset + vert_thick, base_thick])
    rotate ([0, 270, 0])
      triangle (overhang, overhang * o_scale, gusset_thick);

  translate ([width, y_offset + vert_thick, base_thick])
    rotate ([0, 270, 0])
      triangle (overhang, overhang * o_scale, gusset_thick);
}

difference () {
  union () {
    bracket ();
    gusset (0);
    gusset (vert_thick + length);
  }

  hole (h1_dia, 0);
  hole (h2_dia, vert_thick + length);
}
