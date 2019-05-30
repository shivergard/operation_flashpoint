comment {
// Math library by Vektorboson
};


comment {
// FUNCNAME
//
// DESCRIPTION
//
// PARAMS:
//    this[0]: Type and Name
//
// RETURNS:
//    Type: Description
};



comment {
// m_v2mul, m_v2div, m_v2add, m_v2sub, m_v2mod
// and subsequent m_v3mul, ... and m_v4mul, ...
//
// Multiplies components with each other and returns the 3d-array of the products
//
// PARAMS:
//    N is one of [2, 3, 4]
//    this[0]: scalar[N]
//    this[1]: scalar[N]
//
// RETURNS:
//    scalar[N]: product of components
//
// NOTE:
//    The functions are generated.
};


_t_vMop = {
   private["_a","_b"];
   _a=_this select 0;
   _b=_this select 1;
   [%1]
};
_create_vMop = {
   private["_i","_r"];
   _i=-1;
   _r="";
   while{_i=_i+1;_i<_this} do {
      _r = _r + format["(_a select %1)%2(_b select %1)%3", _i, "%1", if(_i<_this-1) then{","}else{""}];
   };
   format[_t_vMop, _r]
};

_ops = [
   ["mul", "*"],
   ["div", "/"],
   ["add", "+"],
   ["sub", "-"],
   ["mod", "%"]
];
_create_vMops = {
   _N = _this;
   _tpl = _N call _create_vMop;
   {
      format[_tpl, _x select 1] call format["m_v%1%2 = _this;", _N, _x select 0]
   } foreach _ops;
};
2 call _create_vMops;
3 call _create_vMops;
4 call _create_vMops;

comment {
// m_vNmul, m_vNdiv, m_vNadd, m_vNsub, m_vNmod
//
// Multiplies (or other operators) components with each other and returns the Nd-array of the products (operation-result)
//
// PARAMS:
//    this[0]: scalar[N]
//    this[1]: scalar[N]
//
// RETURNS:
//    scalar[N]: product (or other operation-result) of components
};
_vNop = {
   private["_a","_b","_i","_r"];
   _a=_this select 0;
   _b=_this select 1;
   _r=[];
   _i=count _a;
   while{_i=_i-1;_i>=0} do {
      _r set[_i, (_a select _i)%1(_b select _i)];
   };
};
m_vNmul = format[_vNop, "*"];
m_vNdiv = format[_vNop, "/"];
m_vNadd = format[_vNop, "+"];
m_vNsub = format[_vNop, "-"];
m_vNmod = format[_vNop, "%"];




comment {
// m_v2dot, m_v3dot, m_v4dot
//
// PARAMS:
//    N in [2,3,4]
//    this[0]: scalar[N]
//    this[1]: scalar[N]
//
// RETURNS:
//    scalar: Dot-product of both vectors
};
_vMdot = {
   private["_a","_b"];
   _a=_this select 0;
   _b=_this select 1;
   %1
};
_create_vMdot = {
   private["_i","_r","_N"];
   _i=_this;
   _r="";
   while{_i=_i-1;_i>=0} do {
      _r=_r+format["(_a select %1)*(_b select %1)%2", _i, if(_i!=0)then{"+"}else{""}];
   };
   format[_vMdot,_r]
};
m_v2dot = 2 call _create_vMdot;
m_v3dot = 3 call _create_vMdot;
m_v4dot = 4 call _create_vMdot;


m_v2length = { sqrt([_this,_this] call m_v2dot) };
m_v3length = { sqrt([_this,_this] call m_v3dot) };
m_v4length = { sqrt([_this,_this] call m_v4dot) };

m_v2normalize = {
   private "_len";
   _len = _this call m_v2length;
   [(_this select 0)/_len, (_this select 1)/_len]
};
m_v3normalize = {
   private "_len";
   _len = _this call m_v3length;
   [(_this select 0)/_len, (_this select 1)/_len, (_this select 2)/_len]
};
m_v4normalize = {
   private "_len";
   _len = _this call m_v4length;
   [(_this select 0)/_len, (_this select 1)/_len, (_this select 2)/_len, (_this select 3)/_len]
};

comment {
// m_vNdot
//
// PARAMS:
//    this[0]: scalar[N]
//    this[1]: scalar[N]
//
// RETURNS:
//    scalar: Dot-product of both vectors
};
_vNdot = {
   private["_a","_b","_i","_r"];
   _a=_this select 0;
   _b=_this select 1;
   _r=0.0;
   _i=count _a;
   while{_i=_i-1;_i>=0} do {
      _r = _r + (_a select _i)*(_b select _i);
   };
};
m_vNdot = _vNdot;


comment { 
// matrix-vector, matrix-matrix ops 
//
// Internally, a matrix of dimension NxN is an array of length N^2
// thus a matrix is basically also a vector and only the used functions
// distinguish between both. Componentwise operations can be achieved
// by using the respective vector-ops like m_vNmul for component-wise
// multiplication.
};
_t_mvMmul = {
   private["_m","_v"];
   _m=_this select 0;
   _v=_this select 1;
   [%1]
};
_create_matMvecMmul = {
   _N = _this;
   _i=-1;
   _r="";
   while{_i=_i+1;_i<_N}do{
      _j=_N;
      while{_j=_j-1;_j>=0}do{
         _r=_r+format["(_m select %1)*(_v select %2)%3", _i*_N+_j, _j, if(_j!=0)then{"+"}else{""}];
      };
      if(_i!=_N-1)then{_r=_r+",";};
   };
   format[_matMvecMmul, _r]
};
m_mv2mul = 2 call _create_matMvecMmul;
m_mv3mul = 3 call _create_matMvecMmul;
m_mv4mul = 4 call _create_matMvecMmul;


comment {
// trunc, frac, floor, ceil, round
//
// "m_trunc" returns the integer part (number in front of decimal point)
// "m_frac" returns the fractional part of a number
// "m_floor" returns the next integer towards negative infinity
// "m_ceil" returns the next integer towards infinity
// "m_round" returns the nearest integer (rounds up for .5)
//
// PARAM:
//    _this: a number
// RETURNS:
//    _ret: see above
// EXAMPLE:
//    1.7 call m_trunc == 1
//    1.7 call m_frac == 0.7
//    1.7 call m_floor == 1
//    -1.2 call m_floor == -2
//    1.7 call m_ceil == 2
//    -1.2 call m_ceil == -1
//    1.2 call m_round == 1
//    1.5 call m_round == 2
//    -1.2 call m_round == -1
//    -1.5 call m_round == -1
//    -1.7 call m_round == -2
};
m_trunc = {_this-_this%1};

m_frac = {_this%1};

m_floor = {
   if(_this >= 0) then m_trunc else {
      if (_this%1 != 0) then {
         _this-1 - (_this-1)%1
      } else {
         _this
      }
   }
};

m_ceil = {
   if(_this <= 0) then m_trunc else {
      if(_this%1 != 0) then {
         _this+1 - (_this+1)%1
      } else {
         _this
      }
   }
};

m_round = {_this + 0.5 call m_floor};
