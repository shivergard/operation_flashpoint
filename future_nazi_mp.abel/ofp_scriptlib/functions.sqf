comment {
// funcName
//
// description
//
// PARAM:
//    _this[]: description
// RETURNS:
//    _ret: description
// DEPENDS:
//    varname: description
// EXAMPLE:
//    example
};


comment {
// classifyTarget
//
// This function takes an object as parameter and
// checks its type to classify it
//
// PARAMS:
//    _this: object = target to be classified
// RETURNS:
//    _ret: String, one of "Armor", "Truck", "Wheeled Vehicle", "Chopper", "Plane", "Surface Vessel", "Target", "Soldier"
// DEPENDS:
//    c_ClassificationTypes
// EXAMPLE:
//    _classification = vehicle player call f_classifyTarget;
//    would return "Infantry" if the player is not within a vehicle
};
f_classifyTarget = {
   private["_ret","_i"];
   _ret = "Target";
   _i=count c_ClassificationTypes;
   while{_i=_i-1;_i>=0}do{
      if((c_ClassificationTypes select _i) select 0 countType [_this] == 1) then {
         _ret = c_ClassificationTypes select _i select 1;
         _i=0;
      };
   };
   _ret
};

comment {
// classifyGroupString
//
// this function takes a group and returns a list of the amount of
// vehicles and their specification
//
// PARAMS:
//    _this:  group
// RETURNS:
//    _ret:  list of numbers and specs ie:  [ ["Armor", 3], ["Chopper", 1], ["Infantry", 3] ]
// DEPENDS:
//    f_groupVehicles, f_classifyTarget, f_listMap, f_listCountObj
// EXAMPLE:
//    _classifications = group player call f_classifyGroupString;
};

f_classifyGroupString = {
   ([_this call f_groupVehicles, f_classifyTarget] call f_listMap) call f_listCountObj
};



comment {
// contactRadioString
//
// this function takes an array of type [ ["Tank", 2], ["Soldier", 3], ... ]
// and creates a string out of it, so it can be processed through the radio
//
// PARAMS:
//      _this:  array of type [ [type, count], ... ]
// RETURNS:
//      _ret: string of type: "2 Tanks, 3 Soldiers, 1 APC"
// EXAMPLE:
//    _classifications = group player call f_classifyGroupString;
//    _text = _classifications call f_contactRadioString;
};
f_contactRadioString = {
   private["_c","_n","_t","_ret","_i"];
   _c = count _this;
   if( _c == 0 ) then {
      "Empty array passed to 'f_contactRadioString'"
   } else {
      _n = (_this select 0) select 1;
      _t = (_this select 0) select 0;
      _ret = format["%1 %2", _n, if(_n==1) then { _t } else { _t + "s" } ];
      _i = 1;
      while {_i < _c} do {
         _n = (_this select _i) select 1;
         _t = (_this select _i) select 0;
         _ret = _ret + format[", %1 %2", _n, if(_n==1) then { _t } else { _t + "s" } ];
         _i = _i + 1;
      };
      _ret
   }
};

comment {
// getElev
//
// This function takes a position and returns the ground elevation at this point.
//
// PARAMS:
//      _this: position [x, y] or [x, y, z]
// RETURNS:
//      _ret: elevation height at position
// DEPENDS:
//    c_Sensor
// EXAMPLE:
//    _elev = getpos player call f_getElev;
};
f_getElev = {
   c_Sensor setpos [_this select 0, _this select 1, 0]; -(getpos c_Sensor select 2)
};

comment {
// getPosASL
//
// This function takes an object/vehicle and returns its position above sea level
//
// PARAMS:
//      _this: object
// RETURNS:
//      _ret: [x, y, heightASL]
// DEPENDS:
//    c_Sensor
// EXAMPLE:
//    _posASL = player call f_getPosASL;
// INFO:
//    in CWA 1.99 you can use the native getPosASL!
};
f_getPosASL = {
   private["_p"];
   _p=getpos _this;
   c_Sensor setpos [_p select 0, _p select 1, 0]; [_p select 0, _p select 1, (_p select 2)-(getpos c_Sensor select 2)]
};

comment {
// getHeightASL
//
// This function takes an object/vehicle and returns its height above sea level
//
// PARAMS:
//      _this: object
// RETURNS:
//      _ret: object's height above sea level
// DEPENDS:
//    c_Sensor
// EXAMPLE:
//    _heightASL = player call f_getHeightASL;
// INFO:
//    in CWA 1.99 you can use: getPosASL _veh select 2
};
f_getHeightASL = {
   private["_p"];
   _p=getpos _this;
   c_Sensor setpos [_p select 0, _p select 1, 0]; (_p select 2)-(getpos c_Sensor select 2)
};


