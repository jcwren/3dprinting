difference () {
  cube ([30, 22, 3]);

  for (y = [0:3]) 
    for (x = [0:4])
      translate ([(x * 6) + 3, (y * 5) + 3, -0.01])
        cylinder (d=2.5 + (y * 0.5) + (x / 10), 4, $fn = 360);
}  