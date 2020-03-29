module scraper () {
  color ("magenta") {
    angles = [0, 90];
    
    difference () {
      union () {
        translate ([0, 0, wheel_z_top + 1]) 
          linear_extrude (cup_hgt - (wheel_z_top + 1))
            arc (scraper_inner_rad, angles, cup_wall, sides);  
        translate ([0, 0, cup_hgt - scraper_overhang_hgt])
          linear_extrude (scraper_overhang_hgt)
            arc (cup_outer_rad, angles, cup_wall, sides);
        translate ([0, 0, cup_hgt])
          linear_extrude (cup_wall)
            arc (scraper_inner_rad, angles, cup_wall * 3, sides);
    
        fa = angles [0];
        la = angles [1];
        ma = ((la - fa) / 2) + fa;
                        
        a = [[ la -  2, scraper_inner_rad - 1],
             [ la - 28, scraper_inner_rad - 2],
             [ la - 16, scraper_inner_rad - 32],
             [ ma +  0, scraper_inner_rad - (treat_dia * 1.8) - 2.4],
             [ fa + 16, scraper_inner_rad - 32],
             [ fa + 28, scraper_inner_rad - 2],
             [ fa +  2, scraper_inner_rad - 1]];
             
        b = [[ fa +  2, scraper_inner_rad + 1],
             [ fa + 30, scraper_inner_rad],
             [ fa + 20, scraper_inner_rad - 30],
             [ ma +  0, scraper_inner_rad - (treat_dia * 1.8)],
             [ la - 20, scraper_inner_rad - 30],
             [ la - 30, scraper_inner_rad],
             [ la -  2, scraper_inner_rad + 1]];

        bez1 = [
          for (i = [0 : len (a) - 1]) 
            [sin (a [i][0]) * a [i][1], 
             cos (a [i][0]) * a [i][1]]
        ];
        bez2 = [
          for (i = [0 : len (b) - 1]) 
            [sin (b [i][0]) * b [i][1], 
             cos (b [i][0]) * b [i][1]]
        ];
          
        nbez1 = bezier_polyline (bez1, splinesteps = 64, N = 3);
        nbez2 = bezier_polyline (bez2, splinesteps = 64, N = 3);
        nbez3 = concat (nbez1, nbez2);
        
        translate ([0, 0, wheel_z_top + 1])
          linear_extrude_bezier (nbez3, (cup_hgt + cup_wall) - (wheel_z_top + 1));
      }

      //
      //  44 degree chamfer on leading edge of scraper (45 leaves a hair thin line)
      //
      cube_x = cup_wall * 1.4;
      cube_y = cup_wall * 3;
      cube_center = sqrt ((cube_x * cube_x) + (cube_x * cube_x)) / 2;
      
      translate ([cup_inner_rad - cup_wall, -cube_center, (wheel_z_top + 1) - render_fix])
        rotate ([0, 0, 44])
          cube ([cube_x, cube_y, ((cup_hgt + cup_wall) - (wheel_z_top + 1)) + (render_fix * 2)]);
    }
  }    
}