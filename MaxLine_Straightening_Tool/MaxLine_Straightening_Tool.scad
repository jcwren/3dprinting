$fn     = 180.00;   // Number of sides in a circle
od      =  25.900;  // OD of MaxLine (1" + 0.02" printing fudge factor)
height  = od + 10;  // Height of wheel
axle    =   9.525;  // 3/8" screw for axle

module wheel () {
  difference () {
    cylinder (h = height, d = od * 2.4);

    union  () {
      translate ([0, 0, (height - od) / 2]) {
        difference () {
          cylinder (h = od, d = od * 4);
          translate ([0, 0, -0.01])
            cylinder (h = od + 0.02, d = od * 2);
        }
      }
      rotate_extrude (convexity = 10)
        translate ([od, height / 2, 0])
          circle (d = od);
    }

    translate ([0, 0, -0.01])
      cylinder (h = height + 0.02, d = axle);
  }
}

module half_wheel () {
  difference () {
    wheel ();
    translate ([0, 0, height / 2])
      cylinder (d = od * 2.5, h = (height / 2) + 0.01);
  }
}

half_wheel ();
