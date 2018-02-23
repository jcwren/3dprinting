This is an adapter for a 4" port on a dust collector to two 2" shop vac hoses.
I have a router table that has an upper and lower dust collector port, and
needed a way to connected them both to the dust collector.

This was printed in ABS and glued with epoxy, and didn't collapse even after
connecting the two 2" ports together.

The 'wall' variable in the OpenSCAD file allows setting the thickness of the
item.The 2.96mm value is recommended by Slic3R PE when setting the perimeters
to 4 and checking the 'Detect thin walls' option.

The 'port\_small' and 'port\_large' array are just for reference. The actual
values are hard-coded within the source. The top and bottom half are connected
with a small cube so that the part is manifold and can be printed in one
session.

Printed on a Prusa i3 MK3. Use rafts, no supports, 0.15mm resolution, 20%
infill.

In Slic3r PE, set Layers and perimeters-\>Vertical shells-\>Perimeters to 4, and
check 'Extra perimeters if needed', 'Ensure vertical shell thickness', 'Detect
thin walls', and 'Detect bridging perimeters' (the last one probably isn't
needed, but it's always checked)
