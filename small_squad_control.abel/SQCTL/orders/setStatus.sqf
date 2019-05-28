if (_formation > 0) then { 
	_form = (_formations select _formation) select 0;
	_sqd setFormation _form;
	(_sqArr select 4) set [3,_formation];
	_radForm = _radForm + format [". %1",(_formations select _formation) select 1];
};

if (_behavior > 0) then {
	_beh = (_behaviors select _behavior) select 0;
	_sqd setBehaviour _beh;
	(_sqArr select 4) set [0,_behavior];
	_radForm = _radForm + format [". %1",(_behaviors select _behavior) select 1];
};

if (_combatMode > 0) then {
	_combatM = (_combatModes select _combatMode) select 1;
	_sqd setCombatMode _combatM;
	(_sqArr select 4) set [1,_combatMode];
	_radForm = _radForm + format [". %1",(_combatModes select _combatMode) select 2];
};

if (_speedMode > 0) then {
	_speedM = (_speedModes select _speedMode) select 0;
	_sqd setSpeedMode _speedM;
	(_sqArr select 4) set [2,_speedMode];
	_radForm = _radForm + format [". %1",(_speedModes select _speedMode) select 1];
};