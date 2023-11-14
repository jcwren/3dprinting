sides=180;

body_diameter=28.4;

//
//  Adjust clip width accordingly.
//
clip_width=35 - (28.4 - body_diameter);
clip_depth=25;
clip_thickness=15;

intersection () {
  difference () {
    difference () {
      //
      //  Wall edge cube and clip cylinder
      //
      union () {
        translate ([-(clip_width / 2), 0, 0])
          cube ([clip_width, clip_depth, clip_thickness]);
        cylinder (d=clip_width, h=clip_thickness, $fn=sides);
      }

      //
      //  Remove inner material
      //
      translate ([0, 0, -0.1])
        cylinder (d=body_diameter, h=clip_thickness + 0.2, $fn=sides);
    }

    //
    //  Cuts off end of clip cylinder to make open clip
    //
    translate ([-(clip_width / 2), -34, -0.1])
      cube ([clip_width, 30, clip_thickness + 0.2]);

    //
    //  Screw hole and head recess
    //
    translate ([0, clip_depth + 0.1, clip_thickness / 2])
      rotate ([90, 0, 0])
        cylinder (d=4.5, h=20, $fn=sides);
    translate ([0, clip_depth - 8, clip_thickness / 2])
      rotate ([90, 0, 0])
        cylinder (d=8.1, h=20, $fn=sides);
  }

  //
  //  Make wall corners rounded
  //
  translate ([0, 4 + (30.7 - body_diameter), 0])
    cylinder (d=clip_width + 10 - (30.7 - body_diameter), h=15, $fn=sides);
}
