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
function HandleEvent(SFSEvent E)
{
    switch (E.eType)
    {
        case SFSEventType.EVT_TRansferPowers:
            log(Self.Name, "TransferPowers", Outer);
            TransferPowers(E.nValue, E.powersToTransfer);
            break;
        default:
    }
}
public function OnRefreshMPDataDelegate(int nResult)
{
    local SFXEngine Engine;
    local array<SFXMPCharacterRecord> Saves;
    local SFXMPCharacterRecord Save;
    local PowerRecord Power;
    local WeaponRecord Weapon;
    local float hoursPlayed;
    
    // Example: log level of the currently selected character
    Saves = SM.GetAllCharacterRecords();
    if (Saves.Length > 0)
    {
        foreach Saves(Save, )
        {
            log(Self.Name, "------------------ " $ Save.CharacterName $ " ------------------", Outer);
            log(Self.Name, "------------------ " $ Save.KitName $ " ------------------", Outer);
            log(Self.Name, "----------- Seconds Played " $ Save.SecondsPlayed $ " ------------------", Outer);
            log(Self.Name, "------------------  Powers ------------------ ", Outer);
            foreach Save.Powers(Power, )
            {
                if (InStr(string(Power.PowerName), "Consumable", , , ) != -1)
                {
                    continue;
                }
                log(Self.Name, " ----------: " $ Power.PowerClassName $ " :--------", Outer);
                log(Self.Name, " * Rank: " $ Power.CurrentRank, Outer);
                log(Self.Name, " * Choice 0 " $ Power.EvolvedChoices[0], Outer);
                log(Self.Name, " * Choice 1 " $ Power.EvolvedChoices[1], Outer);
                log(Self.Name, " * Choice 2 " $ Power.EvolvedChoices[2], Outer);
                log(Self.Name, " * Choice 3 " $ Power.EvolvedChoices[3], Outer);
                log(Self.Name, " * Choice 4 " $ Power.EvolvedChoices[4], Outer);
                log(Self.Name, " * Choice 5 " $ Power.EvolvedChoices[5], Outer);
            }
            log(Self.Name, "------------------  Weapons ------------------ ", Outer);
            foreach Save.Weapons(Weapon, )
            {
                log(Self.Name, "Weapon : " $ Weapon.WeaponClassName, Outer);
            }
        }
    }
}
public function TransferPowers(Name KitName, int Powers[3])
{
    local SFXMPCharacterRecord sourceRecord;
    local SFXPawn_PlayerMP DummyPawn;
    local Actor PawnArchetype;
    local string KitArchetype;
    local Vector SpawnLocation;
    local Rotator SpawnRotation;
    local int idx;
    local int PowerIdx;
    local SFXPowerManager SourcePowerMan;
    local SFXPowerManager TargetPowerMan;
    local SFXPawn_PlayerMP TargetPawn;
    local int TargetPowerIdx;
    local int SourcePowerIdx;
    
    TargetPawn = SFXPawn_PlayerMP(Outer);
    if (TargetPawn == None || TargetPawn.PowerManager == None)
    {
        log(Self.Name, "TransferPowers: Invalid target pawn or PowerManager", Outer);
        return;
    }
    // Get the source character record
    if (!GetMPCharacterRecord(KitName, sourceRecord))
    {
        log(Self.Name, "TransferPowers: Could not find character record for " $ KitName, Outer);
        return;
    }
    // Get the kit archetype path
    KitArchetype = SM.GetKitArchetypeReference(KitName);
    if (KitArchetype == "")
    {
        log(Self.Name, "TransferPowers: Could not find kit archetype for " $ KitName, Outer);
        return;
    }
    // Load the pawn archetype
    PawnArchetype = SFXPawn_PlayerMP(Class'SFXEngine'.static.GetSeekFreeObject(KitArchetype, Class'SFXPawn_PlayerMP'));
    if (PawnArchetype == None)
    {
        log(Self.Name, "TransferPowers: Could not load pawn archetype " $ KitArchetype, Outer);
        return;
    }
    // Spawn the dummy pawn at a safe location
    SpawnLocation.X = 0.0;
    SpawnLocation.Y = 0.0;
    SpawnLocation.Z = 0.0;
    SpawnRotation = TargetPawn.Rotation;
    DummyPawn = TargetPawn.Spawn(Class<SFXPawn_PlayerMP>(PawnArchetype.Class), , , SpawnLocation, SpawnRotation, PawnArchetype);
    if (DummyPawn == None)
    {
        log(Self.Name, "TransferPowers: Failed to spawn dummy pawn", Outer);
        return;
    }
    // Set up the dummy pawn (minimal setup for powers only)
    DummyPawn.RemoteRole = ENetRole.ROLE_None;
    DummyPawn.SetPhysics(0);
    // Transfer character data and powers to dummy pawn
    sourceRecord.TransferCharacterDataToPawn(DummyPawn);
    sourceRecord.TransferPowersToPawn(DummyPawn);
    // Get power managers
    SourcePowerMan = DummyPawn.PowerManager;
    TargetPowerMan = TargetPawn.PowerManager;
    if (SourcePowerMan == None || SourcePowerMan.Powers.Length < 3)
    {
        log(Self.Name, "TransferPowers: Source PowerManager invalid or insufficient powers", Outer);
        DummyPawn.Destroy();
        return;
    }
    // Transfer the first 3 powers based on the Powers array using MappedPowers
    for (idx = 0; idx < 3; ++idx)
    {
        if (Powers[idx] == 1)
        {
            TargetPowerIdx = GetPowerIndexFromMappedSlot(TargetPawn.PlayerClass, idx);
            SourcePowerIdx = GetPowerIndexFromMappedSlot(DummyPawn.PlayerClass, idx);
            if (TargetPowerIdx == -1 || SourcePowerIdx == -1)
            {
                log(Self.Name, "TransferPowersError. TargetPowerIDX " $ TargetPowerIdx $ " : SourcePowerIDX" $ SourcePowerIdx, Outer);
                continue;
            }
            if (TransferSinglePower(SourcePowerMan, TargetPowerMan, SourcePowerIdx, TargetPowerIdx))
            {
                log(Self.Name, "TransferPowers: Transferred power slot " $ idx $ " (" $ SourcePowerMan.Powers[SourcePowerIdx].PowerName $ " -> " $ TargetPowerMan.Powers[TargetPowerIdx].PowerName $ ", rank " $ SourcePowerMan.Powers[SourcePowerIdx].Rank $ ")", Outer);
                continue;
            }
            log(Self.Name, "TransferPowers: Failed to transfer power at slot " $ idx, Outer);
        }
    }
    // Clean up the dummy pawn
    DummyPawn.Destroy();
    log(Self.Name, "TransferPowers: Complete. Dummy pawn destroyed.", Outer);
}
public function bool GetMPCharacterRecord(Name KitName, out SFXMPCharacterRecord OutRecord)
{
    OutRecord = SM.GetCharacterRecord(KitName);
    return OutRecord != None;
}
private final function int GetPowerIndexFromMappedSlot(SFXCharacterClass CharacterClass, int MappedSlot)
{
    local Name MappedPowerName;
    local int PowerIdx;
    
    if (MappedSlot < 0 || MappedSlot >= CharacterClass.default.MappedPowers.Length)
    {
        return -1;
    }
    MappedPowerName = CharacterClass.default.MappedPowers[MappedSlot];
    for (PowerIdx = 0; PowerIdx < CharacterClass.default.PowerCustomActionClasses.Length; ++PowerIdx)
    {
        if (CharacterClass.default.PowerCustomActionClasses[PowerIdx] != None)
        {
            if (CharacterClass.default.PowerCustomActionClasses[PowerIdx].Name == MappedPowerName)
            {
                return PowerIdx;
            }
        }
    }
    return -1;
}
private final function bool TransferSinglePower(SFXPowerManager SourcePowerMan, SFXPowerManager TargetPowerMan, int SourceIdx, int TargetIdx)
{
    local SFXPowerCustomActionBase SourcePower;
    local SFXPowerCustomActionBase TargetPower;
    local int i;
    
    if (SourceIdx < 0 || SourceIdx >= SourcePowerMan.Powers.Length)
    {
        return FALSE;
    }
    if (TargetIdx < 0 || TargetIdx >= TargetPowerMan.Powers.Length)
    {
        return FALSE;
    }
    
    SourcePower = SourcePowerMan.Powers[SourceIdx];
    TargetPower = TargetPowerMan.Powers[TargetIdx];
    
    TargetPower.Rank = SourcePower.Rank;
    
    for (i = 0; i < 6; ++i)
    {
        if (SourcePower.EvolvedChoices[i] > 0)
        {
            TargetPower.EvolvePower(byte(SourcePower.EvolvedChoices[i]));
        }
    }
    
    TargetPower.OnPowerRankIncreased();
    
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_TRansferPowers)
}