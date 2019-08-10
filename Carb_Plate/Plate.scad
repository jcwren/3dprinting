function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;
function frac (x, y) = (1 / y) * x;

stud_dia = in2mm (frac (11, 32));
stud_space_x = in2mm (5 + frac (5, 32));
stud_space_y = in2mm (3.50000);

module ear (x, y, angle)
{
  nx = x + (sin (angle) * in2mm (1 + frac (5, 8)));
  ny = y + (cos (angle) * in2mm (1 + frac (5, 8)));
  
  difference ()
  {
    hull () {
      translate ([x, y, 0])
        circle (d = in2mm (frac (3, 4)));
      translate ([nx, ny, 0])
        circle (d = in2mm (1 + frac (2, 16)));
    }
    translate ([x, y, 0])
      circle (d = stud_dia);
  }
}

module ears () {
  adjust = 5;
  
  ear (-(stud_space_x / 2), -(stud_space_y / 2),  45 - adjust);
  ear (-(stud_space_x / 2),  (stud_space_y / 2), 135 + adjust);
  ear ( (stud_space_x / 2),  (stud_space_y / 2), 225 - adjust);
  ear ( (stud_space_x / 2), -(stud_space_y / 2), 315 + adjust);
}

top_offset = in2mm (frac (17, 32)); 
bot_offset = in2mm (frac (5, 16)); 
box_y = stud_space_y - (top_offset + bot_offset);
box_x = stud_space_x + in2mm (frac (1, 16) * 2);

union () {
  ears ();
  translate ([-(box_x / 2), -((stud_space_y / 2) - bot_offset), 0])
    square ([box_x, box_y]);
}
  