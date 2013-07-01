![DayZ Logo](http://dayzforum.net/public/style_images/dayz/logo.png)

Animated-Helicrash-script (Dayzforum.net / Grafzahl)
==========

Current Version:
==================================
<table>
  <tr>
    <td>Version</td><td>Mod Folders</td><td>Download</td>
  </tr>
  <tr>
    <td>Dayz 1.7.7.1 / 0.2</td><td>dayz_server</td><td>http://github.com/Finest/Animated-Helicrash-script</td>
  </tr>
</table>

Requirements:
------------

 - Microsoft Windows (Tested with 7, Server 2008)
 - ArmA 2 Combined Operations Dedicated Server (Steam users must merge ArmA2 and ArmA2 OA Directories)
 - Recommended ArmA 2 Operation Arrowhead Beta Patch (http://www.arma2.com/beta-patch.php)
 - Microsoft Visual C++ 2010 SP1 x86 Redistributable (http://www.microsoft.com/en-us/download/details.aspx?id=8328)
 
 
 
Features:
--------

    Instead of just silently spawning helicrashs somewhere over time, each helicrash gets a real AI-Controlled Heli which is flying and crashing at the (aprox) position of the calculated crashsite
    Helis starting south of Cherno or Electro over the Sea
        (Startingpoints can be added/changed)
    Random Spawning of flying Mi17_DZ or UH1H_DZ
        If Mi17_DZ is flying, its spawning an Mi8-Wreck at the Position of the Crash (doesnt trigger zombiespawn right now)
    If chopper is destroyed (damaged chopper or Pilot) on its way to the Point-of-Crash, the Crashsite is spawning where the Heli went down, even when its not even close to the POC
        Damage that the Heli can handle before its exploding can be edited => let heli explode and spawn crashsite, even after one hit with Lee-Enfield)
    Heli can get an unlimited amount of waypoints before he starts to his POC
    When the Heli gets near its POS, it explodes in the air and hits the ground near the POC, after some seconds a regular crashsite is spawning in the smoke and the "real" wreck together with the generated craters get deleted, otherwise the craters would block loot-access
    The loot is spawning in a slightly wider area around the crashside, it shouldnt be possible that loot spawns under the crashsite.
    Together with the loot, some dead soldier-bodys apear at random places around the wreck so the scene looks a bit more realistic.
    It doesnt touch the amount or quality of the loot... the loot that is spawning in is exactly the same as before, but it could be a little bit harder to find, due to the changed radius ;)

Install-Guide:
--------

    1. Step
        Download this file and exchange/merge (no merge-support from me) it with your compile/server_spawnCrashSite.sqf inside your dayz_server.pbo!
        The file is commented, so you shouldnt have problems editing stuff (startpoints,backup-point) for other maps (all coordinates are optimized for chernarus).
    
	2. Step (Can be skipped if already using Sarges AI-Framework)
        You need to edit your system/server_cleanup.fsm inside your dayz_server.pbo, open it and search for:
        Code:

        //Check for hackers

        2 Lines under it is a line starting with if(vehicle _x != ... exchange the complete line with:
        Code:

              "  if(vehicle _x != _x && !(vehicle _x in _safety) && (typeOf vehicle _x) != ""ParachuteWest"" && (vehicle _x getVariable [""Sarge"",0] != 1)) then {" \n

        If you dont do this, all AI-Choppers will insta killed over theire startpoint after they spawned in
    
	3. Step (Optional)
        In this step you have to edit your init.sqf inside your mission.pbo. Open it and search for a line starting with
        Code:

        playerMonitor =  

        under this line paste this code-block:
        Code:

            "heliCrash" addPublicVariableEventHandler {
                _list = nearestObjects [_this select 1, ["CraterLong"], 100];
                {deleteVehicle _x;} foreach _list;
            };

        This way every connected client deletes the crater at the crash right after they spawned, if you want to keep the craters (could block loot-access), you can skip this step.
    
	4. Step
        Ready! Pack you mission.pbo and dayz_server.pbo and overwrite them, restart your server and wait for the choppers ;) Choppers spawn in the same times like your "normal" crashsites.

		
Customizations:
--------

After you completed the 4 Steps, you would be ready to go (at least on a Standard DayZ 1.7.6.1 Hive). But i have included some options to customize the script for your needs. But first the default behaviour for the Choppers:

    Heli is only exploding/generating crashsite before its POC when to close to the ground (< 5m), so you have to take out the engine, pilot or something to bring the heli down -> explosion -> crashsite
    Heli gets 1 random waypoint before he flys to his POC
    Script uses the build-in arma2-function BIS_fnc_findSafePos to generate POCs and Pre-Waypoints (same spots as in normal dayz)
    Heli Startpoints and the Backup-Point are optimized for use on Chernarus, you have to change this for other maps (watch the Code)

If you want to change anything of the above you have to open your system/server_monitor.sqf inside your dayz_server.pbolook at the end of the file where the Crash-Spawner is activated... something like this:

Code:

// [_guaranteedLoot, _randomizedLoot, _frequency, _variance, _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire]
nul = [3, 4, (50 * 60), (15 * 60), 0.75, 'center', 4000, true, false] spawn server_spawnCrashSite;

and replace it with:

Code:

// [_guaranteedLoot, _randomizedLoot, _frequency, _variance, _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire, _useStatic, _preWaypoint, _crashDamage]
nul =    [
                3,        //Number of the guaranteed Loot-Piles at the Crashside
                4,        //Number of the random Loot-Piles at the Crashside 3+(1,2,3 or 4)
                3000,     //Fixed-Time (in seconds) between each start of a new Chopper
                500,      //Random time (in seconds) added between each start of a new Chopper
                1,        //Spawnchance of the Heli (1 will spawn all possible Choppers, 0.5 only 50% of them)
                'center', //Center-Marker for the Random-Crashpoints, for Chernarus this is a point near Stary
                4000,     //Radius in Meters from the Center-Marker in which the Choppers can crash and get waypoints
                true,     //Should the spawned crashsite burn (at night) & have smoke?
                false,    //Should the flames & smoke fade after a while?
                false,    //Use the Static-Crashpoint-Function? If true, you have to add Coordinates into server_spawnCrashSite.sqf
                1,        //Amount of Random-Waypoints the Heli gets before he flys to his Point-Of-Crash (using Static-Crashpoint-Coordinates if its enabled)
                1         //Amount of Damage the Heli has to get while in-air to explode before the POC. (0.0001 = Insta-Explode when any damage//bullethit, 1 = Only Explode when completly damaged)
            ] spawn server_spawnCrashSite;
RPT Logs:
--------

12:11:36 "CRASHSPAWNER: Starting spawn logic for animated helicrashs - written by Grafzahl [SC:false||PW:1||CD:1]"
12:11:36 "CRASHSPAWNER: 75% chance to start a crashing UH-1H with loot table 'Military' at 60"
12:13:32 "CRASHSPAWNER: UH-1H started flying from [6993.7,173.053,300] to [6277.56,8332.83] NOW!(TIME:60||LT:Military)"
12:13:33 "CRASHSPAWNER: Adding Pre-POC-Waypoint #1 on [1234.56,4321.83]"
12:18:26 "CRASHSPAWNER: UH-1H just exploded at [6160.78,8215.13,94.7439]!"
12:18:39 "CRASHSPAWNER: Loot spawn at '[6284.31,8333.3,0]' with loot table '15.3165'"
12:18:39 "CRASHSPAWNER: Loot spawn at '[6289.58,8343.87,0]' with loot table '15.3165'"
12:18:39 "CRASHSPAWNER: Loot spawn at '[6284.43,8334.29,0]' with loot table '15.3165'"
12:18:39 "CRASHSPAWNER: Crash complete! Wreck at: [6283.44,8339.96,0.209167] - Runtime: 307 Seconds||  Distance from POC: 44 meters, "

Branches:
--------

- **Devlopment** - May not be stable. (https://github.com/Finest/Animated-Helicrash-script)

Directories:
-----------

 - **SQF-Server** - Source Code for Serverside Ovaron Changes (Based on Reality)
 - **Documentation** - Changelog & Credits and Suggestions

Bugs/Issues:
-----------

- Please report any bugs/issues by submitting a Issue [here] (https://github.com/Finest/Animated-Helicrash-script/issues).
