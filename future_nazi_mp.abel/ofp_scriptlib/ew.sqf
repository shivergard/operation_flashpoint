comment {
// checkTerrainMasking
//
// This function checks whether the terrain occludes the line of sight ("terrain masking")
//
// PARAM:
//    _this[0]: first position ASL
//    _this[1]: second position ASL
//    _this[2]: _prec: step size (checks the terrain elevation every _prec meters)
//    _this[3]: _tol: tolerance (this actually elevates the line of sight up)
// RETURNS:
//    _ret: whether the LOS defined by the two positions is masked by the terrain
// DEPENDS:
//    f_getElev
// EXAMPLE:
//    _hasLineOfSight = ! [getposASL player, getposASL tank, 12.5, 1.0] call f_checkTerrainMasking;
//
//    ; another example
//    ; this adds an offset to the position of the SA11 (because the radar isn't at the object center)
//    _pos = getposASL _sa11;
//    _pos set[2, (_pos select 2) + 2.5]
//    _radarContact = [getposASL _f16, _pos, 50.0, 0.0] call f_checkTerrainMasking;
};

f_checkTerrainMasking = {
   private["_src","_tgt","_prec","_tol", "_srcX","_srcY","_srcZ","_tgtX","_tgtY","_tgtZ","_dx","_dy","_dz","_d","_n","_i","_los"];
   _src = _this select 0;
   _tgt = _this select 1;
   _prec = _this select 2;
   _tol = _this select 3;
   
   _srcX = _src select 0;
   _srcY = _src select 1;
   _srcZ = (_src select 2) + _tol;
   
   _tgtX = _tgt select 0;
   _tgtY = _tgt select 1;
   _tgtZ = (_tgt select 2) + _tol;
   
   _dx = _tgtX - _srcX;
   _dy = _tgtY - _srcY;
   _dz = _tgtZ - _srcZ;
   
   _d = sqrt(_dx^2 + _dy^2 + _dz^2);
   
   _n = _d / _prec;
   _i = 0;
   
   _dx = _dx/_n;
   _dy = _dy/_n;
   _dz = _dz/_n;
   
   _los = true;
   while {_i=_i+1; _i<_n && _los} do {
      _los = [_srcX + _i*_dx, _srcY + _i*_dy] call f_getElev < _srcZ + _i*_dz;
   };
   !_los
};


comment {
// decomposeVelocity
//
// this function decomposes the target's velocity into one part parallel
// to the radar-target line of bearing and into a perpendicular one.
// The parallel-part is the velocity towards or away from the radar which
// is required for Doppler-radars.
//
// PARAM:
//    _this[0]: 2D radar position
//    _this[1]: 2D target position
//    _this[2]: 2D target velocity
// RETURNS:
//    _ret[0]: parallel component of target velocity
//    _ret[1]: perpendicular component of target velocity
// DEPENDS:
//    m_v2dot, m_v2mul, m_v2sub
// EXAMPLE:
//    _components = [getpos _radar, getpos _f16, velocity _f16] call decomposeVelocity;
};

f_decomposeVelocity = {
   private["_dv","_len","_dot","_para","_perp"];
   _dv = [_this select 0, _this select 1] call m_v2sub;
   _dv = _dv call m_v2normalize;
   
   _dot = [_dv,_this select 2] call m_v2dot;
   _para = [_dot * (_dv select 0), _dot * (_dv select 1)];
   _perp = [_this select 2, _para] call m_v2sub;
   
   [_para, _perp]
};


comment {
// dBm, from_dBm
//
// f_dBm: converts a power to dBm (W to dBm)
// f_from_dBm: converts a dBm to a power (dBm to W)
//
// PARAMS:
//    this: number
// RETURNS:
//    float: number
};
f_dBm = { 10.0 * log(_this * 1000) };
f_from_dBm = { 0.001 * 10.0 ^(_this/10.0) };