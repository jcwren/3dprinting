module bar (x, y)
{
  translate ([x, y, 0]) {
    translate ([1, 0, 0])
      cube ([2, 1, 1.3]);
    translate ([1, 1, 0])
      cube ([2, 3, 0.6]);
    translate ([0, 4, 0])
      cube ([4, 60 - (4 * 2), 0.6]);
    translate ([1, 60 - 4, 0])
      cube ([2, 3, 0.6]);
    translate ([1, (60 - 4) + 3, 0])
      cube ([2, 1, 1.3]);
  }
}

bar (0, 0);
bar (110, 0);

translate ([4, 15, 0])
  cube ([110, 4, 0.6]);
translate ([4, 45, 0])
  cube ([110, 4, 0.6]);

