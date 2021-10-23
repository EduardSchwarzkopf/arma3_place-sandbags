// Author: shinySonic
// Credits: Regimental Combat Team 7

removeSandbagAction = ["<t color='#a01b1b'>Remove Sandbag</t>", {
    _unit = _this select 1;
    [_this select 0, _this select 2] remoteExec ["removeAction", 0, true];
    _anim = "AinvPknlMstpSnonWnonDnon_medic_1";
    _unit playMove _anim;
    waitUntil {animationState _unit == _anim || !alive _unit};
    waitUntil {animationState _unit != _anim || !alive _unit};
    if (!alive _unit) exitWith {};
    deleteVehicle (_this select 0);
}];
 
getSandbagAction = {
	player getVariable ["SandbagAction", false];
};

setSandbagAction = {
	player setVariable ["SandbagAction", _this];
};

canPlaceSandbag = {
	_result = true;
	if ( !( isNull objectParent player) || player getVariable ["ais_unconscious", false] ) then {
		_result = false;	
	};
	
	_result;
};


while {alive player} do {
	// Set Custom Control 8 to set Sandbags
	
	waitUntil {inputAction "User8" > 0 && !(call getSandbagAction)};
	
	if !(call canPlaceSandbag) then {continue};
	
	_cancelSandbagAction = player addAction ["Cancel Sandbag", {false call setSandbagAction;}];
	true call setSandbagAction;
		_anim = "AinvPknlMstpSnonWnonDnon_medic_1"; 
	
	_animStart = "AmovPknlMstpSnonWnonDnon";
	player playMove _animStart;
	waitUntil {animationState player == _animStart};	
	player playMove _anim; 
	waitUntil {animationState player == _anim || !alive player};  
	waitUntil {animationState player != _anim || !alive player}; 
	
	if (alive player && call getSandbagAction) then {
		
		_veh = createVehicle ["Land_BagFence_01_round_green_F", player modelToWorld [0, 1.5, 0], [], 0, "CAN_COLLIDE"]; 
		_veh setDir (getDir player)-180; 
			if (round (getPosATL player select 2) == 0) then { 
			_veh setPosATL [getPosATL _veh select 0, getPosATL _veh select 1, 0]; 
			_veh setVectorUp surfaceNormal position _veh; 
			}; 
			
		
		[_veh, removeSandbagAction] remoteExec ["addAction", side player, true]; 
	};
	
	player removeAction _cancelSandbagAction;
	sleep 3;
	false call setSandbagAction;
}
