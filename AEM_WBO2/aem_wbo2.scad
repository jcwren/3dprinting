inner_w =  30.00;
inner_h =  20.00;
inner_l =  47.00;
usb_h   =   3.20;
usb_w   =   8.50;
usb_z   =  15.00;
pcb_h   =   1.53;
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

module wedge (x, y) {
  translate ([x, y, 0])
    cube ([1, 2, pcb_top - pcb_h]);
}

module wedges () {
  for (i = [1:3]) {
    wedge (0, (inner_l / 4) * i);
    wedge (inner_w - 1, (inner_l / 4) * i);
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

  wedges ();
}

module temp (rm) {
  hull () {
    translate ([-rm, -rm, 0])
      cylinder (d = radius, h = 5);
    translate ([inner_w + rm, -rm, 0])
      cylinder (d = radius, h = 5);
    translate ([inner_w + rm, inner_l + rm, 0])
      cylinder (d = radius, h = 5);
    translate ([-rm, inner_l + rm, 0])
      cylinder (d = radius, h = 5);
  }
}

module temp2 (rm) {
  hull () {
    translate ([-rm, rm, 0])
      cylinder (d = radius, h = 5);
    translate ([inner_w + rm, rm, 0])
      cylinder (d = radius, h = 5);
    translate ([inner_w + rm, -10 - rm, 0])
      cylinder (d = radius, h = 5);
    translate ([-rm, -10 - rm, 0])
      cylinder (d = radius, h = 5);
  }
}

module lid (adj = radius) {
  translate ([0, 0, -10]) {
    difference () {
      union () {
        difference () {
          temp (1.5);
          translate ([0, 0, 1])
            temp (0.5);
        }
        translate ([0, -2, 0]) {
          difference () {
            temp2 (0.5);
            translate ([0, 0, 1])
              temp2 (-0.5);
          }
        }
      }
      translate ([0, -3.01, 1])
        cube ([inner_w, 2.02, 5]);
    }
  }
}

//enclosure ();
lid ();
