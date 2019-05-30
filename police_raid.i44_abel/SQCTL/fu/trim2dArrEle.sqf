/* 
	Trim 2d array element
	
	Returns the passed 2D array without the element
	
	If element isn't found the array will be returned untouched
	
	by kenoxite
*/

private ["_ele","_arr","_i","_eI","_return"];

_ele = _this select 0;
_arr = _this select 1;

_eI = -1;
_i = 0;
{
	if (_ele in _x) then { 
		_eI = _i;
	};
	_i = _i + 1;
} forEach _arr;

if (_eI > -1) then {
	_arr set [_eI, (_arr select _eI) - [_ele]];
};

_return = _arr;

_return