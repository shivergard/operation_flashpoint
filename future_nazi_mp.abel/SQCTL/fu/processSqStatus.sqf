/* 
	PROCESS SQUAD STATUS
	by kenoxite
	
	Returns and array containing the indexes to the current behavior,
	combat mode and speed mode of the group
*/

private ["_grp","_return","_behaviors","_combatModes","_speedModes","_formations","_i"];

_grp = _this select 0;

_behaviors = call loadfile "SQCTL\orders\behaviors.sqf";
_combatModes = call loadfile "SQCTL\orders\combatModes.sqf";
_speedModes = call loadfile "SQCTL\orders\speedModes.sqf";
_formations = call loadfile "SQCTL\orders\formations.sqf";

_return = [1,1,1,1];

// RETURN BEHAVIOR INDEX
_i = 0;
{ if ((_x select 0) == behaviour leader _grp) then { _return set [0, _i] }; _i = _i + 1 } forEach _behaviors;

// RETURN COMBAT MODE INDEX
_i = 0;
{ if ((_x select 1) == combatMode _grp) then { _return set [1, _i] }; _i = _i + 1 } forEach _combatModes;

// RETURN SPEED MODE INDEX
_i = 0;
{ if ((_x select 0) == speedMode _grp) then { _return set [2, _i] }; _i = _i + 1 } forEach _speedModes;

// RETURN FORMATION INDEX
_i = 0;
{ if ((_x select 0) == formation _grp) then { _return set [3, _i] }; _i = _i + 1 } forEach _formations;

_return