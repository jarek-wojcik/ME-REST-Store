Class SFXMatchResultsData;

struct MatchData 
{
    var int MapId;
    var int ZoneRatingIncrease;
    var int EnemyID;
    var int DifficultyID;
    var int Waves;
    var int TotalMatchTime;
    var int OverallRatingIncrease;
    var bool bResult;
    var EGAWZone ZoneID;
};
struct PlayerRewardData 
{
    var float fOriginalExperience;
    var float fNewExperience;
};
struct PlayerScoreData 
{
    var UniqueNetId UniqueId;
    var string PlayerName;
    var array<int> PlayerMedalIDs;
    var Name KitName;
    var int PlayerID;
    var float fScore;
    var int ClassLevel;
    var int nTotalXP;
};

var array<PlayerScoreData> PlayerData;
var array<int> SquadMedalIDs;
var array<int> ExtractedPlayerIDs;
var MatchData CurrentMatchData;
var PlayerRewardData PlayerRewards;
var int TotalSquadCredits;
var int TotalSquadXP;
var int BonusSquadXP;

public function AddPlayerMedal(int PlayerID, int MedalID)
{
    local int nIndex;
    
    nIndex = FindPlayer(PlayerID);
    PlayerData[nIndex].PlayerMedalIDs.AddItem(MedalID);
}
public function AddSquadMedal(int MedalID)
{
    SquadMedalIDs.AddItem(MedalID);
}
public function CleanupInactiveData(out array<int> ActiveIDs)
{
    local int idx;
    local int FoundIdx;
    local array<PlayerScoreData> ActiveData;
    
    for (idx = 0; idx < ActiveIDs.Length; ++idx)
    {
        FoundIdx = PlayerData.Find('PlayerID', ActiveIDs[idx]);
        if (FoundIdx >= 0)
        {
            ActiveData.AddItem(PlayerData[FoundIdx]);
        }
    }
    PlayerData = ActiveData;
}
public function ClearGAWValues()
{
    CurrentMatchData.ZoneRatingIncrease = 0;
    CurrentMatchData.OverallRatingIncrease = 0;
}
private final function int FindPlayer(int PlayerID)
{
    local int nIndex;
    
    nIndex = PlayerData.Find('PlayerID', PlayerID);
    if (nIndex < 0)
    {
        nIndex = PlayerData.Add(1);
        PlayerData[nIndex].PlayerID = PlayerID;
    }
    return nIndex;
}
public function ResetData()
{
    PlayerData.Length = 0;
    PlayerRewards.fOriginalExperience = -1.0;
    PlayerRewards.fNewExperience = 0.0;
    SquadMedalIDs.Length = 0;
    TotalSquadCredits = 0;
    TotalSquadXP = 0;
    BonusSquadXP = 0;
    CurrentMatchData.bResult = FALSE;
    CurrentMatchData.DifficultyID = 0;
    CurrentMatchData.EnemyID = -1;
    CurrentMatchData.MapId = 0;
    CurrentMatchData.TotalMatchTime = 0;
    CurrentMatchData.Waves = 0;
    CurrentMatchData.OverallRatingIncrease = 0;
    CurrentMatchData.ZoneID = EGAWZone.EGAWZone_InnerCouncil;
    CurrentMatchData.ZoneRatingIncrease = 0;
    ExtractedPlayerIDs.Length = 0;
}
public function SetBonusSquadXP(int nBonusXP)
{
    BonusSquadXP = nBonusXP;
}
public function SetMatchResult(bool bResult)
{
    CurrentMatchData.bResult = bResult;
}
public function SetMatchSettings(int MapId, EGAWZone ZoneID, int GAWZoneIncrease, int GAWOverallIncrease, int EnemyID, int DifficultyID)
{
    CurrentMatchData.MapId = MapId;
    CurrentMatchData.EnemyID = EnemyID;
    CurrentMatchData.DifficultyID = DifficultyID;
    CurrentMatchData.ZoneID = ZoneID;
    CurrentMatchData.ZoneRatingIncrease = GAWZoneIncrease;
    CurrentMatchData.OverallRatingIncrease = GAWOverallIncrease;
}
public function SetMatchTime(int nTotalMatchTime)
{
    CurrentMatchData.TotalMatchTime = nTotalMatchTime;
}
public function SetMatchWaves(int nWaves)
{
    CurrentMatchData.Waves = nWaves;
}
public function SetPlayerKit(int PlayerID, Name KitName)
{
    local int nIndex;
    
    nIndex = FindPlayer(PlayerID);
    PlayerData[nIndex].KitName = KitName;
}
public function SetPlayerLevel(int PlayerID, int nLevel)
{
    local int nIndex;
    
    nIndex = FindPlayer(PlayerID);
    PlayerData[nIndex].ClassLevel = nLevel;
}
public function SetPlayerRewardNewExperience(float fXP)
{
    PlayerRewards.fNewExperience = fXP;
}
public function SetPlayerRewardOriginalExperience(float fXP)
{
    PlayerRewards.fOriginalExperience = fXP;
}
public function SetPlayerUniqueID(int PlayerID, UniqueNetId UniqueId)
{
    local int nIndex;
    
    nIndex = FindPlayer(PlayerID);
    PlayerData[nIndex].UniqueId = UniqueId;
}
public function SetTotalSquadCredits(int nCredits)
{
    TotalSquadCredits = nCredits;
}
public function SetTotalSquadXP(int nTotalXP)
{
    TotalSquadXP = nTotalXP;
}
public function UpdatePlayerScoreData(int PlayerID, string PlayerName, float fScore)
{
    local int nIndex;
    
    nIndex = FindPlayer(PlayerID);
    PlayerData[nIndex].PlayerName = PlayerName;
    PlayerData[nIndex].fScore = fScore;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}