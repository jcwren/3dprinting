# PIDP8I standoffs and LED masking bars

The standoffs are for mounting the PIDP8I front panel to the case.

They're designed to accommodate a Pi 3 Model B+, but should work fine with any
other RPi variant.

It's overkill, for sure.  You can use the wood blocks that came with the kit,
assuming they're the right dimensions (mine weren't, and I sold my table saw a
while back. Plus, 3D printer :) ). I wanted it to be rigidly mounted. Screw the
PCB to the mounts, then figure out where the holes should be on the back of
case, them drill them slightly oversize. Put a washer under the screw, and now
you've got a little room to shift the PCB around to line up correctly in the
acrylic.

Per the instructions, you're supposed to mount the PCB to the far right in the
box, and the bottoms of the switch tabs should be up on the edge where the
plexiglass sits. That made the plexi a little uneven in the box, and for my
build, the switches weren't in the right position. I used a Dremel tool and cut
the tabs off behind the hole in the tab. Before I did, I marked the back of the
case where the screw holes should roughly be.

The LED masking bars prevent LED bleed-over from adjacent LEDs and really
cleans up the look of the front panel (IMESHO). They're wide and long enough so
the PCB is not longer visible through the clear parts of the plexiglass.
Although I used black PETG, my perception is the LEDs are slightly brighter as
they're is less wasted light. White PETG might make them brighter, but I didn't
like the look of it behind the plexi.

I will say it takes a long time to print the LED bars. I use a Prusa MK3 with
Chris Warkocki's Pretty PETG profile which has a 0.2mm layer height. I don't
know what the total print time is as I went through several iterations of
tweaking to get things right, but the 18 hole LED bar takes on the order of 2
hours.

The OpenSCAD code could be modified to render all the LED bars at one time, but
with the number of holes in each bar, the rendering time was around 10 minutes
on my 2019 top of the line MacBook Pro. Doing all of them at once was just too
long too wait. You can, of course, render and export each one, pull them all
into the slicer and print them at one time. Just make sure you have enough
filament and no plans for a power outage.

To hide the shiny switch tabs, it's suggested that black electrical tape be put
over the switches. This works, but leaves a gap on the left and right sides of
the switches. Using heavy black construction paper, cut out a 11" x 1.5"
rectangle, then use an Xacto knife to remove a 10.125" x 0.50" section in the
center. On left of right side, cut a horizontal slit so the paper can be slid
under the switches. Use a piece of tape from underneath to rejoin the slit.

Printed with 10% gyroid infill in PETG. Screw holes are sized for M3 sheet
metal or machine screws. I used black PETG, which is less visible. A dark
gray may be more period correct.

URL to the build instructions for the version I have: https://obsolescence.wixsite.com/obsolescence/copy-of-2016-pidp-8-building-instru
