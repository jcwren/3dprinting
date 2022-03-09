$fn     = 90;
bat_x   = 16.50; // Thickness of battery (actual is 16.75)
bat_y   = 50.00; // Width of battery (actual is 49.25)
wall    =  2.00; // Thickness of holder walls & floor
hgt     = 35.00; // Height of walls
n_wells =  6;    // Number of wells

module battery_well () {
  hull () {
    translate ([bat_x / 2, bat_x / 2, 0])
      cylinder (d = bat_x, h = hgt);
    translate ([bat_x / 2, bat_y - (bat_x / 2), 0])
      cylinder (d = bat_x, h = hgt);
  }
}

module battery_wells () {
  for (i = [0 : n_wells - 1])
    translate ([wall + ((bat_x + wall) * i), wall, 0])
      battery_well ();
}

module exterior () {
  corners = [
    [wall,                     wall,         0],
    [(bat_x + wall) * n_wells, wall,         0],
    [wall,                     bat_y + wall, 0],
    [(bat_x + wall) * n_wells, bat_y + wall, 0],
  ];

  hull ()
    for (i = [0 : len (corners) - 1])
      translate (corners [i])
        cylinder (r = wall, h = hgt);
}

difference () {
  translate ([0, 0, 0])
    exterior ();
  translate ([0, 0, wall])
    battery_wells ();
}
