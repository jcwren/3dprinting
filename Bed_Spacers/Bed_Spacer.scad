include <rounded_corners.scad>

function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;

$fn = 360;
xy_dim = in2mm (2.25);
z_dim = in2mm (0.25);
corner_radius = in2mm (0.125);
hole_dia = in2mm ((1 / 16) * 7);

difference () {
  roundedcube ([xy_dim, xy_dim, z_dim], center=true, radius=corner_radius, apply_to="z");
  cylinder (d=hole_dia, h=z_dim, center=true);
}