/* 
	VEHICLES IN SQUAD
	by kenoxite
	
	Returns the amount of vehicles (not men) found in a group
	
	Uses functions from Vektorboson's OFP Script Lib
*/

private ["_grp","_veh","_return","_apcs","_tanks","_cars","_trucks","_planes","_choppers","_boats","_v","_a"];

_grp = _this select 0;
_veh = _grp call f_classifyGroupString;

_return = 0;

_apcs = 0;
_tanks = 0;
_cars = 0;
_trucks = 0;
_planes = 0;
_choppers = 0;
_boats = 0;
_v = "";
_a = 0;
{
_v = _x select 0;
_a = _x select 1;
if (_v == "Tank") then { _tanks = _a };
if (_v == "APC") then { _apcs = _a };
if (_v == "Car") then { _cars = _a };
if (_v == "Truck") then { _trucks = _a };
if (_v == "Plane") then { _planes = _a };
if (_v == "Chopper") then { _choppers = _a };
if (_v == "Boat") then { _boats = _a };
} forEach _veh;

_return = _apcs + _tanks + _cars + _trucks + _planes + _choppers + _boats;

_return