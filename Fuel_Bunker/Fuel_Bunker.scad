fourByFour_wt = i2m (3.5);                     // 4x4" width & thickness
twoByFour_w   = i2m (3.5);                     // 2x4" width
twoByFour_t   = i2m (1.5);                     // 2x4" thickness
twoByTwo_wt   = i2m (1.5);                     // 2x2" width & thickness
inner_x       = i2m (66) + (twoByTwo_wt * 2);  // Desired inner width (including 2x2 braces)
inner_y       = i2m (28) + (twoByTwo_wt * 2);  // Desired inner depth (including 2x2 braces)
inner_z       = i2m (24);                      // Desired inner height
ply_z         = i2m (0.50);                    // Thickness of plywood/OSB for floor, wall, top

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
    xcube ("4x4", [fourByFour_wt, fourByFour_wt, i2m (6)]);
  translate ([fourByFour_wt, 0, -twoByFour_w])
    xcube ("2x4: front LtR", [inner_x - fourByFour_wt + ply_z + twoByFour_w, twoByFour_t, twoByFour_w], c ? c : "LightPink");
  translate ([0, twoByFour_w, -twoByFour_w])
    xcube ("2x4: left FtR", [twoByFour_t, inner_y + ply_z, twoByFour_w]);
  for (y = [16, 32, 48, 64])
    translate ([i2m (y), twoByFour_t, -twoByFour_w])
      xcube ("2x4: 1of4 FtR", [twoByFour_t, -twoByFour_t + inner_y + ply_z + twoByFour_w, twoByFour_w]);
}

module plywood (c) {
  translate ([0, 0, 0])
    xcube ("ply: deck", [inner_x + ply_z, inner_y + ply_z, ply_z], c ? c : "LightBlue");
  translate ([-ply_z, -ply_z, -twoByFour_w])
    xcube ("ply: front", [ply_z + inner_x + ply_z, ply_z, twoByFour_w + ply_z + inner_z], c ? c : "LightSkyBlue");
  translate ([0, inner_y, ply_z])
    xcube ("ply: back", [inner_x, ply_z, inner_z], c ? c : "LightSkyBlue");
  translate ([-ply_z, 0, -twoByFour_w])
    xcube ("ply: left", [ply_z, inner_y + ply_z, twoByFour_w + ply_z + inner_z], c ? c : "DeepSkyBlue");
  translate ([inner_x, 0, ply_z])
    xcube ("ply: right", [ply_z, inner_y + ply_z, inner_z], c ? c : "DeepSkyBlue");
}

module inner_frame (c) {
  for (y = [0, inner_y - twoByTwo_wt])
    translate ([0, y, ply_z])
      xcube ("2x2: bottom front/back", [inner_x, twoByTwo_wt, twoByTwo_wt], c ? c : "Gold");
  translate ([0, inner_y - twoByTwo_wt, ply_z + inner_z - twoByTwo_wt])
    xcube ("2x2: top back", [inner_x, twoByTwo_wt, twoByTwo_wt], c ? c : "Gold");

  for (x = [0, inner_x - twoByTwo_wt])
    translate ([x, twoByTwo_wt, ply_z])
      xcube ("2x2: bottom left/right", [twoByTwo_wt, inner_y - (twoByTwo_wt * 2), twoByTwo_wt], c ? c : "Gold");

  for (x = [0, inner_x - twoByTwo_wt])
    translate ([x, 0, ply_z + twoByTwo_wt])
      xcube ("2x2: front vert", [twoByTwo_wt, twoByTwo_wt, inner_z - twoByTwo_wt], c ? c : "Yellow");

  for (x = [0, inner_x - twoByTwo_wt])
    translate ([x, inner_y - twoByTwo_wt, ply_z + twoByTwo_wt])
      xcube ("2x2: back vert", [twoByTwo_wt, twoByTwo_wt, inner_z - (twoByTwo_wt * 2)], c ? c : "Yellow");
}

lower_frame ("Gold");
inner_frame ();
plywood ("DeepSkyBlue");
