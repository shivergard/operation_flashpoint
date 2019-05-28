/* 
	SKILL STRING
	by kenoxite
	
	Returns the skill of the unit as a string
*/

private ["_unit","_return","_sk"];

_unit = _this select 0;

_return = "";
_sk = skill _unit;

if (_sk < 0.25) then { _return = "Novice" };
if (_sk >= 0.25 and _sk <= 0.45) then { _return = "Rookie" };
if (_sk >= 0.45 and _sk <= 0.65) then { _return = "Recruit" };
if (_sk >= 0.65 and _sk <= 0.85) then { _return = "Veteran" };
if (_sk > 0.85) then { _return = "Expert" };

_return