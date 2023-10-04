$fn = 90;

x_size           =  64;   // Outside to outside X axis dimension
y_size           =  64;   // Outside to outside Y axis dimension
wall             =   2;   // Thickness of cup walls
corner_radius    =  10;   // Radius for corners
cup_height       = 100;   // Total height
bottom_thickness =   0.6; // Thickness of bottom of cup

module outside (cup_height, x_size, y_size, corner_radius) {
  linear_extrude (height = cup_height)
    hull ()
      for (x = [-1, 1])
        for (y = [-1, 1])
          translate ([x * ((x_size / 2) - corner_radius), y * ((y_size / 2) - corner_radius), 0])
            circle (r = corner_radius);
}

difference () {
  translate ([0, 0, 0])
    outside (cup_height, x_size, y_size, corner_radius);
  translate ([0, 0, bottom_thickness])
    outside ((cup_height - bottom_thickness) + 0.01, x_size - (wall * 2), y_size - (wall * 2), corner_radius - wall);
}
