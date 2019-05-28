
/*---------------------------------------------------------------
distancePos function -=- by snYpir

Returns the distance between two x,y positions

Called with:

[[<x pos 1>,<y pos 1>],[<x pos 2>,<y pos 2>]] call distancePos
---------------------------------------------------------------*/

// declare private variables
private ["_x1","_y1","_x2","_y2"];

// get positions
_x1 = (_this select 0) select 0;
_y1 = (_this select 0) select 1;
_x2 = (_this select 1) select 0;
_y2 = (_this select 1) select 1;

// return the distance
sqrt( (_x1-_x2)^2 + (_y1-_y2)^2 )