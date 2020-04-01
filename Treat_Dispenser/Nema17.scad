//Quick design of a NEMA 17 (SM-42BYG011-25) motor

//Change number to adjust result of example code (0->2)
Example_Number = 2;

//Example use of code:
if(Example_Number==0){
    motor_height = 34.0;

    Nema17(motor_height);
}
//OR
else if(Example_Number==1){
    motor0_height = 34.0;
    motor1_height = 53.0;

    Nema17(motor0_height);
    translate([100,0,0])
    Nema17(motor1_height);
}
//And just for fun:
else if(Example_Number==2){
    for(x_trans=[0:100:500],y_trans=[0:100:500]){
        translate([x_trans,y_trans,0])
        Nema17(x_trans/50+y_trans/5+5);
    }
}

//Error handling... Bleh.
else{
    echo("**********");
    echo("ERROR");
    echo("Invalid example number, please select A numbers from 0 to 2");
    echo("**********");
}

/*
Copy & paste the module below into your code
to add the NEMA17 module into your design.
Remember to define the height of your Nema17 motor(s)
and include their heights whenever calling this module
*/
module Nema17(motor_height){
	difference(){
//motor
		union(){
			translate([0,0,motor_height/2]){
				intersection(){
					cube([42.3,42.3,motor_height], center = true);
					rotate([0,0,45]) translate([0,0,-1]) cube([74.3*sin(45), 73.3*sin(45) ,motor_height+2], center = true);
				}
			}
			translate([0, 0, motor_height]) cylinder(h=2, r=11, $fn=24);
			translate([0, 0, motor_height+2]) cylinder(h=20, r=2.5, $fn=24);
		}
//screw holes
		for(i=[0:3]){
				rotate([0, 0, 90*i])translate([15.5, 15.5, motor_height-4.5]) cylinder(h=5, r=1.5, $fn=24);
			}
	}
}


