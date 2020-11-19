sides = 360;

hole_fudge = 0.45;

interior_width = 33;
interior_length = 92.5;
interior_height = 17;

shell_side_thickness = 1.2;
shell_top_thickness = 1.2;
shell_bottom_thickness = 2;

exterior_width = interior_width + (shell_side_thickness * 2);
exterior_length = interior_length + (shell_side_thickness * 2);
exterior_height = interior_height + shell_top_thickness;

oled_width = 23;
oled_length = 12;
oled_x_offset = 6;
oled_y_offset = 19;

antenna_x_offset = (exterior_width / 2) + 10.16;
antenna_y_offset = 0;
antenna_z_offset = interior_height - 11;
antenna_diameter = 6 + hole_fudge;

switch_x_offset = exterior_width / 2;
switch_y_offset = 0;
switch_z_offset = interior_height - 11;
switch_diameter = 4.5 + hole_fudge;

pb_x_offset = (exterior_width / 2) - 10.16;
pb_y_offset = 0;
pb_z_offset = interior_height - 11;
pb_diameter = 4.5 + hole_fudge;

usb_width = 8.5;
usb_height = 3.5;
usb_x_offset = 10.5;
usb_y_offset = exterior_length;
usb_z_offset = (interior_height - usb_height) - 1;

module shell () {
  difference () {
    cube ([exterior_width,
           exterior_length,
           exterior_height]);
    translate ([shell_side_thickness, shell_side_thickness, -0.1])
      cube ([interior_width,
             interior_length,
             interior_height + 0.1]);
  }
}

module oled_window ()
{
  translate ([(exterior_width - oled_width) / 2,
               oled_y_offset + shell_side_thickness,
               interior_height - 0.1])
  cube ([oled_width, oled_length, shell_top_thickness + 0.2]);
}

module round_hole (x, y, z, d)
{
  translate ([x + shell_side_thickness,
              y + shell_side_thickness + 0.1,
              z])
    rotate ([90, 0, 0])
      cylinder (d = d,
                h = shell_side_thickness + 0.2,
                $fn = sides);
}

module square_hole (x, y, z, w, h)
{
  translate ([x + shell_side_thickness,
              y - (shell_side_thickness + 0.1),
              z])
    cube ([w, shell_side_thickness + 0.2, h]);
}

module box ()
{
  difference () {
    shell ();
    oled_window ();
    round_hole (antenna_x_offset, antenna_y_offset, antenna_z_offset, antenna_diameter);
    round_hole (switch_x_offset, switch_y_offset, switch_z_offset, switch_diameter);
    round_hole (pb_x_offset, pb_y_offset, pb_z_offset, pb_diameter);
    square_hole (usb_x_offset, usb_y_offset, usb_z_offset, usb_width, usb_height);
  }

  translate ([usb_x_offset + shell_side_thickness,
              (usb_y_offset - 5) - shell_side_thickness,
              interior_height - 0.3])
    cube ([usb_width, 4, 0.3]);
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
                shell_side_thickness * 2,
                shell_bottom_thickness])
      cube ([interior_width - (shell_side_thickness * 2),
             interior_length - (shell_side_thickness * 2),
             4.1]);
    translate ([shell_side_thickness * 2,
                shell_side_thickness - 0.1,
                shell_bottom_thickness + 2])
      cube ([interior_width - (shell_side_thickness * 2),
             shell_side_thickness + 0.2,
             4.1]);
  }
}

translate ([0, exterior_length, exterior_height])
  rotate ([180, 0, 0])
    box ();
translate ([50, 0, ])
  cover ();
translate ([exterior_width - 0.1, 0, 0])
  cube ([(50 - exterior_width) + 0.2, 0.01, 0.01]);

