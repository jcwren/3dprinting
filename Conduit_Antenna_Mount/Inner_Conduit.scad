conduit_dia  = 40.64; // Inner diameter of 1.5" conduit
n_conn_dia   = 20.50; // Slightly over diameter of N connector on cable
recess_dia   = 22.25; // Make large enough to clear panel N connector nut
recess_depth =  3.50; // Deep enough to clear height of panel N connector nut
screw_dia    =  4.20; // Screw holes
height       = 65.00; // Total height of adapter (use 6.00 for test print)
fudge        =  1.40; // Correction for drilled holes

// wall_center = (n_conn_dia / 2) + ((conduit_dia - n_conn_dia) / 4) + fudge;
wall_center = (conduit_dia / 2) - 6.25;

difference () {
  //
  //  Body
  //
  cylinder (d = conduit_dia, h = height, $fn = 360);

  //
  //  Hole through center for N-connector and cable
  //
  translate ([0, 0, -0.01])
    cylinder (d = n_conn_dia, h = height + 0.02, $fn = 360);

  //
  // Screw holes
  //
  translate ([0 + wall_center, 0, -0.01])
    cylinder (d = screw_dia, h = height + 0.02, $fn = 360);
  translate ([0 - wall_center, 0, -0.01])
    cylinder (d = screw_dia, h = height + 0.02, $fn = 360);
  translate ([0, 0 + wall_center, -0.01])
    cylinder (d = screw_dia, h = height + 0.02, $fn = 360);
  translate ([0, 0 - wall_center, -0.01])
    cylinder (d = screw_dia, h = height + 0.02, $fn = 360);

  //
  //  Recess for N-connector nut
  //
  translate ([0, 0, height - recess_depth])
    cylinder (d = recess_dia, h = recess_depth + 0.01, $fn = 360);
}
