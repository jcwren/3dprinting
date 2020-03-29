module scraper () {
  color ("magenta") {
    translate ([0, 0, cup_hgt + 2]) {
      rotate ([180, 0, 0]) {

        //
        //  Support flange
        //
        difference () {
          cylinder (d = scraper_outer_dia, h = scraper_hgt, $fn = sides);
          union () {
            translate ([0, 0, -render_fix]) {
              cylinder (d = scraper_inner_dia, h = scraper_hgt + (render_fix * 2), $fn = sides);
              translate ([0, 0, 2]) { // Edge ring
                difference () {
                  cylinder (d = cup_outer_dia + render_fix, h = scraper_hgt, $fn = sides);
                  cylinder (d = cup_inner_dia - render_fix, h = scraper_hgt, $fn = sides);
                }
              } // Edge ring
              translate ([0, 0, outer_overhang_hgt]) { // Shorten outer edge
                difference () {
                  cylinder (d = scraper_outer_dia + render_fix, h = scraper_hgt, $fn = sides);
                  cylinder (d = cup_outer_dia - render_fix, h = scraper_hgt, $fn = sides);
                }
              } // Shorten outer edge
            }
          }
        }
        
        //
        //  Wiper loop
        //
        difference () {
          angle = 45 + 90; // +90 because we're rotated 180 degrees
          x1_pos = sin (angle) * (scraper_inner_rad - treat_dia);
          y1_pos = cos (angle) * (scraper_inner_rad - treat_dia);
          
          hull () {
            translate ([x1_pos, y1_pos, 0]) 
              cylinder (d = treat_dia * 2, h = scraper_hgt, $fn = sides);
            for (i = [-16:4:16]) {
              translate ([sin (angle + i) * scraper_inner_rad, cos (angle + i) * scraper_inner_rad, 0])
                cylinder (d = 4.0, h = scraper_hgt, $fn = 64);
            }
          }
          hull () {
            translate ([x1_pos, y1_pos, -render_fix]) 
              cylinder (d = (treat_dia * 2) - 4, h = scraper_hgt + (render_fix * 2), $fn = sides);
            for (i = [-16:4:16]) {
              translate ([sin (angle + i) * scraper_inner_rad, cos (angle + i) * scraper_inner_rad, 0])
                cylinder (d = 0.01, h = scraper_hgt, $fn = 64);
            }
          }
        }
      }
    }
  }
}