inner_w =  30.00;
inner_h =  20.00;
inner_l =  47.00;
usb_h   =   3.20;
usb_w   =   8.50;
usb_z   =  16.00;
pcb_h   =   1.53;
lid_h   =   4.00;
lid_l   =   9.50;
pcb_top =   3.00;
walls   =   2.00;
radius  =   1.00;
$fn     =  90.00;

module box (adj) {
  rm = -(adj / 2);
  rp =  (adj / 2);

  for (z = [rm, inner_h + rp]) {
    translate ([rm, rm, z])
      sphere (d = radius);
    translate ([inner_w + rp, rm, z])
      sphere (d = radius);
    translate ([inner_w + rp, inner_l + rp, z])
      sphere (d = radius);
    translate ([rm, inner_l + rp, z])
      sphere (d = radius);
  }
}

module tabs_pcb () {
  for (i = [1:3]) {
    translate ([0, (inner_l / 4) * i, 0])
      cube ([1, 2, pcb_top - pcb_h]);
    translate ([inner_w - 1, (inner_l / 4) * i, 0])
      cube ([1, 2, pcb_top - pcb_h]);
  }
}

module tabs_lid () {
  difference () {
    union () {
      for (i = [1:3]) {
        translate ([-2, (inner_l / 4) * i, 0])
          cube ([1, 2, 1]);
        translate ([inner_w + 1, (inner_l / 4) * i, 0])
          cube ([1, 2, 1]);
      }
    }
    translate ([-(3 - 0.01), 0, 0])
      rotate ([0, 45, 0])
        cube ([1.41, inner_l, 1.41]);
    translate ([(inner_w + 1) - 0.01, 0, 0])
      rotate ([0, 45, 0])
        cube ([1.41, inner_l, 1.41]);
  }
}

module enclosure () {
  difference () {
    hull ()
      box (radius);

    translate ([-(radius + 0.01), -(radius + 0.01), -(radius + 0.01)])
      cube ([inner_w + (radius * 2) + 0.02, inner_l + (radius * 2) + 0.02, radius + 0.02]);
    translate ([0, 0, -0.01])
      cube ([inner_w, inner_l, inner_h + 0.01]);
    translate ([0, -(radius + 0.01), 0])
      cube ([inner_w, (radius * 2) + 0.02, pcb_top]);
    translate ([(inner_w / 2) - (usb_w / 2), inner_l - 0.01, usb_z])
      cube ([usb_w, radius + 0.02, usb_h]);
  }

  tabs_pcb ();
  tabs_lid ();
}

module lid_box (rm) {
  hull () {
    translate ([-rm, -rm, 0])
      cylinder (d = radius, h = lid_h);
    translate ([inner_w + rm, -rm, 0])
      cylinder (d = radius, h = lid_h);
    translate ([inner_w + rm, inner_l + rm, 0])
      cylinder (d = radius, h = lid_h);
    translate ([-rm, inner_l + rm, 0])
      cylinder (d = radius, h = lid_h);
  }
}

module lid_connector (rm) {
  hull () {
    translate ([-rm, rm, 0])
      cylinder (d = radius, h = lid_h);
    translate ([inner_w + rm, rm, 0])
      cylinder (d = radius, h = lid_h);
    translate ([inner_w + rm, -lid_l - rm, 0])
      cylinder (d = radius, h = lid_h);
    translate ([-rm, -lid_l - rm, 0])
      cylinder (d = radius, h = lid_h);
  }
}

module lid_tab_holes () {
  for (i = [1:3]) {
    translate ([-(2 + 0.01), (inner_l / 4) * i, 0])
      cube ([1.02, 2, 1]);
    translate ([(inner_w + 1) - 0.01, (inner_l / 4) * i, 0])
      cube ([1.02, 2, 1]);
  }
}

module lid (adj = radius) {
  translate ([0, 0, -10]) {
    difference () {
      union () {
        translate ([0, 0, 0]) {
          difference () {
            lid_box (1.5);
            translate ([0, 0, 1])
              lid_box (0.5);
          }
        }
        translate ([0, -2, 0]) {
          difference () {
            lid_connector (0.5);
            translate ([0, 0, 1])
              lid_connector (-0.5);
          }
        }
      }
      translate ([0, -3.01, 1])
        cube ([inner_w, 2.02, lid_h]);
      translate ([0, 0, 1])
        lid_tab_holes ();
    }
  }
}

enclosure ();
lid ();
