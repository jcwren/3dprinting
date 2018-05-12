sides = 360;

hole_fudge = 0.4;

interior_width = 61.5;
interior_length = 104.5;
interior_height = 24;

shell_end_top_thickness = 1.5;
shell_end_bottom_thickness = 1.2;
shell_side_thickness = 1.2;
shell_top_thickness = 1.2;
shell_bottom_thickness = 2;

exterior_width = interior_width + (shell_side_thickness * 2);
exterior_length = interior_length + shell_end_top_thickness + shell_end_bottom_thickness;
exterior_height = interior_height + shell_top_thickness;

oled_width = 23;
oled_length = 12;
oled_x_offset = 8;
oled_y_offset = 17;

dh11_width = 16;
dh11_length = 12.5;
dh11_x_offset = 44;
dh11_y_offset = 65.5;
dh11_shield_height = 11;

antenna_x_offset = 10;
antenna_y_offset = 0;
antenna_z_offset = interior_height / 2;
antenna_diameter = 6.2 + hole_fudge;

pb_x_offset = 35.5;
pb_y_offset = interior_length + shell_side_thickness;
pb_z_offset = interior_height - 16;
pb_diameter = 3 + hole_fudge;

pillar_diameter = 3;

module shell () {
  difference () {
    cube ([exterior_width, 
           exterior_length,
           exterior_height]);
    translate ([shell_side_thickness, shell_end_top_thickness, -0.1])
      cube ([interior_width,
             interior_length,
             interior_height + 0.1]);
  }
}

module oled_window ()
{
  translate ([oled_x_offset + shell_side_thickness,
              oled_y_offset + shell_end_top_thickness,
              interior_height - 0.1])
  cube ([oled_width, oled_length, shell_top_thickness + 0.2]);
}

module dh11_window ()
{
  translate ([dh11_x_offset + shell_side_thickness,
              dh11_y_offset + shell_end_top_thickness,
              interior_height - 0.1])
  cube ([dh11_width, dh11_length, shell_top_thickness + 0.2]);
}

module dh11_shield ()
{
  difference () {
    translate ([(dh11_x_offset + shell_side_thickness) - 1,
                (dh11_y_offset + shell_end_top_thickness) - 1,
                interior_height - dh11_shield_height])
      cube ([dh11_width + 2,
             dh11_length + 2,
             dh11_shield_height]);
    
    translate ([dh11_x_offset + shell_side_thickness,
                dh11_y_offset + shell_end_top_thickness,
                interior_height - (dh11_shield_height + 0.1)])
      cube ([dh11_width,
             dh11_length,
             dh11_shield_height + 0.2]); 
  }
}

module round_hole (x, y, z, d)
{
  translate ([x + shell_side_thickness,
              y + shell_end_top_thickness + 0.1,
              z])
    rotate ([90, 0, 0])
      cylinder (d = d, 
                h = shell_end_top_thickness + 0.2,
                $fn = sides);
}

module square_hole (x, y, z, w, h)
{
  translate ([x + shell_side_thickness,
              y - (shell_end_top_thickness + 0.1),
              z])
    cube ([w, shell_side_thickness + 0.2, h]);
}

module pillar (x, y)
{
  translate ([x - (pillar_diameter / 2), 
              y - (pillar_diameter / 2), 
              shell_top_thickness + (interior_height - 19)])
    cube ([pillar_diameter, pillar_diameter, 19]);
}

module box () 
{
  difference () {
    shell ();
    oled_window ();
    dh11_window ();
    round_hole (antenna_x_offset, antenna_y_offset, antenna_z_offset, antenna_diameter);
    round_hole (pb_x_offset, pb_y_offset, pb_z_offset, pb_diameter);
  }
  
  dh11_shield ();
  pillar (3 + shell_side_thickness, 3 + shell_end_top_thickness);
  pillar ((interior_width - 3) + shell_side_thickness, 3 + shell_end_top_thickness);
  pillar (3 + shell_side_thickness, (interior_length - 3) + shell_end_top_thickness);
  pillar ((interior_width - 3) + shell_side_thickness, (interior_length - 3) + shell_end_top_thickness);
}

module cover ()
{
  cube ([exterior_width, exterior_length, shell_bottom_thickness]);
  
  difference () {
    translate ([shell_side_thickness, 
                shell_side_thickness, 
                shell_bottom_thickness])
      cube ([interior_width, 
             interior_length, 
             4]);
    translate ([shell_side_thickness * 2, 
                shell_side_thickness + shell_end_top_thickness, 
                shell_bottom_thickness])
      cube ([interior_width - (shell_side_thickness * 2), 
             interior_length - (shell_side_thickness + shell_end_top_thickness), 
             4.1]);
  }
}

translate ([0, exterior_length, exterior_height])
  rotate ([180, 0, 0])
    box ();

translate ([80, 0, ])
  cover ();
translate ([exterior_width - 0.1, 0, 0])
  cube ([(80 - exterior_width) + 0.2, 0.01, 0.01]);

  