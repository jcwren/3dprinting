pvc_dia     =  27.80; // Diameter of hole in PVC double tee
pvc_len     = 100.00; // Length of rod through PVC double tee
rod_dia     =  20.70; // Diameter of horizontal rods on stand
rod_spacing =  60.00; // CtC distance between horizontal rods
clamp_len   = 110.00; // Length of clamping area
screw_dia   =   4.40; // Hole diameter for clamping screws
nut_dia     =  10.10; // #8 nut is 11/32 diameter
nut_height  =   3.20; // #8 nut is 1/8 high
nut_offset  =   7.00; // Offset from edge for top and bottom nut
edge_radius =   1.00; // Radius on edge of clamp cube
fudge       =   0.01; // Fudge factor for rendering

$fn = 128;

module clamp () {
  difference () {
    union () {
      cylinder (d = pvc_dia, h = pvc_len);

      hull ()
        for (z = [0, -clamp_len])
          for (y = [rod_dia, -rod_dia])
            for (x = [rod_dia, -rod_dia])
              translate ([x + edge_radius * ((x < 0) ? 1 : -1),
                          y + edge_radius * ((y < 0) ? 1 : -1),
                          z + edge_radius * ((z < 0) ? 1 : -1)])
                sphere (r = edge_radius);
    }

    for (z = [1, -1])
      translate ([-(rod_dia + fudge), 0, -((clamp_len / 2) + (z * (rod_spacing / 2)))])
        rotate ([0, 90, 0])
          cylinder (d = rod_dia, h = (rod_dia * 2) + (fudge * 2));

    for (z = [nut_offset, (clamp_len / 2), clamp_len - nut_offset])
      translate ([0, rod_dia + fudge, -z])
        rotate ([90, 0, 0]) {
          cylinder (d = screw_dia, h = (rod_dia * 2) + (fudge * 2));
          translate ([0, 0, 0])
            cylinder (d = nut_dia, h = nut_height, $fn = 6);
          translate ([0, 0, (rod_dia * 2) + (fudge * 2) - nut_height])
            cylinder (d = nut_dia, h = nut_height, $fn = 6);
      }
  }
}

translate ([0, 0, 0.01])
  rotate ([270, 0, 270])
    difference () {
      clamp ();
      translate ([-(rod_dia + fudge), 0, -(clamp_len + fudge)])
        cube ([(rod_dia) * 2 + (fudge * 2), (rod_dia) * 2 + (fudge * 2), clamp_len + pvc_len + (fudge * 2)]);
    }
