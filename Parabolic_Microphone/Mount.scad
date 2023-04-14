use <threads.scad>

mount_width    =  70;      // Width of mount block (mm)
mount_height   =  10;      // Height of mount block from z=0 to base of parabola (mm)
nut_dia_832    =  10.10;   // #8 nut is 11/32 diameter
nut_height_832 =   3.20;   // #8 nut is 1/8 high
screw_dia_632  =   3.048;  // Hole diameter for a 6/32 screw (mm)
screw_dia_832  =   4.40;   // Hole diameter for a 8/32 screw (mm)
screw_inset    =   10;     // Screw hole inset from edge distance (mm)
hole_dia       =   1.5;    // Hole in center of reflector diameter (inches)
rod_dia        =   3.1;    // Hole diameter for center support rod (#12 wire, mm)
wire_dia       =   7.0;    // Hole diameter for cable to microphone (mm)
p_height       = 139.7;    // Height of parabola (5.5", in mm)
p_focal        = 285.7;    // Focal length (radius of parabola (22.5", in mm)
p_correction   =   2.7;    // Weird number to get mount to fit actual reflector (magic number)
bolt_height    =  15.0;    // Length of threads (from z=0, mm)
bolt_tpi       =   5;      // Threads per inch for bolt and nut
nut_dia        =  50;      // Diameter of nut (mm)
nut_height     =  10.0;    // Thickness of nut (mm)
flange_dia     =  55;      // Diameter of nut flange (mm)
flange_height  =   3.0;    // Height of nut flange (mm)
fudge          =   0.01;   // Prevent coplanar surfaces that cause ghost lines
detail         = 180;      // Sets $fn for features

plate_x = 60;
plate_y = 53;
plate_z = 3;
clamp_x = 51.5;
clamp_y = 43.5;
clamp_z = 9.3;

//
//
//
module right_triangle (side1, side2, corner_radius, triangle_height) {
  translate ([corner_radius, corner_radius, 0]) {
    hull () {
      %cylinder (r=corner_radius, h=triangle_height, $fn=detail);
      translate ([side1 - corner_radius * 2, 0, 0])
        cylinder(r=corner_radius, h=triangle_height, $fn=detail);
      translate ([0, side2 - corner_radius * 2, 0])
        cylinder (r=corner_radius, h=triangle_height, $fn=detail);
    }
  }
}

/*
Trapezoid
	Create a Basic Trapezoid (Based on Isosceles_Triangle)

            d
          /----\
         /  |   \
     a  /   H    \ c
       /    |     \
 angle ------------ angle
            b

	b: Length of side b
	angle: Angle at points angleAB & angleBC
	H: The 2D height at which the triangle should be cut to create the trapezoid
	heights: If vector of size 3 (Standard for triangles) both cd & da will be the same height, if vector have 4 values [ab,bc,cd,da] than each point can have different heights.
*/
module trapezoid (b, angle=60, H, height=1, heights=undef, center=undef, centerXYZ=[true,false,false]) {
	validAngle = (angle < 90);
	adX = H / tan(angle);

	// Calculate Heights at each point
	heightAB = ((heights==undef) ? height : heights[0])/2;
	heightBC = ((heights==undef) ? height : heights[1])/2;
	heightCD = ((heights==undef) ? height : heights[2])/2;
	heightDA = ((heights==undef) ? height : ((len(heights) > 3)?heights[3]:heights[2]))/2;

	// Centers
	centerX = (center || (center==undef && centerXYZ[0]))?0:b/2;
	centerY = (center || (center==undef && centerXYZ[1]))?0:H/2;
	centerZ = (center || (center==undef && centerXYZ[2]))?0:max(heightAB,heightBC,heightCD,heightDA);

	// Points
	y = H/2;
	bx = b/2;
	dx = (b-(adX*2))/2;

