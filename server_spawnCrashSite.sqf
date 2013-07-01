//Animated Helicrashs for DayZ 1.7.7.1
//Version 0.3
//Release Date: 01. Juli 2013
//Author: Grafzahl / Finest
//Thread-URL: http://opendayz.net/threads/animated-helicrashs-0-1-release.9084/

private["_useStatic","_crashDamage","_lootRadius","_preWaypoints","_preWaypointPos","_endTime","_startTime","_safetyPoint","_heliStart","_deadBody","_exploRange","_heliModel","_lootPos","_list","_craters","_dummy","_wp2","_wp3","_landingzone","_aigroup","_wp","_helipilot","_crash","_crashwreck","_smokerand","_staticcoords","_pos","_dir","_position","_num","_config","_itemType","_itemChance","_weights","_index","_iArray","_crashModel","_lootTable","_guaranteedLoot","_randomizedLoot","_frequency","_variance","_spawnChance","_spawnMarker","_spawnRadius","_spawnFire","_permanentFire","_crashName"];

//_crashModel	= _this select 0;
//_lootTable	= _this select 1;
_guaranteedLoot = _this select 0;
_randomizedLoot = _this select 1;
_frequency	= _this select 2;
_variance	= _this select 3;
_spawnChance	= _this select 4;
_spawnMarker	= _this select 5;
_spawnRadius	= _this select 6;
_spawnFire	= _this select 7;
_fadeFire	= _this select 8;

if(count _this > 9) then {
	_useStatic = _this select 9;
} else {
	_useStatic = false;
};

if(count _this > 10) then {
	_preWaypoints	= _this select 10;
} else {
	_preWaypoints = 1;
};

if(count _this > 11) then {
	_crashDamage = _this select 11;
} else {
	_crashDamage = 1;
};

diag_log(format["CRASHSPAWNER: Starting spawn logic for animated helicrashs - written by dayzforum.net / Grafzahl [SC:%1||PW:%2||CD:%3]", str(_useStatic), str(_preWaypoints), _crashDamage]);

