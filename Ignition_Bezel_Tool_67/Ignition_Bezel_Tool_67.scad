sides=360;

plug_dia      = 25.65;
plug_height   = 5.50;
ear_length    = 1.27;
ear_width     = 2.30;
handle_height = 25.40 / 2;
handle_width  = 5.00;

module plug () {
  translate ([0, 0, 0]) {
    cylinder (d=plug_dia, h=plug_height, $fn=sides);

    rotate ([0, 0, 0])
      cube ([(plug_dia / 2) + ear_length, ear_width, plug_height]);
    rotate ([0, 0, 120])
      cube ([(plug_dia / 2) + ear_length, ear_width, plug_height]);
    rotate ([0, 0, 240])
      cube ([(plug_dia / 2) + ear_length, ear_width, plug_height]);
  }
}

module handle () {
  translate ([-(handle_width / 2), -((plug_dia - 2) / 2), plug_height])
    cube ([handle_width, (plug_dia - 2), handle_height], center=false);
}

plug ();
handle ();
