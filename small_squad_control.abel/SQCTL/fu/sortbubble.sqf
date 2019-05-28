/*
PURPOSE:    Sort given array according to given evaluator.
HISTORY:    bn880 24/02/2003
INPUTS:     _array: Array, objects to sort
            _eval: String, Evaluator to sort by 
            	_element becomes each element from _array
            	-(_eval) sorts in descending order
RETURNS:    BOOL, true on success
		false on error
ALGORITHM:
END ALGORITHM
CALL EXAMPLES:
 	SIMPLE ASCENDING NUMERIC SORT 
 	myArray = [2,6,3,7,8,4];
 	_ok = [myArray,"_element"] call SortBubble.sqf
 	myArray becomes [2,3,4,6,7,8]

	SIMPLE DESCENDING NUMERIC SORT 
 	myArray = [2,6,3,7,8,4];
 	_ok = [myArray,"-(_element)"] call SortBubble.sqf
 	myArray becomes [8,7,6,4,3,2]
 	
 	DISTANCE SORT TO PLAYER (DESCENDING)
 	_ok = [ myArray , "-(_element distance Player)"] call SortBubble.sqf
 	
 	DISTANCE SORT TO TEAM MEMBER 2 IN PLAYERS GROUP (ASCENDING)
 	_ok = [ myArray , "_element distance ((units (group Player)) select 1)"] call SortBubble.sqf

*/
private ["_array","_eval","_numArray","_j","_k","_tempVal","_tempNum","_element","_ok"];
_array = _this select 0;
_eval = _this select 1;

// CHECK FOR PASSED IN PARAMETERS
if (count _array == count _array && _eval == _eval) then {
_ok = true;

_count = count _array;
_numArray = [];
_numArray resize _count;

// ACQUIRE NUMERIC VALUES FROM EVALUATION
_j = 0;
while "_j < _count" do 
{
	_element = _array select _j;
	_numArray set [_j,call _eval];
	_j = _j + 1;
};

_j = 0;
// SORT
while "_j < _count -1" do 
{
	_k = _j + 1;
	while "_k < _count" do
	{
		if (_numArray select _j > _numArray select _k) then
		{
			_tempNum = _numArray select _j;
			_numArray set [_j,(_numArray select _k)];
			_numArray set [_k,_tempNum];
			
			_tempVal = _array select _j;
			_array set [_j,(_array select _k)];
			_array set [_k,_tempVal];
		};
		_k = _k + 1;
	};
	_j = _j + 1;
};
} else
{
	// ERROR
	_ok = false;
};
_ok;