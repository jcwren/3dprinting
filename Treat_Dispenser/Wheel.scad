use <motor_hub.scad>;

module wheel () {
  color ("dodgerblue") {
    difference () {
      difference () {
        cylinder (d = wheel_dia, h = wheel_hgt, $fn = sides);
    
        for (i = [0:(360 / treat_holes):359]) {
          x1 = sin (i) * treat_offset;
          y1 = cos (i) * treat_offset;
          x2 = sin (i) * wheel_rad; 
          y2 = cos (i) * wheel_rad;
        
          hull () {
            translate ([x1, y1, -render_fix])
              cylinder (d = treat_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
            translate ([x2, y2, -render_fix])
              cylinder (d = treat_dia, h = treat_hgt + (render_fix * 2), $fn = sides);
          }
          
          x3 = sin (i + 10) * (treat_offset - 5.2);
          y3 = cos (i + 10) * (treat_offset - 5.2);
          x4 = sin (i + 10) * (treat_offset + 5.2);
          y4 = cos (i + 10) * (treat_offset + 5.2);
          x5 = sin (i +  0) * (treat_offset - 5.2);
          y5 = cos (i +  0) * (treat_offset - 5.2);
          
          hull () {
            translate ([x3, y3, (wheel_hgt / 1) + 1])
              sphere (d = wheel_hgt * 2, $fn = sides);          
            translate ([x4, y4, (wheel_hgt / 1) + 1])
              sphere (d = wheel_hgt * 2, $fn = sides);
            translate ([x5, y5, (wheel_hgt / 1) + 1])
              sphere (d = wheel_hgt * 2, $fn = sides);
          }
        }
      }
      
      //
      //  Hole for motor shaft so it actually goes through wheel
      //
      translate ([0, 0, -render_fix])
        cylinder (d = motor_shaft_dia, h = motor_shaft_hgt + (render_fix * 2), $fn = sides);
    }
    
    motor_hub (motor_shaft_dia, motor_shaft_hgt);
  }
}