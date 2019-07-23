function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;

function hexagonShortToLong (c) =
  c*sin(90)/sin(60);

//
//  SAE 3/8" nut, lock washer, flat washer
//
socketHeight = in2mm (0.450);
socketSize = in2mm (0.375);
socketSides = 4;
socketDimples = 1;
nutHeight = in2mm (0.335);      // SAE 0.328125 (21/64")
nutDia = in2mm (0.564);         // SAE 0.564500 (9/16")
nutSides = 6;
lockHeight = in2mm (0.212);     // SAE 0.109000 (x2)
lockDia = in2mm (0.680);        // SAE 0.675000 (11/16", regular)
lockSides = 360;
washerHeight = in2mm (0.070);   // SAE 0.065000
washerDia = in2mm (0.815);      // SAE 0.812500 (13/16")
washerSides = 360;
nibHeight = in2mm (.01);
nibLength = in2mm (0.05);
slitWidth = in2mm (0.025);
wallThickness = in2mm (0.04);
dowelHole = in2mm (0.250);

gcodeFudge = in2mm (0.02);
socketSize2 = (socketSize + gcodeFudge) * sqrt (2);
nutDia2 = hexagonShortToLong (nutDia + gcodeFudge);
lockDia2 = max (lockDia, nutDia2);

adapterHeight = socketHeight + nutHeight + lockHeight + washerHeight + nibHeight;
adapterDia = max (socketSize2, nutDia2, lockDia, washerDia) + wallThickness;
adapterSides = 360;

module nib (a, r, z) {
  angle = 360 * (nibLength / (2 * PI * r));

  rotate ([0, 0, a - (angle / 2)])
    intersection () {
      translate ([0, 0, z])
        rotate_extrude (angle=angle, convexity=10, $fn=360)
          translate ([r - wallThickness / 2, 0, 0])
            circle (r=nibHeight, $fn=360);
      translate ([0, 0, z - nibHeight])
        cylinder (r = r - (wallThickness / 2), h = nibHeight * 2, $fn=360);
    }
}

module adapter () {
  difference () {
    translate ([0, 0, 0])
      cylinder (d=adapterDia, h=adapterHeight, $fn=adapterSides);

    translate ([0, 0, -0.01])
      cylinder (d=socketSize2, h=socketHeight + 0.02, $fn=socketSides);

    if (socketDimples) {
      dimpleZ = socketHeight / 2;
      dimpleDepth = in2mm (0.05);
      dimpleStart = in2mm (0.2);
      dimpleEnd = in2mm (0.1);
      dimplePos = (socketSize / 2) - dimpleDepth;

      translate ([dimplePos, dimplePos, dimpleZ])
        rotate ([0, 90, 45])
          cylinder (h=dimpleDepth, d1=dimpleStart, d2=dimpleEnd, center=true, $fn=360);
      translate ([-dimplePos, dimplePos, dimpleZ])
        rotate ([270, 0, 45])
          cylinder (h=dimpleDepth, d1=dimpleStart, d2=dimpleEnd, center=true, $fn=360);
      translate ([dimplePos, -dimplePos, dimpleZ])
        rotate ([90, 90, 45])
          cylinder (h=dimpleDepth, d1=dimpleStart, d2=dimpleEnd, center=true, $fn=360);
      translate ([-dimplePos, -dimplePos, dimpleZ])
        rotate ([180, 90, 45])
          cylinder (h=dimpleDepth, d1=dimpleStart, d2=dimpleEnd, center=true, $fn=360);
    }

    translate ([0, 0, socketHeight])
      cylinder (d=nutDia2, h=nutHeight + 0.01, $fn=nutSides);

    translate ([0, 0, socketHeight + nutHeight])
      cylinder (d=lockDia2, h=lockHeight + 0.01, $fn=lockSides);

    translate ([0, 0, socketHeight + nutHeight + lockHeight])
      cylinder (d=washerDia, h=washerHeight + 0.01, $fn=washerSides);

    //
    //  Additional cylinder above washer to difference out, then remove the slits
    //
    translate ([0, 0, socketHeight + nutHeight + lockHeight + washerHeight])
      cylinder (d=washerDia, h=nibHeight + 0.01, $fn=360);
    translate ([-(slitWidth / 2), -((adapterDia / 2) + 0.01), socketHeight + nutHeight + lockHeight])
      cube ([slitWidth, adapterDia + 0.02, washerHeight + nibHeight + 0.01]);
    translate ([-((adapterDia / 2) + 0.01), -(slitWidth / 2), socketHeight + nutHeight + lockHeight])
      cube ([adapterDia + 0.02, slitWidth, washerHeight + nibHeight + 0.01]);
  }

  for (a = [22.5 : 45 : 360])
    nib (a, adapterDia / 2, socketHeight + nutHeight + lockHeight + washerHeight);
}

module block () {
  difference () {
    translate ([-(adapterDia / 2), 0, 0])
      cube ([adapterDia, (adapterDia / 2) + (2 * dowelHole), dowelHole * 2]);
    translate ([-((adapterDia / 2) + 0.01), 17.5, dowelHole])
      cube ([(adapterDia * 2) + 0.02, dowelHole, dowelHole], center = true);
    translate ([0, 0, -0.01])
      cylinder (d=adapterDia, h=adapterHeight + 0.02, $fn=adapterSides);
  }
}

union () {
  adapter ();
  block ();
}