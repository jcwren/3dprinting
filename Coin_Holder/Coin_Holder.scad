$fn        = 180;
d_quarter  = 24.21;
d_dime     = 17.85;
d_nickle   = 21.22;
d_penny    = 19.04;
base_dia   = 63.5;
base_thick =  2.0;
extra      =  1.00;
height     = 63.50;
opening    =  6.00;

difference () {
  cylinder (d = base_dia, h = height);

  translate ([-((base_dia / 2) - ((d_quarter + extra) / 2)), 0, base_thick])
    cylinder (d = d_quarter + extra, h = height);
  translate ([-((base_dia / 2) + 2), -opening, base_thick])
    cube ([7, opening * 2, height]);

  translate ([((base_dia / 2) - ((d_nickle + extra) / 2)), 0, base_thick])
    cylinder (d = d_nickle + extra, h = height);
  translate ([(base_dia / 2) - 5, -opening, base_thick])
    cube ([7, opening * 2, height]);

  translate ([0, -((base_dia / 2) - ((d_penny + extra) / 2)), base_thick])
    cylinder (d = d_penny + extra, h = height);
  translate ([-opening, -((base_dia / 2) + 2), base_thick])
    cube ([opening * 2, 7, height]);

  translate ([0, ((base_dia / 2) - ((d_dime + extra) / 2)), base_thick])
    cylinder (d = d_dime + extra, h = height);
  translate ([-opening, (base_dia / 2) - 5, base_thick])
    cube ([opening * 2, 7, height]);
}
