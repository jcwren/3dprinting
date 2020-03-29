module cup () {
  color ("greenyellow", 0.5) {
    difference () {
      cylinder (d = cup_outer_dia, h = cup_hgt, $fn = sides);
      
      translate ([0, 0, cup_wall])
        cylinder (d = cup_inner_dia, h = (cup_hgt - cup_wall) + render_fix, $fn = sides);
      
      //
      //  Treat hole
      //
      difference () {
        angle = 45;
        x1_pos = sin (angle) * (cup_inner_rad - treat_dia);
        y1_pos = cos (angle) * (cup_inner_rad - treat_dia);
        
        hull () {
          translate ([x1_pos, y1_pos, -render_fix]) 
            cylinder (d = treat_dia + 5, h = cup_wall + (render_fix * 2), $fn = sides);
          for (i = [-10:2:10]) {
            a2 = angle + i;
            x2 = sin (a2) * (cup_inner_rad - (cup_wall / 2));
            y2 = cos (a2) * (cup_inner_rad - (cup_wall / 2));
            translate ([x2, y2, 0])
              cylinder (d = cup_wall, h = cup_wall + (render_fix * 2), $fn = 64);
          }
        }
      }
      
      //
      //  Shaft hole
      //
      translate ([0, 0, -render_fix])
        cylinder (d = shaft_base_dia, h = shaft_base_hgt + (render_fix * 2), $fn = sides);
      
      //
      //  Screw holes
      //
      for (i = [0:90:359]) {
        x = sin (i) * shaft_screw_rad;
        y = cos (i) * shaft_screw_rad;
        
        translate ([x, y, -render_fix])
          cylinder (d = shaft_screw_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
      }
    }
  }
}