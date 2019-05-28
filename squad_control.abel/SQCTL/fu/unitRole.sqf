/* 
	UNIT ROLE
	by kenoxite
	
	Returns the skill of the unit as a string
*/

private ["_unit","_return","_role","_roles","_priWpn","_secWpn","_w","_r"];

_unit = _this select 0;

_roles = call loadfile "SQCTL\fu\roles.sqf";

_role = _roles select 0;
_return = (_roles select 0) select 0;

_priWpn = primaryWeapon _unit;
_secWpn = secondaryWeapon _unit;

{
_r = _x select 0;
_w = _x select 1;
if ((_priWpn in _w or _secWpn in _w) and (_w select 0) != "") then { _return = _r };
} forEach _roles;

_return