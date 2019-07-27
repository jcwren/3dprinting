function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;

width = in2mm (5.5);
height = in2mm (2.75);
depth = in2mm (2.25);
wall = in2mm (0.0625);
radius = in2mm (0.250);
gauge_dia = in2mm (2.10);

box_outer = 
  [[0, 0, 0], 
   [width, 0, 0], 
   [0, depth, 0,], 
   [width, depth, 0]];
box_inner = 
  [[0, 0, 0], 
   [width - (wall * 2), 0, 0], 
   [0, depth - (wall * 2), 0,], 
   [width - (wall * 2), depth - (wall * 2), 0]];

module rounded_box (points, radius, height) {
  hull () {
    for (p = points) {
      translate (p) 
        cylinder (r=radius, h=height);
    }
  }
}

module box () {
  difference () {
    translate ([0, 0, 0])
      rounded_box (box_outer, radius, height);
    translate ([wall, wall, wall])
      rounded_box (box_inner, radius, height);
  }
}

module gauge_hole (x) {
  translate ([x, -(radius + 0.01), height / 2])
    rotate ([0, 90, 90])
      cylinder (d=gauge_dia, h=radius * 2);
}

difference () {
  box ();
  gauge_hole (in2mm (1.375));
  gauge_hole (width - in2mm (1.375));
}