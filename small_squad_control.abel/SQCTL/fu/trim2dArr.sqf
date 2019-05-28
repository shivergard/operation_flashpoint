/* 
	Trim 2d array
	
	Returns the array without the array element
	
	If element isn't found the array will be returned untouched
	
	Uses in2Darray function
	
	by kenoxite
*/

private ["_ele","_arr","_eI","_return"];

_ele = _this select 0;
_arr = _this select 1;

_eI = [_ele,_arr] call in2Darray;

if (_eI > -1) then {
	_arr set [_eI, -1];
	_arr = _arr - [-1];
};

_return = _arr;

_return