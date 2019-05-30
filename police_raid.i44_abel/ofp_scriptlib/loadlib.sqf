_load=true;
if scfLibLoaded then {_load=false;};
if _load then {
   call loadfile "ofp_scriptlib\constants.sqf";
   call loadfile "ofp_scriptlib\ew.sqf";
   call loadfile "ofp_scriptlib\functions.sqf";
   call loadfile "ofp_scriptlib\groups.sqf";
   call loadfile "ofp_scriptlib\list.sqf";
   call loadfile "ofp_scriptlib\math.sqf";
   call loadfile "ofp_scriptlib\random.sqf";
   call loadfile "ofp_scriptlib\util.sqf";
   scfLibLoaded = true;
};