/* 
	CLASSIFY SQUAD
	by kenoxite
	
	Returns the type of squad based on its composition
	
	Uses functions from Vektorboson's OFP Script Lib
*/

private ["_grp","_types","_veh","_return","_inf","_apcs","_tanks","_cars","_trucks","_planes","_choppers","_boats","_v","_a","_typesE","_mode"];

_grp = _this select 0;
_mode = if (count _this > 1) then { _this select 1 } else { "" };
_types = call loadfile "SQCTL\fu\squadTypes.sqf";
_typesE = call loadfile "SQCTL\fu\squadTypesEnemy.sqf";
_veh = _grp call f_classifyGroupString;

_return = if (_mode == "") then { count _types - 1 } else { count _typesE - 1 };

_inf = 0;
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
if (_v == "Infantry") then { _inf = _a };
if (_v == "Tank") then { _tanks = _a };
if (_v == "APC") then { _apcs = _a };
if (_v == "Car") then { _cars = _a };
if (_v == "Truck") then { _trucks = _a };
if (_v == "Plane") then { _planes = _a };
if (_v == "Chopper") then { _choppers = _a };
if (_v == "Boat") then { _boats = _a };
} forEach _veh;

if (_inf > 0 and _apcs == 0 and _tanks == 0 and _planes == 0 and _choppers == 0 and _boats == 0) then { _return = 0 };
if (_apcs > 0 and _tanks == 0 and _planes == 0 and _choppers == 0 and _boats == 0) then { _return = 1 };
if (_inf == 0 and _apcs == 0 and _tanks > 0 and _planes == 0 and _choppers == 0 and _boats == 0) then { _return = 2 };
if (_inf == 0 and _apcs == 0 and _tanks == 0 and _planes == 0 and _choppers > 0 and _boats == 0) then { _return = 3 };
if (_inf == 0 and _apcs == 0 and _tanks == 0 and _planes > 0 and _choppers == 0 and _boats == 0) then { _return = 4 };
if (_inf == 0 and _apcs == 0 and _tanks == 0 and _planes == 0 and _choppers == 0 and _boats > 0) then { _return = 5 };

_return