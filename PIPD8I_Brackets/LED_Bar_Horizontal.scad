//
//  Bars for horizontal LEDs. You will need:
//    2x with 12 LEDs
//    1x with 13 LEDs
//    1x with 17 LEDs
//    1x with 18 LEDs
//

leds        =  17.00;
bar_spacing =  10.00;
bar_width   =  10.00;
bar_height  =  10.50;
led_dia     =   5.30;
led_base    =   5.90;
led_flange  =   1.60;
sides       = 360.00;

module bar (isWide, skip6th) {
  adj = isWide ? 0.1 : 0.0;
  
  difference () {
    adjLEDs = leds + (skip6th ? 1 : 0);
    
    cube ([(adjLEDs * bar_spacing) + bar_spacing, bar_width, bar_height]);
    
    for (i = [0 : (adjLEDs - 1)]) {
      if (!skip6th || (i != 5)) {
        translate ([bar_spacing + (i * bar_spacing), bar_width / 2, -0.01]) {
          cylinder (d = led_dia + adj, h = bar_height + 0.02, $fn = sides);
          cylinder (d = led_base + adj, h = led_flange, $fn = sides);
        }
        
        translate ([bar_spacing + (i * bar_spacing), bar_width / 2, bar_height - 1]) {
          cylinder (d1 = led_dia + adj, d2 = led_dia + 1.5, h = 1.01, $fn = sides);
        }
      }
    }
    
    if (isWide) {
      screw_dia  =  5.25;
      screw_hgt  =  2.45;
      conn_width =  1.90;
      conn_hgt   =  2.30;
      conn_len   = 50.00;
      res_len    = 10.00;
      res_dia    =  2.45;
      rpi_ctc    = 58.00;
      
      if (!skip6th) {
        translate ([(((bar_spacing * 7) - rpi_ctc) / 2) + bar_spacing, (bar_width / 2), -0.01]) {
          translate ([0, -4.50, 0]) {
            cylinder (d = screw_dia, h = screw_hgt, $fn = sides);    
            translate ([rpi_ctc, 0, 0])
              cylinder (d = screw_dia, h = screw_hgt, $fn = sides);   
          }            
        }
      } else {
        translate ([(((bar_spacing * 7) - rpi_ctc) / 2) + bar_spacing, (bar_width / 2), -0.01]) {
          translate ([0, 5.00, 0]) {
            cylinder (d = screw_dia, h = screw_hgt, $fn = sides);    
            translate ([rpi_ctc, 0, 0])
              cylinder (d = screw_dia, h = screw_hgt, $fn = sides);   
          }            
          translate ([(rpi_ctc - conn_len) / 2, (bar_width / 2) - (conn_width - 0.01), 0])
            cube ([conn_len, conn_width, conn_hgt]);
        }
        
        translate ([(bar_spacing * 6) - 5, -0.01, -0.01])
          cube ([res_len, res_dia, res_dia]);
        translate ([-4.00, (bar_width / 2) - 2, -0.01])
          cube ([res_len, res_dia, res_dia]);
      }
    }
  }
}

//
//  Print coned side down because otherwise the cutouts need supports, plus we
//  want the pretty side against the bed.
//
rotate (a = [180, 0, 0])
  translate ([0, -bar_width, -bar_height])
    bar ((leds >= 17), (leds == 17));
