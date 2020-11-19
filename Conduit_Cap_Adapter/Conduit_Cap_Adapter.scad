//
//  Adapter for 2" PVC cap to 2" EMT conduit
//

sides = 360;
id = 52.07;
od = 60.452;

cylinder (d = id, h = 45, $fn = sides);
cylinder (d = od, h = 19, $fn = sides);
