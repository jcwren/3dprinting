inner_w =  30.00;
inner_h =  20.00;
inner_l =  47.00;
usb_h   =   3.00;
usb_w   =   8.50;
usb_z   =  15.00;
pcb_h   =   1.53;
pcb_top =   3.00;
walls   =   2.00;
radius  =   1.00;
$fn     =  32.00;

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
  color ("blue") {
    translate ([x, y, pcb_top - pcb_h]) {
      rotate ([0, 0, 0])
        cube ([1, 2, 1]);
    }
  }
}

module wedges () {
  for (i = [1:3]) {
    wedge (0, (inner_l / 4) * i);
    wedge (inner_w - 1, (inner_l / 4) * i);
  }
}

difference () {
  hull ()
    box (radius);
  hull ()
    box (-radius);
  
  translate ([-radius, -radius, -radius])
    cube ([inner_w + (radius * 2), inner_l + (radius * 2), radius + 0.01]);
  translate ([0, -radius, 0])
    cube ([inner_w, (radius * 2) + 0.01, pcb_top]);
  translate ([(inner_w / 2) - (usb_w / 2), inner_l, usb_z])
    cube ([usb_w, radius + 0.01, usb_h]);
}

wedges ();
