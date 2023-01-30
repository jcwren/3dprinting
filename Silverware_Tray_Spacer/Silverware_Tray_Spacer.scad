thick = 6;
length = 201;
width = 150;
bar_spacing = 103;

translate ([-((bar_spacing / 2) + thick), 0, 0])
  cube ([thick, length, thick]);
translate ([bar_spacing / 2, 0, 0])
  cube ([thick, length, thick]);
translate ([-(width / 2), 0, 0])
  cube ([width, thick, thick]);
translate ([-(width / 2), length - thick, 0])
  cube ([width, thick, thick * 2]);
  