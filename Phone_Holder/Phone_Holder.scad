$fn            = 180;

case_width     = 83.0;
case_thickness = 11.0;
case_height    = 75.0;
case_wall      =  2.0;
usbc_width     = 12.0;
usbc_depth     =  6.1;
hole_x         = 26.0;
hole_y         =  3.4;
hole_z         = 40.0;

half_outer_width = (case_width / 2) - (case_thickness / 2);
case_wall_x2     = case_wall * 2;

module shell_sides () {
  linear_extrude (case_height) {
    difference () {
      hull () {
        translate ([-half_outer_width, 0, 0])
          circle (d = case_thickness + case_wall_x2);
        translate ([half_outer_width, 0, 0])
          circle (d = case_thickness + case_wall_x2);
      }
      hull () {
        translate ([-half_outer_width, 0, 0])
          circle (d = case_thickness);
        translate ([half_outer_width, 0, 0])
          circle (d = case_thickness);
      }
      translate ([-((case_width - (case_thickness / 2)) / 2), 0, 0])
        square ([case_width - (case_thickness / 2), case_thickness]);
    }
  }
}

module shell_bottom () {
  translate ([0, 0, -case_wall]) {
    linear_extrude (case_wall) {
      difference () {
        hull () {
          translate ([-half_outer_width, 0, 0])
            circle (d = case_thickness + case_wall_x2);
          translate ([half_outer_width, 0, 0])
            circle (d = case_thickness + case_wall_x2);
        }
        hull () {
          translate ([-((usbc_width - usbc_depth) / 2), 0, 0])
            circle (d = usbc_depth);
          translate ([(usbc_width - usbc_depth) / 2, 0, 0])
            circle (d = usbc_depth);
        }
      }
    }
  }
}

module post () {
  hole_rad = 0.5;
  wall     = hole_y * 2;

  translate ([0, -(case_thickness / 2) - case_wall, -case_wall]) {
    difference () {
      hull () {
        translate ([-(hole_x + wall) / 2, 0, hole_rad])              sphere (r = hole_rad);
        translate ([ (hole_x + wall) / 2, 0, hole_rad])              sphere (r = hole_rad);
        translate ([-(hole_x + wall) / 2, 0, hole_z - hole_rad])     sphere (r = hole_rad);
        translate ([ (hole_x + wall) / 2, 0, hole_z - hole_rad])     sphere (r = hole_rad);

        translate ([-(hole_x + wall) / 2, -wall, hole_rad])          sphere (r = hole_rad);
        translate ([ (hole_x + wall) / 2, -wall, hole_rad])          sphere (r = hole_rad);
        translate ([-(hole_x + wall) / 2, -wall, hole_z - hole_rad]) sphere (r = hole_rad);
        translate ([ (hole_x + wall) / 2, -wall, hole_z - hole_rad]) sphere (r = hole_rad);
      }

      translate ([-hole_x / 2, -(case_wall + (hole_rad * 3)), -1])
        cube ([hole_x, hole_y, hole_z - (wall / 2)]);
    }
  }
}

shell_bottom ();
shell_sides ();
post ();
