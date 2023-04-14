rak_w          = 68.5; // Width of RAK box
rak_d          = 58.0; // Depth of RAK box
rak_h          = 60.0; // Height of RAK box
frame_ears     = 10.0; // Width of ears on either side of frame
frame_wall     =  2.5; // Thickness of frame back and sides
screw_body_dia =  4.5; // #8 pan head screw body diameter (0.164")

module back_plate () {
  translate ([0, 0, 0])
    cube ([rak_w + (frame_ears * 2) + (frame_wall * 2), frame_wall, rak_h + frame_wall]);
}

module side_supports_org () {
  translate ([frame_ears, 0, 0])
    cube ([frame_wall, rak_d + (frame_wall * 2), rak_h + frame_wall]);
  translate ([frame_ears + frame_wall + rak_w, 0, 0])
    cube ([frame_wall, rak_d + (frame_wall * 2), rak_h + frame_wall]);
}

module side_support (x_pos) {
  difference () {
    translate ([x_pos, 0, 0])
      rotate ([0, 270, 0])
        linear_extrude (height = frame_wall)
          polygon (points = [[0,                  0],
                             [0,                  rak_d + (frame_wall * 2)],
                             [frame_wall * 3,     rak_d + (frame_wall * 2)],
                             [rak_h + frame_wall, frame_wall],
                             [rak_h + frame_wall, 0]]);

    translate ([x_pos - 0.00, 0, 0])
      rotate ([0, 270, 0])
        linear_extrude (height = frame_wall)
          polygon (points = [[frame_wall * 3, frame_wall * 3],
                             [frame_wall * 3, rak_d - (frame_wall * 1)],
                             [rak_h - (frame_wall * 4), frame_wall * 3],
                             [rak_h - (frame_wall * 4), frame_wall * 3]]);
   }
 }

module side_supports () {
  for (x = [0, rak_w + frame_wall])
    side_support (frame_ears + frame_wall + x);
}

module bottom_supports () {
  translate ([frame_ears + frame_wall, frame_wall, 0])
    difference () {
      cube ([rak_w, rak_d + frame_wall, frame_wall]);
      translate ([frame_wall * 2, frame_wall * 2, -0.01])
        cube ([rak_w - (frame_wall * 4), rak_d - (frame_wall * 4), frame_wall + 0.02]);
    }
}

module front_support () {
  translate ([frame_ears + frame_wall, rak_d + frame_wall, frame_wall])
    cube ([rak_w, frame_wall, frame_wall * 2]);
}

module screw_holes () {
  for (x = [0, frame_ears + frame_wall + rak_w + frame_wall])
    for (z = [frame_ears / 2, (rak_h + frame_wall) - (frame_ears / 2)])
      translate ([x + (frame_ears / 2), frame_wall + 0.01, z])
        rotate ([90, 0, 0])
          cylinder (d = screw_body_dia, h = frame_wall + 0.02, $fn = 180);
}

module rak_frame () {
  back_plate ();
  side_supports ();
  bottom_supports ();
  front_support ();
}

module frame () {
  difference () {
    rak_frame ();
    screw_holes ();
  }
}

rotate ([90, 0, 0]) {
  frame ();

  *translate ([frame_ears + frame_wall, frame_wall, frame_wall])
    cube ([rak_w, rak_d, rak_h]);
}
