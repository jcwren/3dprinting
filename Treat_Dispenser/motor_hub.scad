module motor_hub (hub_dia, hub_hgt, shaft_dia = 5.3, grub_dia = 2.8, sides = 360) {
  difference () {
    cylinder (d = hub_dia, h = hub_hgt, $fn = sides);
    
    difference () {
      translate ([0, 0, -0.01])
      cylinder (d = shaft_dia, h = hub_hgt + 0.02, $fn = sides);
      
      translate ([-shaft_dia / 2, shaft_dia / 2.5, -0.01])
        cube ([shaft_dia, shaft_dia, hub_hgt + 0.02]);
    }
    
    translate ([0, hub_dia, hub_hgt - 4])
      rotate ([90, 0, 0])
        cylinder (d = grub_dia, h = hub_dia, $fn = sides);
  }
}

motor_hub (10, 20);