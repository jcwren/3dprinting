sides=360;

//
//  Halogen type body diameter is 41.7mm
//  LED type body diameter is 39.4mm (2.3mm smaller)
//
body_diameter=39.4;

//
//  Adjust clip width accordingly.
//
clip_width=48 - (41.7 - body_diameter);
clip_depth=32;
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
    translate ([-(clip_width / 2), -38, -0.1])
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
  translate ([0, 4 + (41.7 - body_diameter), 0])
    cylinder (d=clip_width + 10 - (41.7 - body_diameter), h=15, $fn=sides);
}