comment {
// getGroupCallsign
//
// finds the GroupName and the GroupColor (as set for example by setGroupId)
// of a group
//
// PARAM:
//    _this: a group
// RETURNS:
//    _ret: [_groupName, _groupColor]
// DEPENDS:
//    c_grpNames, c_grpColors
// EXAMPLE:
//    group player setGroupId ["Bravo", "GroupColor7"];
//    _gnc = group player call f_getGroupCallsign;
//    -> _gnc is now ["Bravo", "Pink"]
// INFO:
//    IMPORTANT: setGroupId uses class-names from CfgWorlds.GroupNames and CfgWorlds.GroupColors,
//    while this function returns the actual ingame names.
//
//    In case you're using special group names and colors (for example a callsign addon)
//    you need to extend c_grpNames/c_grpColors with the additional callsigns
//    those are found in CfgWorlds.GroupNames and CfgWorlds.GroupColors of that
//    addon.
// CREDITS:
//    Drongo aka TacRod for the TrimGroupName-function from Drongo's Toolkit
};

f_getGroupCallsign = {
   private ["_s","_res","_a","_i","_cn","_cc","_j"];
   _s = side leader _this;
   _res = ["", ""];
   _this = format["%1", _this];
   if(_s == west) then {_a = "WEST";} else {
      if(_s == east) then {_a = "EAST";} else {
         if(_s == resistance) then {_a = "GUER";} else {
            if(_s == civilian) then {_a = "CIVL";};
         };
      };
   };
   
   _i=-1; 
   _cn=count c_grpNames;
   _cc=count c_grpColors;
   while{_i=_i+1;_i<_cn} do {
      _n = c_grpNames select _i;
      _j=-1;
      while{_j=_j+1;_j<_cc} do {
         if(_this == format["%1 %2 %3", _a, _n, c_grpColors select _j]) then {
            _res = [_n, c_grpColors select _j];
            _i = _cn;
            _j = _cc;
         };
      };
   };
   _res
};


comment {
// getGroupCallsignBatch
//
// finds the GroupName and the GroupColor (as set for example by setGroupId)
// for every group in the list. 
//    ! The list needs at least one element.
//    ! all groups need to be from the same side
//
// PARAM:
//    _this: an array of groups from the same side: [group1, group2, group3, ...]
// RETURNS:
//    _ret: [[_groupName1, _groupColor1], [_groupName2, _groupColor2], ...]
// DEPENDS:
//    c_grpNames, c_grpColors, f_listMap
// EXAMPLE:
//    grp0 setGroupId ["Bravo", "GroupColor2"];
//    grp1 setGroupId ["Charlie", "GroupColor7"];
//    grp2 setGroupId ["Golf", "GroupColor3"];
//    _gnc = [grp0, grp1, grp2] call f_getGroupCallsignBatch;
//    -> _gnc is now [["Bravo", "Red"],["Charlie","Pink"],["Golf","Green"]]
// INFO:
//    IMPORTANT: this function uses "find" from CWA 1.99, therefore it won't work
//               in OFP 1.96
};

f_getGroupCallsignBatch = {
   private ["_s","_res","_a","_i","_cn","_cc","_j","_fmt","_idx","_fnd"];
   
   _s = side leader (_this select 0);
   if(_s == west) then {_a = "WEST";} else {
      if(_s == east) then {_a = "EAST";} else {
         if(_s == resistance) then {_a = "GUER";} else {
            if(_s == civilian) then {_a = "CIVL";};
         };
      };
   };
   
   _this = [_this, {format["%1",_this]}] call f_listMap;
   _res = [];
   { _res set[count _res, []];} foreach _this;
   
   _fnd = 0;   
   _i=-1; 
   _cn=count c_grpNames;
   _cc=count c_grpColors;
   while{_i=_i+1;_i<_cn} do {
      _n = c_grpNames select _i;
      _j=-1;
      while{_j=_j+1;_j<_cc} do {
         _fmt = format["%1 %2 %3", _a, _n, c_grpColors select _j];
         _idx = _this find _fmt;
         if(_idx != -1) then {
            _res set[_idx, [_n, c_grpColors select _j]];
            _fnd = _fnd + 1;
            if(_fnd == count _this) then {
               _i = _cn;
               _j = _cc;
            };
         };
      };
   };
   _res
};
