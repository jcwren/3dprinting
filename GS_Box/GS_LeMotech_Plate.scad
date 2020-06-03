$fn             =  64.0;

plate_width     = 100.5;
plate_length    = 171.5;
plate_thickness =   1.6;
plate_screw_dia =   3.3;
plate_screw_x1  =   0.0;
plate_screw_x2  =  90.5;
plate_screw_y1  =   0.0;
plate_screw_y2  =  61.0;
plate_screw_y3  = 161.5;

board_screw_dia =   3.3;
board_screw_x1  =   0.0;
board_screw_x2  =  75.0;
board_screw_y1  =   0.0;
board_screw_y2  =  95.0;

linear_extrude (plate_thickness) {
  difference () {
    union () {
      translate ([0, 0, 0])
        square ([plate_width, plate_length]);
      translate ([(plate_width / 2) - 5, -6, 0])
        square ([10, 6]);
    }

    translate ([22, 0, 0])
      square ([5, 7]);

    translate ([(plate_width - plate_screw_x2) / 2, (plate_length - plate_screw_y3) / 2, 0]) {
      translate ([plate_screw_x1, plate_screw_y1, 0])
        circle (d = plate_screw_dia);
      translate ([plate_screw_x1, plate_screw_y2, 0])
        circle (d = plate_screw_dia);
      translate ([plate_screw_x1, plate_screw_y3, 0])
        circle (d = plate_screw_dia);
      translate ([plate_screw_x2, plate_screw_y1, 0])
        circle (d = plate_screw_dia);
      translate ([plate_screw_x2, plate_screw_y2, 0])
        circle (d = plate_screw_dia);
      translate ([plate_screw_x2, plate_screw_y3, 0])
        circle (d = plate_screw_dia);
    }

    translate ([(plate_width - board_screw_x2) / 2, 30, 0])
    {
      translate ([board_screw_x1, board_screw_y1, 0])
        circle (d = board_screw_dia);
      translate ([board_screw_x1, board_screw_y2, 0])
        circle (d = board_screw_dia);
      translate ([board_screw_x2, board_screw_y1, 0])
        circle (d = board_screw_dia);
      translate ([board_screw_x2, board_screw_y2, 0])
        circle (d = board_screw_dia);
    }
  }
}
