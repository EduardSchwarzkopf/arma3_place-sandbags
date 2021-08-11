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
 
removeCancelSandbagAction = {
	player removeAction cancelSandbagAction;
};

addCancelSandbagAction = {
	cancelSandbagAction = player addAction ["Cancel Sandbag", {player setVariable ["SandbagAction", false];}];
};

getSandbagAction = {
	player getVariable "SandbagAction";
};
 
putSandbagAction = player addAction ["<t color='#20a01b'>Place Sandbag</t>", { 
  
	call addCancelSandbagAction;
	player setVariable ["SandbagAction", true];
    _anim = "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon"; 
  
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
	
	call removeCancelSandbagAction;

}];
