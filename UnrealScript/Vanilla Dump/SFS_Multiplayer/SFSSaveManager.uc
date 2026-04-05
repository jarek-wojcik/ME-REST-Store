Class SFSSaveManager extends SFSManager within SFXPawn;

var delegate<OnRefreshMPDataDelegate> LoadDelegate;
var SFXSaveManagerMP SM;
var SFXPRIMP PRIMP;

public event simulated function HandlePostAdd()
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    SM = Engine.MPSaveManager;
    PRIMP = SFXPRIMP(Outer.Controller.PlayerReplicationInfo);
    if (SM == None)
    {
        Engine.InitializeMPSaves();
        SM = Engine.MPSaveManager;
        if (SM == None)
        {
            log(Self.Name, "no save manager post initialization", Outer);
        }
        else if (!SM.bInitialized)
        {
            SM.RefreshMPDataFromServer(OnRefreshMPDataDelegate);
        }
        else
        {
            OnRefreshMPDataDelegate(0);
        }
    }
    else
    {
        OnRefreshMPDataDelegate(0);
    }
}
public function OnRefreshMPDataDelegate(int nResult)
{
    local SFXEngine Engine;
    local array<SFXMPCharacterRecord> Saves;
    local SFXMPCharacterRecord Save;
    local Class<SFXCharacterClass> PlayerClass;
    local PowerRecord Power;
    local WeaponRecord Weapon;
    local float hoursPlayed;
    
    if (!bDebug)
    {
        return;
    }
    // Example: log level of the currently selected character
    Saves = SM.GetAllCharacterRecords();
    if (Saves.Length > 0)
    {
        foreach Saves(Save, )
        {
            PlayerClass = getKitClass(Save);
            log(Self.Name, Save.KitName $ " , " $ getFullPowerPath(PlayerClass, 0) $ " , " $ getFullPowerPath(PlayerClass, 1) $ " , " $ getFullPowerPath(PlayerClass, 2) $ " , " $ getFullPowerPath(PlayerClass, 3) $ " , " $ getFullPowerPath(PlayerClass, 4), Outer);
        }
    }
}
public function string getFullPowerPath(Class<SFXCharacterClass> PlayerClass, int Index)
{
    return PlayerClass.default.SquadScreenPowerOrder[Index].GetPackageName() $ "." $ PlayerClass.default.SquadScreenPowerOrder[Index];
}
public function bool GetMPCharacterRecord(Name KitName, out SFXMPCharacterRecord OutRecord)
{
    OutRecord = SM.GetCharacterRecord(KitName);
    return OutRecord != None;
}
public function Class<SFXCharacterClass> getKitClass(SFXMPCharacterRecord Character)
{
    local Class<SFXCharacterClass> CharacterClass;
    local string KitArchetype;
    local SFXPawn_Player PawnArchetype;
    
    // Taken from DeployCharacter in SFXSaveManagerMP
    KitArchetype = SM.GetKitArchetypeReference(Character.KitName);
    if (KitArchetype == "")
    {
        return None;
    }
    PawnArchetype = SFXPawn_Player(Class'SFXEngine'.static.GetSeekFreeObject(KitArchetype, Class'SFXPawn_Player'));
    if (PawnArchetype == None)
    {
        return None;
    }
    //Taken from InitializeFromCharacterClass
    CharacterClass = Class<SFXCharacterClass>(FindObject(PawnArchetype.PlayerClassName, Class'Class'));
    return CharacterClass;
}
public final function bool getPowerRecordForClass(SFXMPCharacterRecord CharacterRecord, Name PowerClassName, out PowerRecord retrievedPowerRecord)
{
    local bool Result;
    local string powerClassNameStr;
    local string recordPowerClassNameStr;
    
    powerClassNameStr = Locs(string(PowerClassName));
    log(Self.Name, "getPowerRecordForClass for: " $ powerClassNameStr $ " :--------", Outer);
    foreach CharacterRecord.Powers(retrievedPowerRecord, )
    {
        if (InStr(string(retrievedPowerRecord.PowerName), "Consumable", , , ) != -1)
        {
            continue;
        }
        recordPowerClassNameStr = Locs(string(retrievedPowerRecord.PowerClassName));
        log(Self.Name, " ----------: " $ retrievedPowerRecord.PowerClassName $ " :--------", Outer);
        log(Self.Name, " * Rank: " $ retrievedPowerRecord.CurrentRank, Outer);
        log(Self.Name, " * Choice 0 " $ retrievedPowerRecord.EvolvedChoices[0], Outer);
        log(Self.Name, " * Choice 1 " $ retrievedPowerRecord.EvolvedChoices[1], Outer);
        log(Self.Name, " * Choice 2 " $ retrievedPowerRecord.EvolvedChoices[2], Outer);
        log(Self.Name, " * Choice 3 " $ retrievedPowerRecord.EvolvedChoices[3], Outer);
        log(Self.Name, " * Choice 4 " $ retrievedPowerRecord.EvolvedChoices[4], Outer);
        log(Self.Name, " * Choice 5 " $ retrievedPowerRecord.EvolvedChoices[5], Outer);
        if (InStr(recordPowerClassNameStr, powerClassNameStr, , , ) != -1)
        {
            return TRUE;
        }
    }
    return Result;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bDebug = FALSE
}