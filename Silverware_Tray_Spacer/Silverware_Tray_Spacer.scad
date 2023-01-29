thick = 6;

translate ([-(50 + thick), 0, 0])
  cube ([thick, 196, thick]);
translate ([50, 0, 0])
  cube ([thick, 196, thick]);
translate ([-75, 0, 0])
  cube ([150, thick, thick * 2]);
translate ([-75, 196 - thick, 0])
  cube ([150, thick, thick * 2]);
  