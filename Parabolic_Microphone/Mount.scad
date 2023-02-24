use <threads.scad>

mount_width   =  70;      // Width of mount block (mm)
mount_height  =  10;      // Height of mount block from z=0 to base of parabola (mm)
screw_dia_632 =   3.048;  // Hole diameter for a 6/32 screw (mm)
screw_inset   =   10;     // Screw hole inset from edge distance (mm)
hole_dia      =   1.5;    // Hole in center of reflector diameter (inches)
rod_dia       =   3.1;    // Diameter for center support rod (#12 wire, mm)
p_height      = 139.7;    // Height of parabola (5.5", in mm)
p_focal       = 285.7;    // Focal length (radius of parabola (22.5", in mm)
p_correction  =   3;      // Weird number to get mount to fit actual reflector (magic number)
bolt_height   =  15.0;    // Length of threads (from z=0, mm)
bolt_tpi      =   5;      // Threads per inch for bolt and nut
nut_dia       =  50;      // Diameter of nut (mm)
nut_height    =  10.0;    // Thickness of nut (mm)
flange_dia    =  55;      // Diameter of nut flange (mm)
flange_height =   3.0;    // Height of nut flange (mm)
fudge         =   0.01;   // Prevent coplanar surfaces that cause ghost lines
detail        = 180;      // Sets $fn for features

//
// y = height of paraboloid
// f = focus distance
// rfa = radius of the focus area : 0 = point focus
// fc : 1 = center paraboloid in focus point(x=0, y=f); 0 = center paraboloid on top (x=0, y=0)
// detail = $fn of cone
//
module paraboloid (y=10, f=5, rfa=0, fc=1, detail=44) {
  hi = (y + 2 * f) / sqrt (2);            // height and radius of the cone -> alpha = 45° -> sin(45°)=1/sqrt(2)
  x = 2 * f * sqrt (y / f);               // x  = half size of parabola

  translate ([0, 0, -f * fc])             // center on focus
    rotate_extrude ($fn=detail)           // extrude paraboild
      intersection () {
        translate ([rfa, 0, 0])           // translate for fokus area
          union () {                      // adding square for focal area
            projection (cut=true)         // reduce from 3D cone to 2D parabola
              translate ([0, 0, f * 2])
                rotate ([45, 0, 0])       // rotate cone 45° and translate for cutting
            translate ([0, 0, -hi / 2])
              cylinder (h=hi, r1=hi, r2=0, center=true, $fn=detail); // center cone on tip
            translate ([-(rfa + x), 0])
              square ([rfa + x, y]);      // focal area square
          }
          square ([2 * rfa + x, y + 1]);  // cut of half at rotation center
      }
}

module mount (w=50, h=20, detail=90, screw_dia=3) {
  translate ([-(w / 2), -(w / 2), 0]) {
    difference () {
      cube ([w, w, h]);
      translate ([screw_inset, screw_inset, -fudge])
        cylinder (d=screw_dia, h=h, $fn=detail);
      translate ([screw_inset, w-screw_inset, -fudge])
        cylinder (d=screw_dia, h=h, $fn=detail);
      translate ([w-screw_inset, screw_inset, -fudge])
        cylinder (d=screw_dia, h=h, $fn=detail);
      translate ([w-screw_inset, w-screw_inset, -fudge])
        cylinder (d=screw_dia, h=h, $fn=detail);
    }
  }
}

module parabola_mount () {
  difference () {
    union () {
      difference () {
        mount (w=mount_width, h=mount_height*2, detail=detail, screw_dia=screw_dia_632);
        translate ([0, 0, (p_focal/p_correction)+mount_height])
          paraboloid (y=p_height, f=p_focal/p_correction, rfa=0, fc=1, detail=detail);
      }
      translate ([0, 0, fudge])
        english_thread (diameter=hole_dia, threads_per_inch=bolt_tpi, length=(bolt_height+mount_height-fudge)/25.4);
    }
    translate ([0, 0, -fudge])
      cylinder (d=rod_dia, h=mount_height+bolt_height+(2*fudge), $fn=detail);
  }
}

module nut () {
  difference () {
    union () {
      cylinder (d=nut_dia, h=nut_height, $fn=6);
      cylinder (d=flange_dia, h=flange_height, $fn=detail);
    }
    translate ([0, 0, -fudge])
      english_thread (diameter=hole_dia+0.028, threads_per_inch=bolt_tpi, length=nut_height/25.4+(fudge*2), internal=true);
  }
}

union () {
  cube ([mount_width, 0.01, 0.01]);
  translate ([0, 0, 0])
    parabola_mount ();
  translate ([mount_width, 0, 0.01])
    nut ();
}