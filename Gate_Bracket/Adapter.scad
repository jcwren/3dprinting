sides = 360;
adapter_height = 82;  // Total height of holder
adapter_dia = 28.7;   // Diameter of inside of fence pipe
stop_height = 1;      // Height of rim to keep it from falling through the pipe
stop_dia = 31;        // 1mm overhang
batt_dia = 17;        // Diameter of CR123A battery
batt_height = 35;     // Height of CR123A battery
batt_hoffset = -2.15; // Offset from center of adapter to center of battery
batt_voffset = 12;    // Offset up from botton of PCB to bottom of battery
pcb_height = 80;      // Height of PCB
pcb_width = 26;       // Width of PCB
pcb_thickness = 1.80; // Thickness of PCB (0.062" is 1.5748mm, but add a little extra)
extra_width = 23;     // Width used by components
extra_depth = 7;      // Depth used by components (connector, etc)
wire_width = 5;       // Width of cutout to feed switch wires
wire_depth = 4;       // Depth of wire cutout
coax_dia = 3;         // Coax cable diameter

module body () {
  union () {
    translate ([0, 0, 0])
      cylinder (d=adapter_dia, h=adapter_height, $fn=sides);
    translate ([0, 0, adapter_height - stop_height])
      cylinder (d=stop_dia, h=stop_height, $fn=sides);
  }
}

module pcb_cutout () {
  extra_z = (adapter_height - pcb_height) + batt_voffset + batt_height;

  translate ([0, 0, -0.01]) {
    translate ([-(pcb_width / 2), -(pcb_thickness / 2), adapter_height - pcb_height])
      cube ([pcb_width, pcb_thickness, pcb_height + stop_height + 0.02]);
    translate ([-(extra_width / 2), 0, extra_z])
      cube ([extra_width, extra_depth, pcb_height + 0.02]);
    translate ([0, batt_hoffset, 0])
      cylinder (d=batt_dia, h=adapter_height + stop_height + 0.02, $fn=sides);
  }
}

module wire_cutout () {
  translate ([-(wire_width / 2), (adapter_dia / 2) - wire_depth, -0.01])
    cube ([wire_width, wire_depth, adapter_height + stop_height + 0.02]);
  translate ([-(wire_width / 2), 0, adapter_height - wire_depth])
    cube ([wire_width, stop_dia / 2, wire_depth + 0.01]);
}

module coax_cutout () {
  translate ([-((batt_dia + coax_dia) / 2), (pcb_thickness / 2) - 0.01, adapter_height - pcb_height])
    cube ([batt_dia + coax_dia, coax_dia, batt_voffset + batt_height]);
}

difference () {
  body ();
  union () {
    pcb_cutout ();
    wire_cutout ();
    coax_cutout ();
  }
}
