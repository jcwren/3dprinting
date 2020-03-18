//
//  Bars for horizontal LEDs. You will need:
//    3x with 12 LEDs
//    1x with 13 LEDs
//    2x with 18 LEDs
//
//  Some manual trimming will be needed to clear the RPi mounting screws
//  and header pins. It's easier than trying to rework the CAD to remove
//  a portion to accomodate them. Plus, overhangs :(
//

leds        =   5.00;
bar_spacing =  10.00;
bar_width   =  10.00;
bar_height  =  10.50;
led_dia     =   5.30;
led_base    =   5.90;
led_flange  =   1.60;
sides       = 360.00;

difference () {
  cube ([(leds * bar_spacing) + bar_spacing, bar_width, bar_height]);
  
  for (i = [0 : (leds - 1)]) {
    translate ([bar_spacing + (i * bar_spacing), bar_width / 2, -0.01]) {
      cylinder (d = led_dia, h = bar_height + 0.02, $fn = sides);
      cylinder (d = led_base, h = led_flange, $fn = sides);
    }
    
    translate ([bar_spacing + (i * bar_spacing), bar_width / 2, bar_height - 1]) {
      cylinder (d1 = led_dia, d2 = led_dia + 1.5, h = 1.01, $fn = sides);
    }
  }
}
