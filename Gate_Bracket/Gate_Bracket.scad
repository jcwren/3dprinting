sides=360;

module gate (x=0, y=0) {
  translate ([x, y, 0]) {
    //translate ([-1, (33.75 / 2) + 5, 21])
    //  rotate ([0, 0, 0])
    //    cube ([42, 1, 1]);
    //translate ([20, (33.75 / 2) + 6, 21]) 
    //  cube ([1, 22, 1]);
    difference () {
      cube ([40, 62.875, 20]);

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

union () {
  //
  //  Piece with reed switch
  //
  difference () {
    gate ();
    translate ([20, 20, 9.5 / 2]) {
      rotate ([270, 0, 0]) {
        cylinder (d=5, h=41, $fn=sides);
      }
    }
  }

  //
  //  Piece with magnet
  //
  translate ([60, 0, 0]) {
    difference () {
      gate ();
      translate ([20, 55, (9.5 - 3) / 2]) {
        cylinder (d=10, h=3, $fn=sides);
      }
      translate ([15, 20, ((9.5 - 3) / 2)]) {
        cube ([10, 35, 3]);
      }
    }
  }
  
  translate ([39, 0, 0]) {
    cube ([21, 0.01, 0.01]);
  }
}