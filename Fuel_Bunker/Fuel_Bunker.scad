inner_x = i2m (66) + (i2m (1.5) * 2);
inner_y = i2m (28) + (i2m (1.5) * 2);
inner_z = i2m (24);

function i2m (i) = i * 2.54;
function m2i (m) = m / 2.54;

module xcube (d, xyz, c = "Gold")
{
  echo (d, " -- x=", m2i (xyz [0]), ", y=", m2i (xyz [1]), ", z=", m2i (xyz [2]));
  color (c)
    cube (xyz);
}

module lower_frame (c) {
  translate ([0, 0, -i2m (6)])
    xcube ("4x4", [i2m (3.5), i2m (3.5), i2m (6)]);
  translate ([i2m (3.5), 0, -i2m (3.5)])
    xcube ("2x4: front LtR", [inner_x - i2m (3.5) + i2m (0.75) + i2m (3.5), i2m (1.5), i2m (3.5)], c ? c : "LightPink");
  translate ([0, i2m (3.5), -i2m (3.5)])
    xcube ("2x4: left FtR", [i2m (1.5), inner_y + i2m (0.75), i2m (3.5)]);
  for (y = [16, 32, 48, 64])
    translate ([i2m (y), i2m (1.5), -i2m (3.5)])
      xcube ("2x4: 1of4 FtR", [i2m (1.5), -i2m (1.5) + inner_y + i2m (0.75) + i2m (3.5), i2m (3.5)]);
}

module plywood (c) {
  translate ([0, 0, 0])
    xcube ("ply: deck", [inner_x + i2m (0.75), inner_y + i2m (0.75), i2m (0.75)], c ? c : "LightBlue");
  translate ([-i2m (0.75), -i2m (0.75), i2m (-3.5)])
    xcube ("ply: front", [i2m (0.75) + inner_x + i2m (0.75), i2m (0.75), i2m (3.5) + i2m (0.75) + inner_z], c ? c : "LightSkyBlue");
  translate ([0, inner_y, i2m (0.75)])
    xcube ("ply: back", [inner_x, i2m (0.75), inner_z], c ? c : "LightSkyBlue");
  translate ([-i2m (0.75), 0, -i2m (3.5)])
    xcube ("ply: left", [i2m (0.75), inner_y + i2m (0.75), i2m (3.5) + i2m (0.75) + inner_z], c ? c : "DeepSkyBlue");
  translate ([inner_x, 0, i2m (0.75)])
    xcube ("ply: right", [i2m (0.75), inner_y + i2m (0.75), inner_z], c ? c : "DeepSkyBlue");
}

module inner_frame (c) {
  for (y = [0, inner_y - i2m (1.5)])
    translate ([0, y, i2m (0.75)])
      xcube ("2x2: bottom front/back", [inner_x, i2m (1.5), i2m (1.5)], c ? c : "Gold");
  translate ([0, inner_y - i2m (1.5), inner_z - i2m (0.75)])
    xcube ("2x2: top back", [inner_x, i2m (1.5), i2m (1.5)], c ? c : "Gold");

  for (x = [0, inner_x - i2m (1.5)])
    translate ([x, i2m (1.5), i2m (0.75)])
      xcube ("2x2: bottom left/right", [i2m (1.5), inner_y - (i2m (1.5) * 2), i2m (1.5)], c ? c : "Gold");

  for (x = [0, inner_x - i2m (1.5)])
    translate ([x, 0, i2m (0.75) + i2m (1.5)])
      xcube ("2x2: front vert", [i2m (1.5), i2m (1.5), inner_z - i2m (1.5)], c ? c : "Yellow");

  for (x = [0, inner_x - i2m (1.5)])
    translate ([x, inner_y - i2m (1.5), i2m (0.75) + i2m (1.5)])
      xcube ("2x2: back vert", [i2m (1.5), i2m (1.5), inner_z - (i2m (1.5) * 2)], c ? c : "Yellow");
}

lower_frame ("Gold");
inner_frame ();
plywood ("DeepSkyBlue");
