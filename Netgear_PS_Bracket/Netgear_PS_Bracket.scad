ngps_w         = 53.5; // Width of ngps box
ngps_d         = 32.5; // Depth of ngps box
ngps_h         = 60.0; // Height of ngps box
frame_ears     = 10.0; // Width of ears on either side of frame
frame_wall     =  2.5; // Thickness of frame back and sides
screw_body_dia =  4.5; // #8 pan head screw body diameter (0.164")

module back_plate () {
  translate ([0, 0, 0])
    cube ([ngps_w + (frame_ears * 2) + (frame_wall * 2), frame_wall, ngps_h + frame_wall]);
}

module side_supports_org () {
  translate ([frame_ears, 0, 0])
    cube ([frame_wall, ngps_d + (frame_wall * 2), ngps_h + frame_wall]);
  translate ([frame_ears + frame_wall + ngps_w, 0, 0])
    cube ([frame_wall, ngps_d + (frame_wall * 2), ngps_h + frame_wall]);
}

module side_support (x_pos) {
  difference () {
    translate ([x_pos, 0, 0])
      rotate ([0, 270, 0])
        linear_extrude (height = frame_wall)
          polygon (points = [[0,                  0],
                             [0,                  ngps_d + (frame_wall * 2)],
                             [frame_wall * 3,     ngps_d + (frame_wall * 2)],
                             [ngps_h + frame_wall, frame_wall],
                             [ngps_h + frame_wall, 0]]);

    translate ([x_pos - 0.00, 0, 0])
      rotate ([0, 270, 0])
        linear_extrude (height = frame_wall)
          polygon (points = [[frame_wall * 3, frame_wall * 3],
                             [frame_wall * 3, ngps_d - (frame_wall * 1)],
                             [ngps_h - (frame_wall * 4), frame_wall * 3],
                             [ngps_h - (frame_wall * 4), frame_wall * 3]]);
   }
 }

module side_supports () {
  for (x = [0, ngps_w + frame_wall])
    side_support (frame_ears + frame_wall + x);
}

module bottom_supports () {
  translate ([frame_ears + frame_wall, frame_wall, 0])
    difference () {
      cube ([ngps_w, ngps_d + frame_wall, frame_wall]);
      translate ([frame_wall * 2, frame_wall * 2, -0.01])
        cube ([ngps_w - (frame_wall * 4), ngps_d - (frame_wall * 4), frame_wall + 0.02]);
    }
}

module front_support () {
  translate ([frame_ears + frame_wall, ngps_d + frame_wall, frame_wall])
    cube ([ngps_w, frame_wall, frame_wall * 2]);
}

module screw_holes () {
  for (x = [0, frame_ears + frame_wall + ngps_w + frame_wall])
    for (z = [frame_ears / 2, (ngps_h + frame_wall) - (frame_ears / 2)])
      translate ([x + (frame_ears / 2), frame_wall + 0.01, z])
        rotate ([90, 0, 0])
          cylinder (d = screw_body_dia, h = frame_wall + 0.02, $fn = 180);
}

module ngps_frame () {
  back_plate ();
  side_supports ();
  bottom_supports ();
  front_support ();
}

module frame () {
  difference () {
    ngps_frame ();
    screw_holes ();
  }
}

rotate ([90, 0, 0]) {
  frame ();

  *translate ([frame_ears + frame_wall, frame_wall, frame_wall])
    cube ([rak_w, rak_d, rak_h]);
}
