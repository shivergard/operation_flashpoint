comment {
// choice
//
// returns a random element of an array
//
// PARAM:
//    _this: an array
// RETURNS:
//    _ret: a random element from the array
// EXAMPLE:
//    _rnd = ["1", "foo", "bar", "nope"] call f_choice;
};
f_choice = {
   private["_r"];
   _r = random (count _this);
   _this select (_r - _r%1)
};

comment {
// sample
//
// returns random elements from an array
//
// PARAM:
//    _this[0]: N: number of random elements
//    _this[1]: an array
// RETURNS:
//    _ret: an array consisting of N random elements
// DEPENDS:
//    f_shuffle, f_listSlice
// EXAMPLE:
//    _sample = [3,[1, 2, 3, 4, 5, 6, 7, 8]] call f_sample;
//    -> _sample could be now [4, 7, 1]
};
f_sample = {
   _i=_this select 0;
   _this = + (_this select 1);
   _this call f_shuffle;
   [_this, 0, _i] call f_listSlice
};

comment {
// randInt
//
// returns a random integer between 0 and _this
//
// PARAM:
//    _this: maximum non-inclusive value
// RETURNS:
//    _ret: value between 0 and _this (but never _this)
// EXAMPLE:
//    _r = 50 call f_randInt;
};
f_randInt = {
   _this = random _this;
   _this - _this%1
};

comment {
// shuffle
//
// changes the items in the list in a random order
//
// PARAM:
//    _this: an array
// DEPENDS:
//    f_randInt
// EXAMPLE:
//    _a = [1, 2, 3, 4, 5];
//    _a call f_shuffle;
// INFO:
//    this function changes the array, it does not return another array
//    if you want the original array unchanged, create a copy like this:
//       _b = +_a;
//       _b call f_shuffle;
};
f_shuffle = {
   private["_i","_c","_tmp","_j"];
   _i = -1;
   _c = count _this;
   while{_i=_i+1;_i<_c} do {
      _j = _c call f_randInt;
      _tmp = _this select _i;
      _this set[_i, _this select _j];
      _this set[_j, _tmp];
   };
};

comment {
// randomPos2D
//
// returns a random position around the center with maximum radius
//
// PARAM:
//    _this[0]: center position  [x, y] or [x, y, z]
//    _this[1]: radius
// RETURNS:
//    _ret: random 2D position [x, y]
// EXAMPLE:
//    _pos = [getpos player, 300] call randomPos2D;
};
f_randomPos2D = {
   private["_pos","_r","_dir"];
   _pos = _this select 0;
   _r = random (_this select 1);
   _dir = random 360;
   [(_pos select 0) + _r*sin _dir, (_pos select 1) + _r*cos _dir]
};