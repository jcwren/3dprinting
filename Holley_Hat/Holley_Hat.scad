$fn       = 360;
inner_hgt =  20; // Height from bottom edge to inside top of hat
inner_dia = 128; // Inner diameter of hat
wall      =   2; // Thickness of walls
bolt_dia  =   7; // Diameter of 1/4-20 bolt

difference () {
  translate ([0, 0, 0])
    cylinder (d = inner_dia + (wall * 2), h = inner_hgt + wall);
  translate ([0, 0, wall])
    cylinder (d = inner_dia, h = inner_hgt + 0.01);
  translate ([0, 0, -0.01])
    cylinder (d = bolt_dia, h = wall + 0.02);
}
