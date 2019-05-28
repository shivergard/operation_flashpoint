/* 
	in2Darray
	Searchs for an element in a 2D array and returns the index
	of its parent array in the main array
	
	If nothing is found it'll return -1.
	
	USE: [<element>,<main array>] call in2Darray
	
	by kenoxite
*/

private ["_ele","_arr","_i","_result"];

_ele = _this select 0;
_arr = _this select 1;

_result = -1;
_i = 0;
{
	if (_ele in _x) then { 
		_result = _i;
	};
	_i = _i + 1;
} forEach _arr;

_result