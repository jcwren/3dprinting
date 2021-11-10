$fn           = 180;      // Number of sides in a circle
pipe_od       =  25.4;    // OD of pipe
bender_radius = 203.2;    // Bending radius of 3/4" Maxline is 8" (8" to 10" OK)
straight_len  =  75;      // Length of straight portion
render_fix    =   0.01;

translate ([0, 0, (pipe_od / 2) + 1]) {
  difference () {
    rotate_extrude (convexity = 10)
      translate ([bender_radius / 2, 0, 0])
        circle (d = pipe_od);
    translate ([-120, 0, -((pipe_od / 2) + render_fix)])
      cube ([240, 120, pipe_od + (render_fix * 2)]);
    translate ([0, -120, -((pipe_od / 2) + render_fix)])
      cube ([120, 120, pipe_od + (render_fix * 2)]);
  }

  translate ([-(bender_radius / 2), 0, 0])
    rotate ([90, 0, 180])
      cylinder (d = pipe_od, h = straight_len);
  translate ([0, -(bender_radius / 2), 0])
    rotate ([0, 270, 180])
      cylinder (d = pipe_od, h = straight_len);
}
