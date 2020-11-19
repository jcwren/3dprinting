sides=360;

module tiewrap (y=6, h=10, w=40) {
  tw_width=5.3;
  tw_thickness=1.6;
  
  translate ([w / 2, y, h - 2]) {
    difference () {
      cylinder (r=((w + 2) / 2) + tw_thickness, h=tw_width, $fn=sides);
      cylinder (r=((w + 2) / 2), h=tw_width, $fn=sides);
    }  
  }
}

module index_pin () {
  translate ([20, (33.75 / 2) + 5, 16]) {
    rotate ([270, 0, 0]) {
      cylinder (d=3, h=9, $fn=sides);
    }
  }
}

module bracket (x=0, y=0) {
  translate ([x, y, 0]) {
    difference () {
      cube ([40, 62.875, 20]);

      tiewrap ();
      index_pin ();
      
      translate ([20, 6, -1]) {
        cylinder (d=33.75, h=22, $fn=sides);
      }
      
      //
      //  Bottom-side cutout
      //
      translate ([-1, 45, 9.5]) {
        cube ([42, 45, 15]);
      }
      
      //
      //  Left-side angled cutout
      //
      translate ([0, 35, -1]) {
        rotate ([0, 0, 60]) {
          cube ([40, 20, 22]);
        }
      }
      
      //
      //  Right-side angled cutout
      //
      translate ([57.35, 45, -1]) {
        rotate ([0, 00, 120]) {
          cube ([40, 20, 22]);
        }
      }
    }
  }
}

module reed_switch () { 
  rs_dia=5;
  
  translate ([20, 20, 9.5 / 2]) {
    rotate ([270, 0, 0]) {
      cylinder (d=rs_dia, h=41, $fn=sides);
    }
  }
}

module magnet_slot () {
  slot_height=2;
  
  translate ([20, 55, (9.5 - slot_height) / 2]) {
    cylinder (d=10, h=slot_height, $fn=sides);
  }
  translate ([15, 20, ((9.5 - slot_height) / 2)]) {
    cube ([10, 35, slot_height]);
  }
}

union () {
  //
  //  Bracket with reed switch
  //
  difference () {
    bracket ();
    reed_switch ();
  }

  //
  //  Bracket with magnet
  //
  translate ([60, 0, 0]) {
    difference () {
      bracket ();
      magnet_slot ();
    }
  }
  
  //
  //  Join two pieces together to make manifold
  //
  translate ([39, 0, 0]) {
    cube ([21, 0.01, 0.01]);
  }
}