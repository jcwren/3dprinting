//
//  Bars for veritical LEDs. You will need:
//    1x with 3 LEDs
//    1x with 6 LEDs
//    1x with 8 LEDs
//
//  Some manual trimming will be needed to clear the M3 mounting hole
//  (upper right corner). The bars are all the same length because
//  the bezel is clear area is the same for all 3 columns.
//

leds        =   8.00;
max_leds    =   8.00;
bar_spacing =   7.25;
bar_width   =  12.00;
bar_height  =  10.50;
bar_margin  =  10.00;
led_dia     =   5.30;
led_base    =   5.90;
led_flange  =   1.60;
sides       = 360.00;
bar_length  = (bar_margin * 2) + ((max_leds - 1) * bar_spacing);

difference () {
  cube ([bar_length, bar_width, bar_height]);
  
  for (i = [0 : (leds - 1)]) {
    translate ([bar_margin + (i * bar_spacing), bar_width / 2, -0.01]) {
      cylinder (d = led_dia, h = bar_height + 0.02, $fn = sides);
      cylinder (d = led_base, h = led_flange, $fn = sides);
    }
    
    translate ([bar_margin + (i * bar_spacing), bar_width / 2, bar_height - 1]) {
      cylinder (d1 = led_dia, d2 = led_dia + 1.5, h = 1.01, $fn = sides);
    }
  }
}
