sides=360;

difference () {
  //
  // Outside shape
  //
  union () {
    translate ([2.5, 2.5, 0]) {
      minkowski () {
        cube ([115, 115, 1.25]);
        cylinder (h=1.25, r=2.5, $fn=sides);
      }
    }
    translate ([60, 60, 0]) {
      cylinder (h=10, d=120, $fn=sides);
    }
    translate ([60, 60, 10]) {
      cylinder (h=20, d1=120, d2=100, $fn=sides);
    }
    translate ([60, 60, 30]) {
      cylinder (h=17, d=100, $fn=sides);
    }
    translate ([60, 60, 47]) {
      cylinder (h=3, d=103, $fn=sides);
    }
    translate ([60, 60, 44]) {
      cylinder (h=3, d1=100, d2=103, $fn=sides);
    }
  }
  
  //
  //  Make interior hollow
  //
  translate ([60, 60, 0]) {
    cylinder (h=10, d=118, $fn=sides);
  }
  translate ([60, 60, 10]) {
    cylinder (h=20, d1=118, d2=98, $fn=sides);
  }
  translate ([60, 60, 30]) {
    cylinder (h=20, d=98, $fn=sides);
  }
  
  //
  //  Screw holes
  //
  translate ([8, 8, 0]) {
    cylinder (h=3, d=5, $fn=sides);
  }
   translate ([8, 120-8, 0]) {
    cylinder (h=3, d=5, $fn=sides);
  }
   translate ([120-8, 8, 0]) {
    cylinder (h=3, d=5, $fn=sides);
  }
   translate ([120-8, 120-8, 0]) {
    cylinder (h=3, d=5, $fn=sides);
  }
}