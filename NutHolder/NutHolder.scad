function in2mm (v) = v * 25.4;
function mm2in (v) = v / 25.4;

function hexagonShortToLong (c) = 
  c*sin(90)/sin(60);

socketHeight = in2mm (0.450);
socketSize = in2mm (0.375);
socketSides = 4;
nutHeight = in2mm (0.270);
nutDia = in2mm (0.500);
nutSides = 6;
lockHeight = in2mm (0.160);
lockDia = in2mm (0.600);
lockSides = 360;
washerHeight = in2mm (0.070);
washerDia = in2mm (0.710);
washerSides = 360;
wallThickness = in2mm (0.02);

gcodeFudge = in2mm (0.02);
socketSize2 = (socketSize + gcodeFudge) * sqrt (2);
nutDia2 = hexagonShortToLong (nutDia + gcodeFudge);

adapterHeight = socketHeight + nutHeight + lockHeight + washerHeight;
adapterDia = max (socketSize2, nutDia2, lockDia, washerDia) + wallThickness;
adapterSides = 360;

difference () {
    translate ([0, 0, 0])
        cylinder (d=adapterDia, h=adapterHeight, $fn=adapterSides);
    translate ([0, 0, -0.01])
        cylinder (d=socketSize2, h=socketHeight + 0.02, $fn=socketSides);
    translate ([0, 0, socketHeight])
        cylinder (d=nutDia2, h=nutHeight + 0.01, $fn=nutSides);
    translate ([0, 0, socketHeight + nutHeight])
        cylinder (d=lockDia, h=lockHeight + 0.01, $fn=lockSides);
    translate ([0, 0, socketHeight + nutHeight + lockHeight])
        cylinder (d=washerDia, h=washerHeight + 0.01, $fn=washerSides);
}

echo ("socketSize2 = ", mm2in (socketSize2));
echo ("nutDia = ", mm2in (nutDia2));
echo ("sockSize2(mm) = ", socketSize2);