	pointAB1 = [centerX-bx, centerY-y, centerZ-heightAB];
	pointAB2 = [centerX-bx, centerY-y, centerZ+heightAB];
	pointBC1 = [centerX+bx, centerY-y, centerZ-heightBC];
	pointBC2 = [centerX+bx, centerY-y, centerZ+heightBC];
	pointCD1 = [centerX+dx, centerY+y, centerZ-heightCD];
	pointCD2 = [centerX+dx, centerY+y, centerZ+heightCD];
	pointDA1 = [centerX-dx, centerY+y, centerZ-heightDA];
	pointDA2 = [centerX-dx, centerY+y, centerZ+heightDA];

	validH = (adX < b/2);

	if (validAngle && validH) {
		polyhedron (
			points=[pointAB1, pointBC1, pointCD1, pointDA1,
						  pointAB2, pointBC2, pointCD2, pointDA2],
			faces=[
				[0, 1, 2],
				[0, 2, 3],
				[4, 6, 5],
				[4, 7, 6],
				[0, 4, 1],
				[1, 4, 5],
				[1, 5, 2],
				[2, 5, 6],
				[2, 6, 3],
				[3, 6, 7],
				[3, 7, 0],
				[0, 7, 4]]);
	} else {
		if (!validAngle)
      echo ("Trapezoid invalid, angle must be less than 90");
		else
      echo ("Trapezoid invalid, H is larger than triangle");
	}
}

module tripod_plate (plate=1) {
  trapezoid (b=clamp_x, angle=60, H=clamp_z, height=clamp_y, centerXYZ=[true,true,true]);

  if (plate)
      rotate ([90, 0, 0])
        translate ([-(plate_x/2), -(plate_y/2), -((clamp_z/2) + plate_z)+fudge])
          cube ([plate_x, plate_y, plate_z]);
}

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
      if (screw_dia) {
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
}

module parabola_mount () {
  difference () {
    union () {
      difference () {
        mount (w=mount_width, h=mount_height*2, detail=detail, screw_dia=0/*screw_dia_632*/);
        translate ([0, 0, (p_focal/p_correction)+mount_height])
          paraboloid (y=p_height, f=p_focal/p_correction, rfa=0, fc=1, detail=detail);
      }
      translate ([0, 0, -(9.3/2)])
        rotate ([90, 0, 0])
          tripod_plate (plate=0);
      translate ([0, 0, fudge])
        english_thread (diameter=hole_dia, threads_per_inch=bolt_tpi, length=(bolt_height+mount_height-fudge)/25.4);
    }
    union () {
      translate ([7.5, 0, 0])
        cylinder (d=rod_dia, h=mount_height+bolt_height+clamp_z+(2*fudge), $fn=detail);
      translate ([-7.5, 0, wire_dia/2])
        cylinder (d=wire_dia, h=mount_height+bolt_height+(2*fudge), $fn=detail);
      translate ([-7.5, 0, wire_dia])
        rotate ([90, 90, 0])
          cylinder (d=wire_dia, h=(mount_width/2)+fudge, $fn=detail);
     }
  }
}

module nut () {
  difference () {
    union () {
      cylinder (d=nut_dia, h=nut_height, $fn=6);
      cylinder (d=flange_dia, h=flange_height, $fn=detail);
    }
    translate ([0, 0, -fudge])
      english_thread (diameter=hole_dia+0.029, threads_per_inch=bolt_tpi, length=nut_height/25.4+(fudge*2), internal=true);
  }
}

module tripod_plate_test () {
  difference () {
    translate ([0, 0, 0.1])
      rotate ([90, 0, 0])
        tripod_plate ();
    translate ([-35, -30, -20])
      cube ([70, 47, 50]);
  }
}

*tripod_plate_test ();

union () {
  cube ([mount_width, 0.01, 0.01]);
  translate ([0, 0, 9.3])
    parabola_mount ();
  translate ([mount_width, 0, 0.01])
    nut ();
}
