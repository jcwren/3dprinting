total_hgt = 3.00;
bat_width = 5.95;
bat_depth = 2.56;
wall      = 0.0625;
lip       = 0.25;

function in2mm(x) = x * 25.4;

difference () {
  translate ([0, 0, 0])
    cube ([in2mm (bat_width + (wall * 2)), in2mm (bat_depth + (wall * 2)), in2mm (total_hgt)]);
  translate ([in2mm (wall), in2mm (wall), in2mm (total_hgt - lip)])
    cube ([in2mm (bat_width), in2mm (bat_depth), in2mm (lip) + 0.01]);
  translate ([in2mm (wall * 3), in2mm (wall * 3), -0.01])
    cube ([in2mm (bat_width - (wall * 4)), in2mm (bat_depth - (wall * 4)), in2mm (total_hgt)]);
}

translate ([in2mm ((bat_width / 2) - (wall / 2)), in2mm (wall), 0])
  cube ([in2mm (wall), in2mm (bat_depth), in2mm (total_hgt - lip)]);