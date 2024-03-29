//
//      OD      ID   Wall      Wt  PSI       Size
//
PVC_S40 = [
  [  0.405,  0.249, 0.068,  0.051, 810 ], // 1/8"
  [  0.540,  0.344, 0.088,  0.086, 780 ], // 1/4"
  [  0.675,  0.473, 0.091,  0.115, 620 ], // 3/8"
  [  0.840,  0.602, 0.109,  0.170, 600 ], // 1/2"
  [  1.050,  0.804, 0.113,  0.226, 480 ], // 3/4"
  [  1.315,  1.029, 0.133,  0.333, 450 ], // 1"
  [  1.660,  1.360, 0.140,  0.450, 370 ], // 1-1/4"
  [  1.900,  1.590, 0.145,  0.537, 330 ], // 1-1/2"
  [  2.375,  2.047, 0.154,  0.720, 280 ], // 2"
  [  2.875,  2.445, 0.203,  1.136, 300 ], // 2-1/2"
  [  3.500,  3.042, 0.216,  1.488, 260 ], // 3"
  [  4.000,  3.521, 0.226,  1.789, 240 ], // 3-1/2"
  [  4.500,  3.998, 0.237,  2.188, 220 ], // 4"
  [  5.563,  5.016, 0.258,  2.874, 190 ], // 5"
  [  6.625,  6.031, 0.280,  3.733, 180 ], // 6"
  [  8.625,  7.942, 0.322,  5.619, 160 ], // 8"
  [ 10.750,  9.976, 0.365,  7.966, 140 ], // 10"
  [ 12.750, 11.889, 0.406, 10.534, 130 ], // 12"
  [ 14.000, 13.073, 0.437, 12.462, 130 ], // 14"
  [ 16.000, 14.940, 0.500, 16.286, 130 ], // 16"
  [ 18.000, 16.809, 0.562, 20.587, 130 ], // 18"
  [ 20.000, 18.743, 0.593, 24.183, 120 ], // 20"
  [ 24.000, 22.544, 0.687, 33.652, 120 ], // 24"
];

PVC_S40_MM = [
  for (i = [0 : len (PVC_S40) - 1])
    [PVC_S40 [i][0] * 25.4, PVC_S40 [i][1] * 25.4, PVC_S40 [i][2] * 25.4, PVC_S40 [i][3] * 25.4, PVC_S40 [i][4]]
];

//
//  Indexes for pipe sizes
//
PVC_S40_0_125  =  0;  // 1/8"
PVC_S40_0_250  =  1;  // 1/4"
PVC_S40_0_375  =  2;  // 3/8"
PVC_S40_0_500  =  3;  // 1/2"
PVC_S40_0_750  =  4;  // 3/4"
PVC_S40_1_000  =  5;  // 1"
PVC_S40_1_250  =  6;  // 1-1/4"
PVC_S40_1_500  =  7;  // 1-1/2"
PVC_S40_2_000  =  8;  // 2"
PVC_S40_2_500  =  9;  // 2-1/2"
PVC_S40_3_000  = 10;  // 3"
PVC_S40_3_500  = 11;  // 3-1/2"
PVC_S40_4_000  = 12;  // 4"
PVC_S40_5_000  = 13;  // 5"
PVC_S40_6_000  = 14;  // 6"
PVC_S40_8_000  = 15;  // 8"
PVC_S40_10_000 = 16;  // 10"
PVC_S40_12_000 = 17;  // 12"
PVC_S40_14_000 = 18;  // 14"
PVC_S40_16_000 = 19;  // 16"
PVC_S40_18_000 = 20;  // 18"
PVC_S40_20_000 = 21;  // 20"
PVC_S40_24_000 = 22;  // 24"

//
//  Indexes for columns
//
PVC_S40_OD     = 0;   // Outside diameter
PVC_S40_ID     = 1;   // Average inside diameter
PVC_S40_WALL   = 2;   // Minimum wall thickness
PVC_S40_WEIGHT = 3;   // Weight per foot (in pounds)
PVC_S40_PSI    = 4;   // Maximum W.P. PSI
