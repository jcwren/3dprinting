$fn       = 90;
bat_x     = 17.50; // Thickness of battery
bat_y     = 26.50; // Width of battery
wall      =  1.00; // Thickness of holder walls & floor
hgt       = 15.00; // Height of walls
n_wells_x =  6;    // Number of wells on x-axis
n_wells_y =  2;    // Number of wells on y-axis

module battery_well () {
  hull () {
    corner_radius = 0.5;
    corners = [
      [corner_radius,         corner_radius,         0],
      [bat_x - corner_radius, corner_radius,         0],
      [corner_radius,         bat_y - corner_radius, 0],
      [bat_x - corner_radius, bat_y - corner_radius, 0],
    ];

  hull ()
    for (i = [0 : len (corners) - 1])
      translate (corners [i])
        cylinder (r = corner_radius, h = hgt);;
  }
}

module battery_wells () {
  for (x = [0 : n_wells_x - 1])
    for (y = [0 : n_wells_y - 1])
      translate ([wall + ((bat_x + wall) * x), wall + ((bat_y + wall) * y), 0])
        battery_well ();
}

module exterior () {
  corners = [
    [wall,                       wall,                       0],
    [(bat_x + wall) * n_wells_x, wall,                       0],
    [wall,                       (bat_y + wall) * n_wells_y, 0],
    [(bat_x + wall) * n_wells_x, (bat_y + wall) * n_wells_y, 0],
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
