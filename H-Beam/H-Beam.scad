length = 25.4 * 4.7;  // 4 inches (kinda)
height = 25.4 * 3;    // 3 inches
thickness = 25.4 / 4; // 0.25 inches

rotate ([0, 0, 45])
  cube ([length, thickness, height], center = true);
rotate ([0, 0, 135])
  cube ([length, thickness, height], center = true);