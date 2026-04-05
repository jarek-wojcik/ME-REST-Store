Class BioLevelUpSystem
    native
    config(Game);

struct native LevelReward 
{
    var int Level;
    var int ExperienceRequired;
    var int TalentReward;
    var int HenchmanTalentReward;
};

var config float ME2ImportReputationAmount;

public static function bool AttemptLevelUp(BioBaseSquad Squad)
{
    local int NewPlayerLevel;
    local int PlayerLevel;
    local int XPForNextLevel;
    local int idx;
    local float CurrentXP;
    local SFXPawn_Player Pawn;
    local SFXPawn_PlayerParty member;
    local SFXGRI GRI;
    local BioPlayerController PC;
    
    if (!Squad.bIsPlayerSquad)
    {
        return FALSE;
    }
    for (idx = 0; idx < Squad.Members.Length; idx++)
    {
        Pawn = SFXPawn_Player(Squad.Members[idx]);
        if (Pawn != None && Pawn.IsHumanControlled())
        {
            CurrentXP = Pawn.TotalXP;
            PlayerLevel = Pawn.CharacterLevel;
            break;
        }
    }
    GRI = SFXGRI(Pawn.WorldInfo.GRI);
    NewPlayerLevel = PlayerLevel;
    if (PlayerLevel >= 1 && GetXPNeededForLevel(PlayerLevel + 1, XPForNextLevel))
    {
        while (CurrentXP >= float(XPForNextLevel))
        {
            ++NewPlayerLevel;
            if (GetXPNeededForLevel(NewPlayerLevel + 1, XPForNextLevel) == FALSE)
            {
                break;
            }
        }
        for (idx = 0; idx < Squad.Members.Length; idx++)
        {
            member = SFXPawn_PlayerParty(Squad.Members[idx]);
            if (member != None && LevelUpBioPawn(member, NewPlayerLevel))
            {
                member.CharacterLevel = NewPlayerLevel;
            }
        }
        PC = BioPlayerController(Pawn.Controller);
        if (PC != None && NewPlayerLevel > 1)
        {
            PC.SetAccomplishmentProgression('LEVELCOUNT', NewPlayerLevel);
        }
        if (GRI != None)
        {
            GRI.DifficultyHandler.bNeedsUpdate = TRUE;
            GRI.DifficultyHandler.Update();
        }
        if (NewPlayerLevel > PlayerLevel)
        {
            Class'SFXTelemetry'.static.SendInt('TelemetryHook_LevelUp', NewPlayerLevel);
        }
        return NewPlayerLevel > PlayerLevel;
    }
    return FALSE;
}
public static function AutoLevelUpPowers(BioPawn Pawn)
{
    local SFXPowerLevelUpHelper Helper;
    
    if (Pawn == None)
    {
        return;
    }
    Helper = new (Pawn) Class'SFXPowerLevelUpHelper';
    if (Helper == None)
    {
        return;
    }
    Helper.Initialize(BioWorldInfo(Pawn.WorldInfo));
    Helper.SetPawn(Pawn);
    Helper.AutoLevelUp();
}
public static function bool GetLevelFromXP(int experience, out int Level)
{
    local int nLevel;
    local array<LevelReward> RewardTable;
    
    nLevel = 0;
    RewardTable = SFXGRI(Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo().GRI).gameconfig.LevelRewards;
    if (experience >= 0)
    {
        for (; nLevel < RewardTable.Length && experience >= RewardTable[nLevel].ExperienceRequired; nLevel++)
        {
        }
        Level = nLevel;
        return TRUE;
    }
    return FALSE;
}
public static function int GetMaxLevel()
{
    return SFXGRI(Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo().GRI).gameconfig.LevelRewards.Length;
}
public static function int GetTalentPointSum(int Level, bool bHenchman)
{
    local int Index;
    local int total;
    local array<LevelReward> RewardTable;
    
    RewardTable = SFXGRI(Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo().GRI).gameconfig.LevelRewards;
    for (Index = 0; Index < RewardTable.Length; Index++)
    {
        if (Index >= Level)
        {
            break;
        }
        if (bHenchman)
        {
            total += RewardTable[Index].HenchmanTalentReward;
            continue;
        }
        total += RewardTable[Index].TalentReward;
    }
    return total;
}
public static function bool GetXPNeededForLevel(int Level, out int experience)
{
    local array<LevelReward> RewardTable;
    
    RewardTable = SFXGRI(Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo().GRI).gameconfig.LevelRewards;
    if (Level > 0 && Level <= RewardTable.Length)
    {
        experience = RewardTable[Level - 1].ExperienceRequired;
        return TRUE;
    }
    return FALSE;
}
public static function bool LevelUpBioPawn(SFXPawn_PlayerParty Pawn, int newLevel)
{
    local int oldLevel;
    local bool bPerformStaticLevelUp;
    local bool wasSuccessful;
    local int oldAccumulated;
    local int newAccumulated;
    local bool bPlayer;
    local int AutoLevel;
    local BioPawn leader;
    local BioPlayerController PC;
    
    if (Pawn == None)
    {
        return FALSE;
    }
    oldLevel = Pawn.CharacterLevel;
    if (oldLevel < 0 || newLevel < 0)
    {
        return FALSE;
    }
    bPerformStaticLevelUp = newLevel > oldLevel;
    wasSuccessful = TRUE;
    if (bPerformStaticLevelUp)
    {
        bPlayer = SFXPawn_Player(Pawn) != None;
        oldAccumulated = GetTalentPointSum(oldLevel, !bPlayer);
        newAccumulated = GetTalentPointSum(newLevel, !bPlayer);
        if (newAccumulated <= oldAccumulated)
        {
            wasSuccessful = FALSE;
        }
        Pawn.AddTalentPoints(newAccumulated - oldAccumulated);
        Pawn.CharacterLevel = newLevel;
    }
    AutoLevel = 0;
    if (Pawn.Squad != None)
    {
        leader = BioPawn(Pawn.Squad.Members[0]);
        if (leader != None)
        {
            PC = BioPlayerController(leader.Controller);
            if (PC != None && PC.ProfileSettings != None)
            {
                PC.ProfileSettings.GetProfileSettingValueId(34, AutoLevel);
            }
        }
    }
    if (AutoLevel == 2 || AutoLevel == 1 && SFXPawn_Player(Pawn) == None)
    {
        AutoLevelUpPowers(Pawn);
    }
    if (bPerformStaticLevelUp && newLevel != 1)
    {
        PC.SetRichPresence();
    }
    return wasSuccessful;
}
public static final function ME2ToME3_ParagonRenegade(int Paragon_ME2, int Renegade_ME2, out int Paragon_ME3, out int Renegade_ME3)
{
    local float fParagon;
    local float fRenegade;
    local float fME2Total;
    
    fME2Total = float(Paragon_ME2 + Renegade_ME2);
    fParagon = float(Paragon_ME2) / fME2Total;
    fRenegade = float(Renegade_ME2) / fME2Total;
    Paragon_ME3 = int(fParagon * default.ME2ImportReputationAmount * float(Class'SFXPawn_Player'.default.MaxTotalReputation));
    Renegade_ME3 = int(fRenegade * default.ME2ImportReputationAmount * float(Class'SFXPawn_Player'.default.MaxTotalReputation));
}
public static final function SetME2ImportStartingValues(out PlayerSaveRecord PlayerRecord)
{
    local int StartingXP;
    local SFXGame Game;
    local int ParagonPoints;
    local int RenegadePoints;
    
    if (PlayerRecord.Level < 0)
    {
        return;
    }
    GetXPNeededForLevel(PlayerRecord.Level, StartingXP);
    PlayerRecord.CurrentXP = float(StartingXP);
    Game = SFXGame(Class'Engine'.static.GetCurrentWorldInfo().Game);
    if (Game != None)
    {
        ME2ToME3_ParagonRenegade(Game.GetME2ParagonPoints(), Game.GetME2RenegadePoints(), ParagonPoints, RenegadePoints);
        Game.SetParagonPoints(ParagonPoints);
        Game.SetRenegadePoints(RenegadePoints);
    }
}
public static final function VerifyPlayerTalentPoints(SFXPawn Pawn)
{
    local int TalentPoints;
    local int SpentPoints;
    local SFXPawn_Player PlayerPawn;
    local SFXPowerCustomActionBase Power;
    
    PlayerPawn = SFXPawn_Player(Pawn);
    if (PlayerPawn == None || PlayerPawn.PowerManager == None)
    {
        return;
    }
    TalentPoints = GetTalentPointSum(SFXPawn_Player(Pawn).CharacterLevel, FALSE);
    foreach PlayerPawn.PowerManager.Powers(Power, )
    {
        if (Power.DisplayInCharacterRecord)
        {
            SpentPoints += Class'SFXPowerManager'.static.GetRefundAmount(Class'SFXPowerCustomAction', int(Power.Rank));
        }
    }
    if (SpentPoints > TalentPoints)
    {
        foreach PlayerPawn.PowerManager.Powers(Power, )
        {
            if (Power.DisplayInCharacterRecord)
            {
                Power.ResetPower();
            }
        }
    }
    else
    {
        TalentPoints -= SpentPoints;
    }
    if (Pawn.TalentPoints < TalentPoints)
    {
        Pawn.TalentPoints = TalentPoints;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ME2ImportReputationAmount = 0.150000006
}