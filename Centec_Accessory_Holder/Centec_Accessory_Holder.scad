$fn = 90;

plate_thickness      =  3.50; // Thickness of plate under mounting rings
qc_inner_dia_at_edge = 45.70; // Measured inner diameter of QuickClick connector at edge
qc_inner_dia_at_25mm = 45.30; // Measured inner diameter of QuickClick connector 25mm up from edge
qc_outer_dia         = 51.00; // Measured outer diameter of QuickClick connector
adapter_dia_at_edge  = 38.53; // Measured outer diameter of 1.5" to 2.25" adapter at end + 0.13mm printer correction
adapter_dia_at_25mm  = 39.43; // Measured outer diameter of 1.5" to 2.25" adapter 25mm up from end + 0.13mm printer correction
outlet_dia           = 65.00; // Measured outer diameter of the outlet port on top of the separator
mnt_hgt              = 25.00; // Height of the rings for the QuickClick accessories
overhang             =  3.00; // Extra space on either side of mounting ring so it's not up against outlet port

//
//  Calculate overall mounting plate diameter and where the center of the mounting rings are located
//
plate_dia = outlet_dia + ((overhang + qc_outer_dia + overhang) * 2);
mnt_offset = (plate_dia / 2) - (overhang + (qc_outer_dia / 2));

//
//  0.01 and 0.02 numbers are fudge factors to make the preview render correctly.
//
difference () {
  translate ([0, 0, 0])
    cylinder (d = plate_dia, h = plate_thickness);
  translate ([0, 0, -0.01])
    cylinder (d = outlet_dia, h = plate_thickness + 0.02);
}

for (i = [0 : 360 / 5 : 359])
  translate ([sin (i) * mnt_offset, cos (i) * mnt_offset, plate_thickness - 0.01])
    difference () {
      cylinder (d1 = qc_inner_dia_at_edge, d2 = qc_inner_dia_at_25mm, h = mnt_hgt);
      cylinder (d1 = adapter_dia_at_edge, d2 = adapter_dia_at_25mm, h = mnt_hgt + 0.01);
    }
