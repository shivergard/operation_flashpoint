if (_formation > 0) then { 
	_form = (_formations select _formation) select 0;
	(_grpArr select 3) set [3,_formation];
	_radForm = _radForm + format [". %1",(_formations select _formation) select 1];
	} else {
		if (_order == 2) then {
			_form = "WEDGE";
			_formation = 1;
		};
		if (_order == 4) then {
			_form = "WEDGE";
			_formation = 1;
		};
		if (_order == 6 or _order == 7) then {
			_form = "LINE";
			_formation = 2;
		};
};

if (_behavior > 0) then {
	_beh = (_behaviors select _behavior) select 0;
	(_grpArr select 3) set [0,_behavior];
	_radForm = _radForm + format [". %1",(_behaviors select _behavior) select 1];
	} else {
		if (_order == 5) then {
			_beh = "STEALTH";
			_behavior = 4;
			_stance = "DOWN";
		};
		if (_order == 6 or _order == 7) then {
			_beh = "COMBAT";
			_behavior = 2;
		};
	};

if (_combatMode > 0) then {
	_combatM = (_combatModes select _combatMode) select 1;
	(_grpArr select 3) set [1,_combatMode];
	_radForm = _radForm + format [". %1",(_combatModes select _combatMode) select 2];
	} else {
		if (_order == 5) then {
			_combatM = "GREEN";
			_combatMode = 3;
		};
		if (_order == 6) then {
			_combatM = "RED";
			_combatMode = 2;
		};
};

if (_speedMode > 0) then {
	_speedM = (_speedModes select _speedMode) select 0;
	(_grpArr select 3) set [2,_speedMode];
	_radForm = _radForm + format [". %1",(_speedModes select _speedMode) select 1];
	} else {
		if (_order == 6) then {
			_speedM = "FULL";
			_speedMode = 3;
		};
};