comment {
// findTypeOf
//
// this function takes a unit array and a type array and returns
// one unit whose type is on the type array
// PARAMS:
//    _this[0]:  array of strings (type array)
//    _this[1]:  unit array
// RETURNS:
//    _ret:  unit that is one of the types in type array, or objNull
// EXAMPLE:
//    _medic = [["SoldierWMedic"], units player] call f_findTypeOf;
};
f_findTypeOf = {
   private["_ar","_un","_i"];
   _ar = _this select 0;
   _un = _this select 1;
   _i = count _un;
   _u=objNull;
   while {_i=_i-1; _i>=0} do {
      if ( typeOf (_un select _i) in _ar ) then {
         _u = _un select _i;
         _i=0;
      };
   };
   _u
};



comment {
// getClickedMarker
//
// this function returns the index of the clicked marker or -1 if there is no one close
// close means: position is within 50m (the script uses the square of the distance, thus
//              2500 = 50*50)
// PARAMS:
//    _this[0]: position (of map click) [x,y]
//    _this[1]: marker array
// RETURNS:
//    _ret: index of marker or -1
// EXAMPLE:
//    [_pos, ["Marker1", "Marker2", "Marker3"]] call f_getClickedMarker;
};
f_getClickedMarker = {
   private["_pos","_markers","_x","_y","_index","_dmin","_i","_mpos","_mx","_my","_d"];
   _pos = _this select 0;
   _markers = _this select 1;
   _x = _pos select 0;
   _y = _pos select 1;

   _index = -1;
   _dmin = 2500;
   _i = count _markers;
   while {_i=_i-1;_i >= 0} do {
      _mpos = getMarkerPos (_markers select _i);
      _mx = _mpos select 0;
      _my = _mpos select 1;
      _d = (_x-_mx)^2 + (_y-_my)^2;
      if( _d < _dmin ) then { _index = _i; _dmin = _d };
   };
   _index
};

comment {
// getClickedGroup
//
// this function returns the index of the clicked group or -1 if there is no one close
// close means: position is within 50m (the script uses the square of the distance, thus
//              2500 = 50*50)
// IMPORTANT: it ignores mounted groups (groups which are mounted as cargo)
// PARAMS:
//    _this[0]: position (of map click) [x,y]
//    _this[1]: group array
// RETURNS:
//    _ret: index of group or -1
// DEPENDS:
//    f_groupIsCargo
// EXAMPLE:
//    [_pos, [grp1, grp2, grp3]] call f_getClickedGroup;
};
f_getClickedGroup = {
   private["_pos","_groups","_x","_y","_index","_dmin","_i","_grp","_gpos","_gx","_gy","_d"];
   _pos = _this select 0;
   _groups = _this select 1;
   _x = _pos select 0;
   _y = _pos select 1;
   _index = -1;
   _dmin = 2500;
   _i = count _groups;
   while{_i=_i-1; _i>=0} do {
      _grp = _groups select _i;
      if !(_grp call f_groupIsCargo) then {
         _gpos = getpos vehicle leader _grp;
         _gx = _gpos select 0;
         _gy = _gpos select 1;
         _d = (_x-_gx)^2 + (_y-_gy)^2;
         if(_d < _dmin) then {_index =_i; _dmin = _d; };
      };
   };
   _index
};


comment {
// getFirstAlive
//
// this function takes an array and returns the first alive unit in that array
// PARAMS:
//    _this:  array of units
// RETURN:
//    _ret: alive unit  or objNull
// EXAMPLE:
//    units player call f_getFirstAlive;
};

f_getFirstAlive = {
   private["_ret","_i","_c"];
   _ret = objNull;
   _i = -1;
   _c = count _this;
   while{_i = _i + 1;_i < _c} do {
      if( alive (_this select _i) ) then {_ret=_units select _i; _i=_c; };
   };
   _ret
};


comment {
// oneNearPos
//
// this function takes an array of units and a position and returns whether
// one of the units is within 5m of that position (in the code 5*5=25 is used)
// PARAMS:
//    _this[0]:  unit array
//    _this[1]:  position [x,y]
// RETURNS:
//    _retval:  bool <- one unit is close to position
// EXAMPLE:
//    _waypointReached = [units player, _waypoint] call f_oneNearPos;
};
f_oneNearPos = {
   private["_units","_pos","_xx","_yy","_i","_ret","_xxx","_yyy"];
   _units = _this select 0;
   _pos = _this select 1;
   _xx = _pos select 0;
   _yy = _pos select 1;
   _i = count _units;
   _ret = false;
   while {_i=_i-1; _i >= 0} do {
      _xxx = _xx - (getpos (_units select _i) select 0);
      _yyy = _yy - (getpos (_units select _i) select 1);
      if( (_xxx^2 + _yyy^2) < 25 ) then { _ret = true; _i=0; };
   };
   _ret
};

