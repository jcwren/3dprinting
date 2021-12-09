//
//  true  -- Add knurling to outside walls of coupler
//  false -- Use smooth wall for exterior of coupler
//
add_knurls = false;

//
//  Comment out for development, use 180 for final render
//
//$fn = 180;

//
//
//
use <threads.scad>
use <knurledFinishLib_v2.scad>

//
//
//
difference () {
  dia_inches = 1.35;
  height_inches = .4;
  spacer_mm = 7;

  dia_mm = dia_inches * 25.4;
  height_mm = height_inches * 25.4;
  hole_mm = 26.5;

  translate ([0, 0, 0.01]) {
    if (add_knurls)
      knurled_cyl (((height_mm * 2) + spacer_mm) - 0.02, dia_mm + 2, 4, 5, 1, 2, 75);
    else
      cylinder (d = dia_mm + 2, h = ((height_mm * 2) + spacer_mm) - 0.02);
  }

  //
  //  Why did I leave this here?
  //
  *translate ([0, 0, 0])
    cylinder (d = 32, h = height_mm);
  *translate ([0, 0, height_mm + spacer_mm])
    cylinder (d = 32, h = height_mm);

  translate ([0, 0, height_mm - 0.01]) {
    cylinder (h = spacer_mm + 0.02, d = hole_mm);
    cylinder (h = 2, d1 = dia_mm, d2 = hole_mm);
    translate ([0, 0, spacer_mm + 0.02])
      rotate ([0, 180, 0])
        cylinder (h = 2.02, d1 = dia_mm, d2 = hole_mm);
  }

  translate ([0, 0, 0])
    english_thread (diameter = dia_inches + 0.01, threads_per_inch = 6.66, length = height_inches , internal = true, square = true, thread_size = 4.2);
  translate ([0, 0, (height_inches * 25.4) + spacer_mm])
    english_thread (diameter = dia_inches + 0.01, threads_per_inch = 6.66, length = height_inches , internal = true, square = true, thread_size = 4.2);
}
