comment {
// listCountObj
//
// This function takes an array and returns an array it counts every occurence 
// of each element and creates an array of this.
//
// PARAMS:
//    _this: Array
// RETURNS:
//    _ret: [[obj0, count0], [obj1, count1], ...]
// NOTE:
//    creates a copy of the input list, thus may be CPU intensive.
// EXAMPLE:
//    ["a", "a", "b", "c", "c", "d", "e", "e"] call f_listCountObj
//    returns: [["a",2],["b",1],["c",2],["d",1],["e",2]]
};

f_listCountObj = {
   private["_list","_ret","_o"];

   _list = +_this;
   _ret = [];

   while {count _list > 0} do {
      _o = _list select 0;
      _ret set [count _ret, [_o, {_o == _x} count _list]];
      _list = _list - [_o];
   };
   _ret
};


comment {
// listFilter
//
// This function takes a list and returns a list that was filtered by the filter function.
// All entries that do not satisfy the filter condition will not appear in the result list.
//
// PARAMS:
//    _this[0]: list to be filtered
//    _this[1]: filter function
// RETURNS:
//    _ret: filtered list
// EXAMPLE:
//    [mylist, {alive _this}] call f_listFilter
};

f_listFilter = {
   private["_list","_func","_c","_i","_v","_ret"];
   _list = _this select 0;
   _func = _this select 1;
   _c = count _list;
   _i = -1;
   _ret = [];
   while {_i=_i+1; _i < _c} do {
      _v = _list select _i;
      if( _v call _func ) then {
         _ret set[count _ret, _v];
      };
   };
   _ret
};


comment {
// listMap
//
// This function takes an array and a function and creates a list of all values resulting 
// from the function applied to x. 
// The function has _this as its parameter: ex.: func = {typeOf _this}
//
// REFERENCE:
//    http://en.wikipedia.org/wiki/Map_(higher-order_function)
// PARAMS:
//    _this[0]: array
//    _this[1]: function
// RETURNS:
//   _ret:  [(array select 0) call function, (array select 1) call function, ... ]
// EXAMPLE:
//    _new = [_mylist, {sin _this}] call f_listMap
};

f_listMap = {
   private["_list","_func","_c","_i","_ret","_x"];
   _list = _this select 0;
   _func = _this select 1;
   _c = count _list;
   _i = -1;
   _ret = [];
   while {_i=_i+1; _i < _c} do {
      _ret set [_i, (_list select _i) call _func];
   };
   _ret
};

comment {
// listMapIf
//
// This function is similar to listMap; but before adding an element to
// the new list, it checks if the supplied condition evaluates to true.
//
// PARAMS:
//    _this[0]: list
//    _this[1]: function
//    _this[2]: condition
// RETURNS:
//   _ret:  [_item0 call function, _item1 call function, ... ]
// EXAMPLE:
//    _mylist = [0, 1, 2, 3, 4, 5, 6, 7, 8];
//    _new = [_mylist, {_this^2}, {_this%2==0}] call f_listMapIf;
//    -> _new = [0, 4, 16, 36, 64];
};

f_listMapIf = {
   private["_list","_func","_pred","_ret"];
   _list = _this select 0;
   _func = _this select 1;
   _pred = _this select 2;
   _ret = [];
   {
      if(_x call _pred) then {
         _ret set[count _ret, _x call _func];
      };
   } foreach _list;
   _ret
};

comment {
// listFold, listFold1
//
// This function takes an array and a function (with variables _a and _b). f_listFold takes
// the first element of the array and applies the function to it and the next element.
// It then takes the result and applies the function to it and the next element, a.s.o.
// Let's take calculating the sum as an example:
// _array = [1, 2, 3, 4];
// _function = {_a + _b}
// _init = 0
// listFold now assigns _a=_init (thus _a=0) and assigns _b=1 (since 1 is the next element 
// in _array). Afterwards _a=_a+_b (_a=1) is assigned, then _b=2 (since 2 is the next element). 
// Again, _a+_b is calculated and assigned to _a (_a=3) and _b=3 (3rd element). 
// The end result is 10.
//
// There is an additional function f_listFold1 which uses the first element of the array
// as the init-value. Of course the array you supply needs at least one element.
//
// REFERENCE: 
//    http://en.wikipedia.org/wiki/Fold_(higher-order_function)
// PARAM:
//    _this[0]: array
//    _this[1]: function with parameters _a and _b.
//    _this[2]: Initial value
// RETURNS:
//    _ret: result from the function always applied to the current result and next array element
// EXAMPLE:
//    _array = [1, 2, 3, 4];
//    _sum = [_array, {_a + _b}, 0];
//    -> _sum is 1+2+3+4 = 10
};
f_listFold = {
   private["_list","_func","_i","_c","_a","_b"];
   _list = _this select 0;
   _func = _this select 1;
   _a = _this select 2;
   {
      _b=_x;
      _a=call _func;
   } foreach _list;
   _a
};

f_listFold1 = {
   private["_list","_func","_i","_c","_a","_b"];
   _list = _this select 0;
   _func = _this select 1;
   _i=0;
   _c=count _list;
   _a=_list select 0;
   while{_i=_i+1; _i<_c} do {
      _b = _list select _i;
      _a = call _func;
   };
   _a
};

comment {
// listSlice
//
// returns a slice of the array
//
// PARAM:
//    _this[0]: array
//    _this[1]: lower index
//    _this[2]: count
// RETURNS:
//    _ret: [array[lowerIndex], array[lowerIndex+1], ..., array[lowerIndex+count-1]]
// EXAMPLE:
//    _a = [1, 2, 3, 4, 5, 6];
//    _b = [_a, 3, 2] call f_listSlice;
//    -> _b = [4, 5]
};

