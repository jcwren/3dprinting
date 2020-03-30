//
//  From https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
//

module sector (radius, angles, fn = 24) {
  r = radius / cos (180 / fn);
  step = -360 / fn;

  points = concat ([[0, 0]],
    [for (a = [angles [0] : step : angles [1] - 360])
        [r * cos (a), r * sin (a)]
    ],
    [[r * cos (angles [1]), r * sin (angles [1])]]
  );

  difference () {
    circle (radius, $fn = fn);
    polygon (points);
  }
}

module arc (radius, angles, width = 1, fn = 24) {
  difference () {
    sector (radius + width, angles, fn);
    sector (radius, angles, fn);
  }
}

module line (point1, point2, width = 1, cap_round = true, fn = 24) {
  angle = 90 - atan ((point2 [1] - point1 [1]) / (point2 [0] - point1 [0]));
  offset_x = 0.5 * width * cos (angle);
  offset_y = 0.5 * width * sin (angle);

  offset1 = [-offset_x, offset_y];
  offset2 = [offset_x, -offset_y];

  if (cap_round) {
    translate (point1)
      circle(d = width, $fn = fn);
    translate (point2)
      circle(d = width, $fn = fn);
  }

  polygon (points = [
    point1 + offset1, point2 + offset1,
    point2 + offset2, point1 + offset2
  ]);
}

module polyline (points, width = 1, fn = 24) {
  module polyline_inner (points, index) {
    if (index < len (points)) {
      line (points [index - 1], points [index], width, fn);
      polyline_inner (points, index + 1);
    }
  }

  polyline_inner (points, 1, fn);
}

if (0) {
  radius = 20;
  angles = [45, 290];
  width = 2;
  fn = 360;

  linear_extrude (1)
    arc (radius, angles, width, fn);
}
