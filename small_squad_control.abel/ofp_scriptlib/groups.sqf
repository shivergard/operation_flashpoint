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

f_groupIsCargo = {
   _res = true;
   {
      _veh = vehicle _x;
      _res = _res && _x!=_veh && _x!=driver _veh && _x!=gunner _veh && _x!=commander _veh;
   } foreach units _this;
   _res
};


comment {
// groupVehicles
//
// this function takes a group as a parameter and lists all
// vehicles that are belonging to this group
// PARAM:
//    _this:  group from which the vehicle list is built
// RETURNS:
//    _ret:  a list of vehicles (every vehicle occurs only once)
// EXAMPLE:
//   _vehicles = group player call f_groupVehicles;
};

f_groupVehicles = {
   private["_units","_ret","_i","_v"];
   _units = units _this;
   _ret = [];
   _i = count _units;
   while {_i=_i-1; _i >= 0} do {
      _v = vehicle (_units select _i);
      if(not (_v in _ret)) then { _ret set[count _ret, _v]; };
   };
   _ret
};


comment {
// getGroupId
//
// this function looks for the string ID of a group as specified by SCF Mission Generator
// PARAMS:
//    _this[0]: Group definition list [ "ID", ... ]
//    _this[1]: Group to be looked up
// RETURNS:
//    _ret: "ID" of the Group (or "XXX" if not found)
// EXAMPLE:
//    westA2 = group player;
//    _id = [["westA0","westA1","westA2"], group player] call f_getGroupId;
//    -> _id is now "westA2"
};

f_getGroupId = {
   private["_list","_grp","_ret","_i"];

   _list = _this select 0;
   _grp = _this select 1;
   _ret = "XXX";

   _i = count _list;
   while {_i=_i-1; _i >= 0} do {
      if( _grp == call (_list select _i) ) then {
         _ret = _list select 1;
         _i=0;
      };
   };
   _ret
};

comment {
// getGroupRTO
//
// this scripts returns the group's RTO
// PARAMS:
//    _this: group
// RETURNS:
//    _retval:  group's RTO or objNull
// DEPENDS:
//    scfRadioWeapons: class array (weapon class name) of radio weapons
// EXAMPLE:
//    scfRadioWeapons = ["ww4_radio"];
//    _rto = units player call f_getGroupRTO;
};
f_getGroupRTO = {
   private["_ret","_units","_i","_unit"];
   _ret = objNull;
   _units = units _this;
   _i = count _units;
   while {_i=_i-1; _i >= 0} do {
      _unit = _units select _i;
      if( {_x in scfRadioWeapons} count (weapons _unit) > 0) then { 
         _ret = _unit;
         _i=0;
      };
   };
   _ret
};


comment {
// hasRTO
//
// this scripts returns whether a group has a RTO
// _this = group
//
// NOTE: 
//    Use getGroupRTO instead and check with isNull
// DEPENDS:
//    scfRadioWeapons
// EXAMPLE:
//    scfRadioWeapons = ["ww4_radio"];
//    _hasComms = units player call f_hasRTO;
};
f_hasRTO = {
   private["_ret","_units","_i","_unit"];
   _ret = false;
   _units = units _this;
   _i = count _units;
   while {_i=_i-1; _i >= 0 && !_ret} do {
      _unit = _units select _i;
      _ret = ( {_x in scfRadioWeapons} count (weapons _unit)  ) > 0;
   };
   _ret
};


comment {
// getGroupSpeed
//
// this function receives a group and calculates the medium speed of the group
//
// PARAMS:
//    _this: group
// RETURNS:
//    _ret: float    groups medium speed
// EXAMPLE:
//    _speed = group player call f_getGroupSpeed;
};
f_getGroupSpeed = {
   private["_units","_s","_c"];
   _units = units _this;
   _c = count _units;
   if(_c==0)then {
      0.0
   } else {
      _s = 0;
      { _s=_s + speed _x; } foreach _units;
      _s / _c
   }
};


comment {
// getGroupVelocity
//
// this function receives a group and calculates the Medium velocity vector of the group
//
// PARAMS:
//    _this: group
// RETURNS:
//    _ret: float[3]  groups medium velocity
// EXAMPLE:
//    _vel = myGrp call f_getGroupVelocity;
};
f_getGroupVelocity = {
   private["_units","_vx","_vy","_vz","_c","_i","_v"];
   _units = units _this;
   _c = count _units;
   if(_c == 0) then {
      [0,0,0]
   } else {
      _vx = 0;
      _vy = 0;
      _vz = 0;
      {
         _v = velocity _x;
         _vx = _vx + (_v select 0);
         _vy = _vy + (_v select 1);
         _vz = _vz + (_v select 2);
      } foreach _units;
      [_vx/_c, _vy/_c, _vz/_c]
   }
};


comment {
// getGroupSpread
//
// this function calculates the spreading radius of a group
// it calculates the min and max values of the x- and y-
// coordinates, subtracts and halves them and returns
// the diagonal length
//
// PARAMS:
//    _this: group
// RETURNS:
//    _ret: float  groups spread value
// EXAMPLE:
//    _spreadRadius = group player call f_getGroupSpread;
};
f_getGroupSpread = {
   private["_units","_c","_i","_pos","_xmin","_xmax","_ymin","_ymax","_x","_y"];
   _units = units _this;
   _c = count _units;
   if(_c < 2) then {
      0.0
   } else {
      _i = 1;
      _pos = getpos (_units select 0);
      _xmin = _pos select 0; _ymin = _pos select 1;
      _xmax = _xmin; _ymax = _ymin;
      {
         _pos = getpos _x;
         _xx = _pos select 0; _yy = _pos select 1;
         if(_xx < _xmin) then { _xmin=_xx };
         if(_xx > _xmax) then { _xmax=_xx };
         if(_yy < _ymin) then { _ymin=_yy };
         if(_yy > _ymax) then { _ymax=_yy };
      } foreach _units;
      
      sqrt( (_xmax-_xmin)^2 + (_ymax-_ymin)^2 )
   }
};


comment {
// mostInjured
//
// this function returns the soldier with the heaviest
// wounds
//
// PARAMS:
//    _this:  group
// RETURNS:
//    _retval: most injured unit
// EXAMPLE:
//    _injuredMember = group player call f_mostInjured;
};
f_mostInjured = {
   private["_units","_ret","_dmg","_u"];
   _units = _this;
   _ret = objNull;
   _dmg = 0;
   {
      if ( (damage _x > _dmg) && (alive _x) ) then {
         _ret = _x;
         _dmg = damage _x;
      };
   } foreach _units;
   _ret
};


comment {
// filterGroups
//
// takes an array of units and returns all groups (unit array comes from a trigger for example)
//
// PARAM:
//    _this: unit array
// RETURNS:
//    _ret: group array
// EXAMPLE:
//    _groups = list some_trigger call f_filterGroups;
};

f_filterGroups = {
   _res = [];
   {
      if !(group _x in _res) then { _res set[count _res, group _x]; };
   } foreach _this;
   _res
};