f_listSlice = {
   private["_arr","_idx","_c","_res","_i","_n"];
   _arr = _this select 0;
   _idx = _this select 1;
   _c = _this select 2;
   
   _res = [];
   _i=_idx-1;
   _n=_idx+_c;
   while{_i=_i+1;_i<_n} do {
      _res set[count _res, _arr select _i];
   };
   _res
};


comment {
// listInsert
//
// inserts an item at a specific position and moves all other entries one position to the back.
// this function modifies the passed array, it does not return a new array.
//
// PARAM:
//    _this[0]: array
//    _this[1]: index/position at which the item should be inserted
//    _this[2]: item to be inserted
// EXAMPLE:
//    A = [1, 2, 3, 4, 5];
//    [A, 2, 10] call f_listInsert;
//    -> A is now [1, 2, 10, 3, 4, 5]
};
f_listInsert = {
   private["_arr","_idx","_item","_i"];
   _arr = _this select 0;
   _idx = _this select 1;
   _item = _this select 2;
   
   _i = count _arr + 1;
   while{_i=_i-1; _i > _idx} do {
      _arr set[_i, _arr select (_i-1)];
   };
   _arr set[_idx, _item];
};

comment {
// listExtend
//
// This function takes two arrays as parameters and extends the first
// array with all elements from the second array.
//
// PARAM:
//    _this[0]: target array
//    _this[1]: array
// EXAMPLE:
//    A = [1, 2, 3];
//    [A, [4, 5]] call f_listExtend;
//    -> A = [1, 2, 3, 4, 5]
};
f_listExtend = {
   private["_arr"];
   _arr = _this select 0;
   {
      _arr set[count _arr, _x];
   } foreach (_this select 1);
};


comment {
// listUniquify
//
// returns a new array in which all items occur exactly once
// (it removes all duplicates)
//
// PARAM:
//    _this: an array
// RETURNS:
//    _ret: an array without duplicates
// EXAMPLE:
//    _a = [1, 4, 4, 1, 3] call f_listUniquify;
//    -> _a is [1, 4, 3]
};
f_listUniquify = {
   private["_ret"];
   _ret = [];
   {
      if !(_x in _ret) then { _ret set[count _ret, _x] }
   } foreach _this;
   _ret
};

comment {
// listRange
//
// returns an array filled with numbers from 0 to N (excluding)
//
// PARAM:
//    _this: N
// RETURNS:
//    _ret: [0, 1, 2, ..., N-1]
// EXAMPLE:
//    _a = 10 call f_listRange;
//    -> _a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
};
f_listRange = {
   private["_ret","_i"];
   _ret = [];
   _i = _this;
   while{_i=_i-1;_i>=0} do {
      _ret set[_i, _i];
   };
   _ret
};

comment {
// listLookup
//
// Looks for the search key in the key array and uses the
// index of the key in the value array to obtain the value
// associated with that key.
// If the key does not exist, the 4th parameter is returned as a
// default value.
// This function is to be considered as a 'safe' variant to the
// following code:
//    _val = _values select (_keys find _key);
//
// If you are 100% sure that _key is in _keys, use the above snippet.
// 
// PARAM:
//    _this[0]: key array
//    _this[1]: value array (same count as the key array)
//    _this[2]: search key
//    _this[3]: default value
// RETURNS:
//    _ret: value associated with key (or default value)
// DEPENDS:
//    CWA 1.99 find-command
// EXAMPLE:
//    _difficulty = "HARD";
//    _numEnemies = [["EASY", "MEDIUM", "HARD", "EVIL"], [20, 50, 100, 200], _difficulty, 50];
//    -> _numEnemies = 100
//
//    _difficulty = "BOGUS";
//    _numEnemies = [["EASY", "MEDIUM", "HARD", "EVIL"], [20, 50, 100, 200], _difficulty, 50];
//    -> _numEnemies = 50   (default value)
};
f_listLookup = {
   private["_idx"];
   _idx = (_this select 0) find (_this select 2);
   if(_idx != -1) then {
      (_this select 1) select _idx
   } else {
      _this select 3
   }
};

comment {
// listLookupSet
//
// Looks for the search key in the key array and uses the
// index of the key in the value array to obtain the value
// associated with that key.
// If the key does not exist, the key is added to the key array,
// the default value is added to the value array.
// 
// PARAM:
//    _this[0]: key array
//    _this[1]: value array (same count as the key array)
//    _this[2]: search key
//    _this[3]: default value
// RETURNS:
//    _ret: value associated with key (or default value)
// DEPENDS:
//    CWA 1.99 find-command
// EXAMPLE:
//    _keys = ["EASY", "MEDIUM", "HARD", "EVIL"];
//    _values = [20, 50, 100, 200];
//    _difficulty = "HARD";
//    _numEnemies = [_keys, _values, _difficulty, 50];
//    -> _numEnemies = 100
//
//    _keys = ["EASY", "MEDIUM", "HARD", "EVIL"];
//    _values = [20, 50, 100, 200];
//    _difficulty = "BOGUS";
//    _numEnemies = [_keys, _values, _difficulty, 50];
//    -> _numEnemies = 50
//    -> _keys = ["EASY", "MEDIUM", "HARD", "EVIL", "BOGUS"]
//    -> _values = [20, 50, 100, 200, 50];
};
f_listLookupSet = {
   private["_keys","_values","_idx","_def"];
   _keys = _this select 0;
   _values = _this select 1;
   _idx = _keys find (_this select 2);
   if(_idx != -1) then {
      _values select _idx
   } else {
      _def = _this select 3;
      _keys set[count _keys, _this select 2];
      _values set[count _values, _def];
      _def
   }
};