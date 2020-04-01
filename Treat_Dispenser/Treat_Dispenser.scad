//
//  Requires https://github.com/revarbat/BOSL be cloned into ~/Documents/OpenSCAD/Libraries
//
include <BOSL/constants.scad>
use <BOSL/beziers.scad>
use <BOSL/paths.scad>
include <arc.scad>
include <Configuration.scad>;
include <Wheel.scad>;
include <Cup.scad>;
include <Scraper.scad>;

translate ([0, 0, wheel_z_bot])
  wheel ();

scraper ();
cup ();
