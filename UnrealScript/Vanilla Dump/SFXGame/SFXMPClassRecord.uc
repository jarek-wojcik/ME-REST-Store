Class SFXMPClassRecord;

var array<SFXMPCharacterRecord> Characters;
var Name className;
var int Level;
var float XPOffset;
var int NumPromotions;

public function bool CanPromoteClass()
{
    return Level >= Class'BioLevelUpSystem'.static.GetMaxLevel();
}
public function float GetTotalXP()
{
    local float CurrentXP;
    local int XPNeededForCurrentLevel;
    
    if (Class'BioLevelUpSystem'.static.GetXPNeededForLevel(Level, XPNeededForCurrentLevel))
    {
        CurrentXP = float(XPNeededForCurrentLevel) + XPOffset;
        return CurrentXP;
    }
    return 0.0;
}
public function bool HasAnyDeployedCharacters()
{
    local int idx;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].Deployed)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool HaveKitsLeveledUp()
{
    local int idx;
    
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        if (Characters[idx].IsDeployed() && Characters[idx].HasLeveledUp())
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function LevelUpClass(float fXP, BioPlayerController Controller)
{
    local int XPForNextLevel;
    local int CurrentPlayerLevel;
    local int NewPlayerLevel;
    local int XPNeededForNewLevel;
    local int idx;
    local float CurrentXP;
    local float ActualGainedXP;
    local float MaxExperience;
    
    MaxExperience = float(SFXGRI(Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo().GRI).gameconfig.MaxPlayerExperience);
    ActualGainedXP = fXP;
    if (GetTotalXP() + fXP > MaxExperience)
    {
        ActualGainedXP = MaxExperience - GetTotalXP();
    }
    CurrentXP = GetTotalXP() + ActualGainedXP;
    CurrentPlayerLevel = Level;
    NewPlayerLevel = CurrentPlayerLevel;
    if (CurrentPlayerLevel >= 1 && Class'BioLevelUpSystem'.static.GetXPNeededForLevel(CurrentPlayerLevel + 1, XPForNextLevel))
    {
        while (CurrentXP >= float(XPForNextLevel))
        {
            NewPlayerLevel++;
            if (Class'BioLevelUpSystem'.static.GetXPNeededForLevel(NewPlayerLevel + 1, XPForNextLevel) == FALSE)
            {
                break;
            }
        }
    }
    if (NewPlayerLevel > CurrentPlayerLevel)
    {
        Level = NewPlayerLevel;
        for (idx = 0; idx < Characters.Length; ++idx)
        {
            Characters[idx].RecalculateTalentPoints();
            Characters[idx].SetLeveledUp(TRUE);
        }
        if (Class'Engine'.static.GetCurrentWorldInfo().Game != None)
        {
            Class'Engine'.static.GetCurrentWorldInfo().Game.WriteOnlineStats();
        }
        Class'SFXTelemetryHooks'.static.SendMPLevelUp(CurrentPlayerLevel, NewPlayerLevel);
        if (Controller != None && Level > 1)
        {
            Controller.SetAccomplishmentProgression('MPLEVELCOUNT', Level, TRUE);
        }
    }
    Class'BioLevelUpSystem'.static.GetXPNeededForLevel(NewPlayerLevel, XPNeededForNewLevel);
    XPOffset = CurrentXP - float(XPNeededForNewLevel);
}
public function bool PromoteClass()
{
    local WorldInfo WI;
    local BioPlayerController PC;
    local SFXGAWAssetsHandler GAWHandler;
    local array<TelemetryAttribute> Attributes;
    local string ClassString;
    
    if (!CanPromoteClass())
    {
        return FALSE;
    }
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return FALSE;
    }
    GAWHandler.IncrementMultiplayerAsset();
    WI = Class'Engine'.static.GetCurrentWorldInfo();
    if (WI != None)
    {
        PC = BioPlayerController(WI.GetALocalPlayerController());
        if (PC != None)
        {
            PC.UnlockAccomplishment('NEWGAME');
        }
    }
    ResetClass();
    NumPromotions++;
    ClassString = string(className);
    Class'SFXTelemetry'.static.AddAttributeToArray(Attributes, 2, "nump", , NumPromotions);
    Class'SFXTelemetry'.static.AddAttributeToArray(Attributes, 1, "clas", ClassString);
    Class'SFXTelemetry'.static.SendArray('TelemetryHook_MP_CharacterPrestiged', Attributes);
    return TRUE;
}
public function ResetClass()
{
    local int idx;
    
    XPOffset = 0.0;
    Level = 1;
    for (idx = 0; idx < Characters.Length; ++idx)
    {
        Characters[idx].ResetCharacter();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Level = 1
}