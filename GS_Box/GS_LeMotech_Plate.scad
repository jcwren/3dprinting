$fn             =  64.0;

plate_width     = 100.0;
plate_length    = 170.0;
plate_thickness =   1.5;
plate_screw_dia =   3.2;

board_screw_x   =  75.0;
board_screw_y   =  95.0;
board_screw_dia =   3.2;

linear_extrude (plate_thickness) {
  difference () {
    square ([plate_width, plate_length]);

    translate ([5, 5, 0]) {
      translate ([0, 0, 0])
        circle (d = plate_screw_dia);
      translate ([0, 60, 0])
        circle (d = plate_screw_dia);
      translate ([0, 160, 0])
        circle (d = plate_screw_dia);
      translate ([90, 0, 0])
        circle (d = plate_screw_dia);
      translate ([90, 60, 0])
        circle (d = plate_screw_dia);
      translate ([90, 160, 0])
        circle (d = plate_screw_dia);
    }
    
    translate ([(plate_width - board_screw_x) / 2, 30, 0])
    {
      translate ([0, 0, 0])
        circle (d = board_screw_dia);
      translate ([board_screw_x, 0, 0])
        circle (d = board_screw_dia);
      translate ([0, board_screw_y, 0])
        circle (d = board_screw_dia);
      translate ([board_screw_x, board_screw_y, 0])
        circle (d = board_screw_dia);
    }
  }
}