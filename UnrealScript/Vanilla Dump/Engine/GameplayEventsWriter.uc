Class GameplayEventsWriter extends GameplayEvents
    native;

const GAMEEVENT_MAX_EVENTID = 0x0000FFFF;
const GAMEEVENT_GAME_SPECIFIC = 1000;
const GAMEEVENT_PLAYER_KILL_NORMAL = 200;
const GAMEEVENT_WEAPON_FIRED = 152;
const GAMEEVENT_WEAPON_DAMAGE_MELEE = 151;
const GAMEEVENT_WEAPON_DAMAGE = 150;
const GAMEEVENT_PLAYER_KILL_STREAK = 107;
const GAMEEVENT_PLAYER_TEAMCHANGE = 106;
const GAMEEVENT_PLAYER_LOCATION_POLL = 105;
const GAMEEVENT_PLAYER_KILL = 104;
const GAMEEVENT_PLAYER_MATCH_WON = 103;
const GAMEEVENT_PLAYER_SPAWN = 102;
const GAMEEVENT_PLAYER_LOGOUT = 101;
const GAMEEVENT_PLAYER_LOGIN = 100;
const GAMEEVENT_TEAM_GAME_SCORE = 51;
const GAMEEVENT_TEAM_CREATED = 50;
const GAMEEVENT_PING_POLL = 39;
const GAMEEVENT_NETWORKUSAGEOUT_POLL = 38;
const GAMEEVENT_NETWORKUSAGEIN_POLL = 37;
const GAMEEVENT_FRAMERATE_POLL = 36;
const GAMEEVENT_MEMORYUSAGE_POLL = 35;
const GAMEEVENT_GAME_SCORE = 9;
const GAMEEVENT_GAME_MAPNAME = 8;
const GAMEEVENT_GAME_OPTION_URL = 7;
const GAMEEVENT_GAME_CLASS = 6;
const GAMEEVENT_ROUND_WON = 5;
const GAMEEVENT_MATCH_WON = 4;
const GAMEEVENT_ROUND_ENDED = 3;
const GAMEEVENT_ROUND_STARTED = 2;
const GAMEEVENT_MATCH_ENDED = 1;
const GAMEEVENT_MATCH_STARTED = 0;

var const GameInfo Game;

public native function EndLogging();

public native function LogAllPlayerPositionsEvent(int EventId);

public native function LogDamageEvent(int EventId, Controller Player, Class<DamageType> dmgType, Controller Target, int Amount);

public native function LogGameIntEvent(int EventId, int Value);

public native function LogGameStringEvent(int EventId, string Value);

public native function LogPlayerFloatEvent(int EventId, Controller Player, float Value);

public native function LogPlayerIntEvent(int EventId, Controller Player, int Value);

public native function LogPlayerKillDeath(int EventId, int KillType, Controller Killer, Class<DamageType> dmgType, Controller Dead);

public native function LogPlayerLoginChange(int EventId, Controller Player, string PlayerName, UniqueNetId PlayerID, bool bSplitScreen);

public native function LogPlayerPlayerEvent(int EventId, Controller Player, Controller Target);

public native function LogPlayerSpawnEvent(int EventId, Controller Player, Class<Pawn> PawnClass, int TeamID);

public native function LogPlayerStringEvent(int EventId, Controller Player, string EventString);

public native function LogProjectileIntEvent(int EventId, Controller Player, Class<Projectile> Proj, int Value);

public native function LogSystemPollEvents();

public native function LogTeamIntEvent(int EventId, TeamInfo Team, int Value);

public native function LogWeaponIntEvent(int EventId, Controller Player, Class<Weapon> WeaponClass, int Value);

protected native function bool SerializeFooter();

protected native function bool SerializeHeader();

public native function StartLogging(optional float HeartbeatDelta);

public native function CloseStatsFile();

public native function bool OpenStatsFile(string Filename);

public function bool IsSessionInProgress()
{
    return CurrentSessionInfo.bGameplaySessionInProgress;
}
public function Poll()
{
    if (Game != None && !Game.bWaitingToStartMatch)
    {
        LogAllPlayerPositionsEvent(105);
    }
    LogSystemPollEvents();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}