comment {
// pos2grid
//
// This function takes a position and returns either NATO- or OFP-grid string.
// you can also use f_pos2NATOGrid or f_pos2OFPGrid directly.
//
// PARAMS:
//    _this: position[x,y] or [x,y,z]
// RETURNS:
//    _ret:  string (either "Aa00" or "123123")
// DEPENDS:
//    scfGridType: string   should be either "NATO" or "OFP"
// NOTE:
//    after the first call f_pos2grid points either to the function f_pos2NATOGrid or
//    f_pos2OFPgrid
// BUG:
//    if scfGridType is not supplied, f_pos2grid calls itself infinitely...
// EXAMPLE:
//    scfGridType = "OFP";
//    _grid = getpos player call f_pos2grid;
};
f_pos2grid = {
   if( scfGridType == "NATO" ) then {
      f_pos2grid = f_pos2NATOGrid;
   } else {
      f_pos2grid = f_pos2OFPgrid;
   };
   _this call f_pos2grid
};

f_pos2NATOGrid = {
   private ["_x","_y","_xrest","_xgrid1","_xgrid2","_xgrid3","_xstring"];

   _x = _this select 0;
   _y = _this select 1;

   if  ((_x < 0) OR (_x >= 51200) OR (_y < 0) OR (_y >= 51200) ) then {
      "XXXXXX"
   } else {
      _xrest = _x mod 10000;
      _xgrid1 = (_x - _xrest)/10000;
      _xgrid2 =(_xrest - (_xrest % 1000))/1000;
      _xgrid3 = (_x mod 1000) / 100;
      _xgrid3 = _xgrid3 - _xgrid3 % 1;
      _xstring = (c_NumArray select _xgrid1) + (c_NumArray select _xgrid2) + (c_NumArray select _xgrid3);

      _xrest = _y mod 10000;
      _xgrid1 = (_y - _xrest)/10000;
      _xgrid2 =(_xrest - (_xrest % 1000))/1000;
      _xgrid3 = (_y mod 1000) / 100;
      _xgrid3 = _xgrid3 - _xgrid3 % 1;
      _xstring + (c_NumArray select _xgrid1) + (c_NumArray select _xgrid2) + (c_NumArray select _xgrid3)
   }
};

f_pos2OFPgrid = {
   private ["_x", "_y", "_xrest", "_xgrid1", "_xgrid2", "_xstring", "_ygrid", "_ystring"];

   _x = _this select 0;
   _y = _this select 1;

   if  ((_x < 0) OR (_x >= 12800) OR (_y < 0) OR (_y >= 12800) ) then {
      "XxXx"
   } else {
      _xrest = _x mod 1280;
      _xgrid1 = (_x - _xrest)/1280;
      _xgrid2 =(_xrest - (_xrest mod 128))/128;
      _xstring = (c_UpperChar select _xgrid1) + (c_LowerChar select _xgrid2);

      _ygrid = 99 - (_y - (_y Mod 128))/128;
               
      _ystring = Format["%1",_ygrid];
      if (_ygrid < 10) then {_ystring = "0" + _ystring};

      _xstring + _ystring
   }
};


comment {
// time2string
//
// this function takes a float between 0 and 24 that is interpreted as a time
// and converts it to a string like "14:11"
// PARAMS:
//    _this[0]: time
//    _this[1]: separator ".", ":" or ""
// RETURNS:
//    _retval: time string
// EXAMPLE:
//    [12.5, ":"] call f_time2string
//    result is: "12:30"
};
f_time2string = {
   private["_t","_sep","_m","_h"];

   _t = _this select 0;
   _sep = _this select 1;

   _m = _t % 1;
   _h = _t - _m;

   _m = _m * 60;
   _m = _m - (_m%1);

   format[ (if(_h < 10) then { "0%1" } else { "%1" }) + _sep + (if(_m < 10) then {"0%2"} else {"%2"}), _h, _m ]
};

comment {
// f_nth
//
// Returns the number with an Ordinal Indicator.
// You get "1st" with 1, "2nd" with 2, "114th" with 114, a.s.o.
//
// REFERENCE:
//    http://en.wikipedia.org/wiki/Ordinal_indicator
// PARAM:
//    _this: integer
// RETURNS:
//    _ret: string with ordinal indicator
// EXAMPLE:
//    _a = 4
//    _str = format["You go with the %1 Infantry Battalion", _a call f_nth];
//    -> _str = "You go with the 4th Infantry Battalion"
};
f_nth = {
   private["_a"];
   if(10 < _this%100 && _this%100 < 14) then {
      format["%1th", _this]
   } else {
      _a = _this % 10;
      if(_a < 4) then {
         format[["%1th","%1st","%1nd","%1rd"] select _a, _this]
      } else {
         format["%1th", _this]
      }
   }
};


comment {
// buildingPositions
//
// returns all AI path positions within a building
//
// PARAM:
//    _this: object (a building)
// RETURNS:
//    _ret: an array of positions [[x, y, z], ...]
// EXAMPLE:
//    object 103166 call f_buildingPositions
};
f_buildingPositions = {
   private["_r","_i","_p"];
   _r = [];
   _i = 0;
   while{_i >= 0} do {
      _p = _this buildingPos _i;
      if !((_p select 0) == 0 && (_p select 1) == 0) then {
         _r set[count _r, _p];
         _i = _i + 1;
      } else {
         _i = -1;
      };
   };
   _r
};