while {true} do {
	private["_timeAdjust","_timeToSpawn","_spawnRoll","_crash","_hasAdjustment","_newHeight","_adjustedPos"];
	// Allows the variance to act as +/- from the spawn frequency timer
	_timeAdjust = round(random(_variance * 2) - _variance);
	_timeToSpawn = time + _frequency + _timeAdjust;

	//Random Heli-Type
	_heliModel = "UH1H_DZ";

	//Random-Startpositions, Adjust this for other Maps then Chernarus
	_heliStart = [[3461.92,5021.77,0],[8582.35,14077.7,0]] call BIS_fnc_selectRandom;

	//A Backup Waypoint, if not Chernarus, set some Coordinates far up in the north (behind all possible Crashsites)
	_safetyPoint = [8450.08,20240,0];

	//Settings for the Standard UH1H_DZ
	_crashModel = "UH1Wreck_DZ";
	_exploRange = 195;
	_lootRadius = 0.35;

	//Adjust Wreck and Range of Explosion if its a Mi17_DZ
	if(_heliModel == "Mi17_DZ") then {
		_crashModel = "Mi8Wreck";
		_exploRange = 285;
		_lootRadius = 0.3;
	};

	//Crash loot just uncomment the one you wish to use by default with 50cals is enabled.
    //Table including 50 cals
    //_lootTable = ["Military"] call BIS_fnc_selectRandom;
    _lootTable = ["HeliCrash","HeliCrashWEST","HeliCrashEAST","MilitarySpecial"] call BIS_fnc_selectRandom;

	_crashName	= getText (configFile >> "CfgVehicles" >> _heliModel >> "displayName");

	diag_log(format["CRASHSPAWNER: %1%2 chance to start a crashing %3 with loot table '%4' at %5", round(_spawnChance * 100), '%', _crashName, _lootTable, _timeToSpawn]);

	// Apprehensive about using one giant long sleep here given server time variances over the life of the server daemon
	while {time < _timeToSpawn} do {
		sleep 5;
	};

	_spawnRoll = random 1;

	// Percentage roll
	if (_spawnRoll <= _spawnChance) then {

/*
==================================================================================================
		_staticcoords give you the possibility to organize your crashsites!

		Crashsites close to cherno or electro would be possible with that.
		Use the editor for your map, create some vehicles or triggers at points where you
		want your crashside (aprox), save it and extract all coordinates and put them in this
		2D-Array. If you dont know how to do this, dont use _staticcoords.

		I would advise you to create at least 100 positions, otherwise its too easy for your players
		to find the crash-locations after some time of playing on your server.

		!!!!!After you put in the coordinates you have to set _useStatic to true inside
		your server_monitor.sqf, default is false!!!!!
==================================================================================================
*/

		_staticcoords =	[
[1119.5856,2477.1587,0],
[2049.4011,4157.042,0],
[2417.7498,5415.9614,0],
[2069.3408,7501.646,0],
[2544.0464,10062.705,0],
[1217.4396,12906.027,0],
[2151.439,14969.227,0],
[4077.5103,14397.729,0],
[5357.3696,12729.261,0],
[9544.4023,13755.705,0],
[13260.243,12955.309,0],
[11709.926,12899.897,0],
[8867.6768,11847.066,0],
[11383.867,12037.931,0],
[12398.957,10911.218,0],
[10702.244,10132.81,0],
[6213.3643,10589.182,0],
[7068.3892,11744.375,0],
[12483.547,9277.1104,0],
[13112.597,10388.799,0],
[12956.182,8103.3271,0],
[9491.5674,8925.1572,7.8262024],
[5456.0376,8721.6582,0],
[4618.7578,11916.813,0],
[4228.1733,10764.493,0],
[4853.8369,9770.4697,0],
[3766.7463,9050.3887,0],
[6871.6016,9167.793,0],
[3422.6311,7962.4419,0],
[4885.1196,6968.4189,0],
[4408.0513,6561.417,0],
[2322.5613,6456.8984,0],
[6590.2856,7638.0596,0],
[7228.6685,7957.4414,0],
[8482.6855,6999.7275,0],
[8121.1787,9119.6113,0],
[4376.8423,7801.8071,0],
[3260.1011,4798.7295,0],
[1667.0132,2137.4954,0],
[2676.1685,2080.5552,0],
[3541.5867,2305.3208,0],
[2834.8782,3417.1665,0],
[4781.3203,2212.4167,0],
[4712.4463,2512.1064,0],
[4981.9536,2362.261,0],
[7179.7217,2637.1555,0],
[6292.5845,2858.1133,0],
[7295.5264,3438.1301,0],
[8284.8447,2882.7969,0],
[9757.4404,1913.0979,0],
[10258.862,2190.3423,0],
[10047.912,2426.1528,0],
[11825.01,3491.3479,0],
[13484.899,4042.1584,0],
[13629.885,2866.4932,0],
[13312.51,6524.9927,0],
[11539.966,5576.0742,0],
[11471.443,6707.582,0],
[6700.0488,5935.1724,0],
[7873.6177,5153.9512,0],
[11349.682,7592.9326,0],
[11119.914,8121.4434,0],
[10471.377,8449.6768,0],
[9546.748,8527.5625,0],
[11881.921,10033.177,0],
[9242.2539,11218.743,0],
[9237.958,4064.0278,0],
[8765.4844,6120.1685,0],
[9997.4512,6730.7456,0],
[9983.3184,7173.9434,0],
[12323.812,6905.1079,0],
[12483.35,8423.291,0],
[11432.563,9560.1191,0],
[2730.4912,11887.858,0],
[3210.8567,8751.46,0],
[5260.6831,7636.314,0],
[6243.1836,8435.3086,0],
[4655.3706,4455.2158,0],
[1088.7483,4188.8389,0],
[6994.6992,14189.774,0]
];

		if(_useStatic) then {
			_position = _staticcoords call BIS_fnc_selectRandom;
		} else {
			_position = [getMarkerPos _spawnMarker,0,_spawnRadius,10,0,2000,0] call BIS_fnc_findSafePos;
		};
		//DEFAULT: GET COORDS FROM BIS_fnc_findSafePos, COMMENT OUT IF YOU USE _STATICCOORDS

		diag_log(format["CRASHSPAWNER: %1 started flying from %2 to %3 NOW!(TIME:%4||LT:%5)", _crashName,  str(_heliStart), str(_position), round(time), _lootTable]);

		//Spawn the AI-Heli flying in the air
		_startTime = time;
		_crashwreck = createVehicle [_heliModel,_heliStart, [], 0, "FLY"];

		//Make sure its not destroyed by the Hacker-Killing-Cleanup (Thanks to Sarge for the hint)
		_crashwreck setVariable["Sarge",1];

		_crashwreck engineOn true;
		_crashwreck flyInHeight 120;
		_crashwreck forceSpeed 110;
		_crashwreck setspeedmode "LIMITED";

		//Create an Invisibile Landingpad at the Crashside-Coordinates
		_landingzone = createVehicle ["HeliHEmpty", [_position select 0, _position select 1,0], [], 0, "CAN_COLLIDE"];
		_landingzone setVariable["Sarge",1];

		//Only a Woman could crash a Heli this way...
		_aigroup = creategroup civilian;
		_helipilot = _aigroup createUnit ["SurvivorW2_DZ",getPos _crashwreck,[],0,"FORM"];
		_helipilot moveindriver _crashwreck;
		_helipilot assignAsDriver _crashwreck;

		sleep 0.5;

		if(_preWaypoints > 0) then {
			for "_x" from 1 to _preWaypoints do {
				if(_useStatic) then {
					_preWaypointPos = _staticcoords call BIS_fnc_selectRandom;
				} else {
					_preWaypointPos = [getMarkerPos _spawnMarker,0,_spawnRadius,10,0,2000,0] call BIS_fnc_findSafePos;
				};
				diag_log(format["CRASHSPAWNER: Adding Pre-POC-Waypoint #%1 on %2", _x,str(_preWaypointPos)]);
				_wp = _aigroup addWaypoint [_preWaypointPos, 0];
				_wp setWaypointType "MOVE";
				_wp setWaypointBehaviour "CARELESS";
			};
		};

		_wp2 = _aigroup addWaypoint [position _landingzone, 0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointBehaviour "CARELESS";

		//Even when the Heli flys to high, it will burn when reaching its Waypoint
		_wp2 setWaypointStatements ["true", "_crashwreck setdamage 1;"];

		//Adding a last Waypoint up in the North, so the Heli doesnt Hover at WP1 (OR2)
		//and would also come back to WP1 if somehow it doesnt explode.
		_wp3 = _aigroup addWaypoint [_safetyPoint, 0];
		_wp3 setWaypointType "CYCLE";
		_wp3 setWaypointBehaviour "CARELESS";

		//Get some more Speed when close to the Crashpoint and go on even if Heli died or hit the ground
		waituntil {(_crashwreck distance _position) <= 1000 || not alive _crashwreck || (getPosATL _crashwreck select 2) < 5 || (damage _crashwreck) >= _crashDamage};
			_crashwreck flyInHeight 95;
			_crashwreck forceSpeed 160;
			_crashwreck setspeedmode "NORMAL";

		//BOOOOOOM!
		waituntil {(_crashwreck distance _position) <= _exploRange || not alive _crashwreck || (getPosATL _crashwreck select 2) < 5 || (damage _crashwreck) >= _crashDamage};
			//Taking out the Tailrotor would be more realistic, but makes the POC not controllable
			//_crashwreck setHit ["mala vrtule", 1];
			_crashwreck setdamage 1;
			_crashwreck setfuel 0;
			diag_log(format["CRASHSPAWNER: %1 just exploded at %2!, ", _crashName, str(getPosATL _crashwreck)]);

			//She cant survive this :(
			_helipilot setdamage 1;

			//Giving the crashed Heli some time to find its "Parkingposition"
			sleep 13;

		//Get position of the helis wreck, but make sure its on the ground;
		_pos = [getpos _crashwreck select 0, getpos _crashwreck select 1,0];

		//saving the direction of the wreck(not used right now)
		_dir = getdir _crashwreck; 

		//Send Public Variable so every client can delete the craters around the new Wreck (musst be added in init.sqf)
		heliCrash = _pos;
		publicVariable "heliCrash";
		
		//Clean Up the Crashsite
		deletevehicle _crashwreck;
		deletevehicle _helipilot;
		deletevehicle _landingzone;

		//Animation is done, lets create the actual Crashside
		_crash = createVehicle [_crashModel, _pos, [], 0, "CAN_COLLIDE"];
		_crash setVariable["Sarge",1];

		//If you want all Grass around the crashsite to be cutted: Uncomment the next Line (Noobmode)
		//_crashcleaner = createVehicle ["ClutterCutter_EP1", _pos, [], 0, "CAN_COLLIDE"];

		//Setting the Direction would add realism, but it sucks because of the bugged model when not on plane ground.
		//If you want it anyways, just uncomment the next line
		//_crash setDir _dir;

		// I don't think this is needed (you can't get "in" a crash), but it was in the original DayZ Crash logic
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_crash];

		_crash setVariable ["ObjectID",1,true];

		//Make it burn (or not)
		if (_spawnFire) then {
			//["dayzFire",[_crash,2,time,false,_fadeFire]] call broadcastRpcCallAll;
			dayzFire = [_crash,2,time,false,_fadeFire];
			publicVariable "dayzFire";
			_crash setvariable ["fadeFire",_fadeFire,true];
		};

		_num        = round(random 4) + 4;
     
        _config = configFile >> "CfgBuildingLoot" >> _lootTable;
        _itemTypes = [["DMR_DZ", "weapon"],["Binocular_Vector", "weapon"],["bizon_silenced", "weapon"], ["FN_FAL","weapon"], ["M14_EP1","weapon"], ["FN_FAL_ANPVS4","weapon"], ["Mk_48_DZ","weapon"], ["M249_DZ","weapon"], ["", "military"], ["MedBox0", "object"], ["NVGoggles", "weapon"], ["AmmoBoxSmall_556", "object"], ["AmmoBoxSmall_762", "object"], ["Skin_Camo1_DZ", "magazine"], ["Skin_Sniper1_DZ", "magazine"], ["SVD_CAMO","weapon"], ["M24","weapon"], ["M4A1_AIM_SD_camo","weapon"], ["Sa58P_EP1","weapon"], ["Sa58V_CCO_EP1","weapon"], ["Sa58V_EP1","weapon"], ["Sa58V_RCO_EP1","weapon"]];
        _itemChance = [0.01, 0.05, 0.02, 0.01, 0.02, 0.05, 0.01, 0.03, 0.05, 0.01, 0.06, 0.03, 0.02, 0.01, 0.01, 0.05, 0.05, 0.04, 0.03, 0.05, 0.05, 0.05, 0.04, 0.05];
        _weights = [];
        _weights = [_itemType,_itemChance] call fnc_buildWeightedArray;
        _cntWeights = count _weights;
        _index = _weights call BIS_fnc_selectRandom;

		//Creating the Lootpiles outside of the _crashModel
				for "_x" from 1 to _num do {
			//Create loot
			_index = floor(random _cntWeights);
			_index = _weights select _index;
			_itemType = _itemTypes select _index;

			//Let the Loot spawn in a non-perfect circle around _crashModel
			_lootPos = [_pos, ((random 2) + (sizeOf(_crashModel) * _lootRadius)), random 360] call BIS_fnc_relPos;
			[_itemType select 0, _itemType select 1, _lootPos, 0] call spawn_loot;

			diag_log(format["CRASHSPAWNER: Loot spawn at '%1' with loot table '%2'", _lootPos, sizeOf(_crashModel)]); 

			// ReammoBox is preferred parent class here, as WeaponHolder wouldn't match MedBox0 and other such items.
			_nearby = _pos nearObjects ["ReammoBox", sizeOf(_crashModel)];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};

		//Adding 5 dead soldiers around the wreck, poor guys
		for "_x" from 1 to 5 do {
			_lootPos = [_pos, ((random 4)+3), random 360] call BIS_fnc_relPos;
			_deadBody = createVehicle[["Body1","Body2"] call BIS_fnc_selectRandom,_lootPos,[], 0, "CAN_COLLIDE"];
			_deadBody setDir (random 360);
		};
		_endTime = time - _startTime;
		diag_log(format["CRASHSPAWNER: Crash completed! Wreck at: %2 - Runtime: %1 Seconds || Distance from calculated POC: %3 meters", round(_endTime), str(getPos _crash), round(_position distance _crash)]); 
	};
};