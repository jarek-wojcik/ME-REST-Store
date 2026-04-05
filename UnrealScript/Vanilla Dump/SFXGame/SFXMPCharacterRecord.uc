Class SFXMPCharacterRecord;

struct native WeaponModRecord 
{
    var array<Name> WeaponModClassNames;
    var Name WeaponClassName;
};
struct native WeaponRecord 
{
    var Name WeaponClassName;
};
struct PowerRecord 
{
    var int EvolvedChoices[6];
    var Name PowerName;
    var Name PowerClassName;
    var float CurrentRank;
    var int WheelDisplayIndex;
    var bool bUsesTalentPoints;
};

var string CharacterName;
var array<PowerRecord> Powers;
var array<WeaponRecord> Weapons;
var array<WeaponModRecord> WeaponMods;
var SaveTimeStamp TimeStamp;
var Name className;
var Name KitName;
var int Tint1ID;
var int Tint2ID;
var int PatternID;
var int PatternColorID;
var int PhongID;
var int EmissiveID;
var int SkinToneID;
var float SecondsPlayed;
var int TalentPointsAvailable;
var bool TalentPointsInitialized;
var bool Deployed;
var bool LeveledUp;
var bool bSerializedFromBlaze;

public final function bool IsInitialized()
{
    return Powers.Length > 0;
}
public function AutoLevelUpPowers(SFXPawn_Player PlayerPawn)
{
    local SFXPowerLevelUpHelper Helper;
    
    if (PlayerPawn == None)
    {
        return;
    }
    Helper = new (PlayerPawn) Class'SFXPowerLevelUpHelper';
    if (Helper == None)
    {
        return;
    }
    Helper.Initialize(BioWorldInfo(PlayerPawn.WorldInfo));
    PlayerPawn.TalentPoints = GetTalentPoints();
    Helper.SetPawn(PlayerPawn);
    Helper.AutoLevelUp();
    SetPowersFromPawn(PlayerPawn);
    RecalculateTalentPoints();
}
public function int GetPointsSpentAtRank(int PowerRank)
{
    local int RefundAmount;
    local int idx;
    
    RefundAmount = 0;
    for (idx = 0; idx < PowerRank; idx++)
    {
        RefundAmount += Class'SFXPowerCustomAction'.default.RankCosts[idx];
    }
    return RefundAmount;
}
public function int GetTalentPoints()
{
    if (!TalentPointsInitialized)
    {
        RecalculateTalentPoints();
    }
    return TalentPointsAvailable;
}
public function int GetTalentPointsFast()
{
    local int UsedTalentPoints;
    local int TotalTalentPoints;
    local int idx;
    local SFXMPClassRecord ParentClass;
    
    ParentClass = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager.GetClassRecord(className);
    TotalTalentPoints = Class'BioLevelUpSystem'.static.GetTalentPointSum(ParentClass.Level, FALSE);
    for (idx = 0; idx < Powers.Length; ++idx)
    {
        if (Powers[idx].bUsesTalentPoints)
        {
            UsedTalentPoints += GetPointsSpentAtRank(int(Powers[idx].CurrentRank));
        }
    }
    return TotalTalentPoints - UsedTalentPoints;
}
public function bool HasLeveledUp()
{
    return LeveledUp;
}
public final function InitializeFromCharacterClass(string CharacterClassName)
{
    local int idx;
    local int Idx2;
    local int PowerIdx;
    local Class<SFXCharacterClass> CharacterClass;
    local Class<SFXPowerCustomActionBase> PowerClass;
    local PowerRecord oPowerRecord;
    local WeaponRecord oWeaponRecord;
    
    CharacterClass = Class<SFXCharacterClass>(FindObject(CharacterClassName, Class'Class'));
    if (CharacterClass == None)
    {
        return;
    }
    if (Powers.Length == 0)
    {
        for (idx = 0; idx < CharacterClass.default.PowerCustomActionClasses.Length; idx++)
        {
            PowerClass = Class<SFXPowerCustomActionBase>(CharacterClass.default.PowerCustomActionClasses[idx]);
            if (PowerClass == None)
            {
                continue;
            }
            oPowerRecord.PowerName = PowerClass.default.PowerName;
            PowerIdx = CharacterClass.default.StartingPowerRanks.Find('PowerClass', PowerClass);
            if (PowerIdx != -1)
            {
                oPowerRecord.CurrentRank = CharacterClass.default.StartingPowerRanks[PowerIdx].Rank;
            }
            else
            {
                oPowerRecord.CurrentRank = 0.0;
            }
            for (Idx2 = 0; Idx2 < 6; Idx2++)
            {
                oPowerRecord.EvolvedChoices[Idx2] = PowerClass.default.EvolvedChoices[Idx2];
            }
            oPowerRecord.PowerClassName = Name(PathName(PowerClass));
            oPowerRecord.WheelDisplayIndex = PowerClass.default.WheelDisplayIndex;
            oPowerRecord.bUsesTalentPoints = PowerClass.default.DisplayInCharacterRecord;
            Powers.AddItem(oPowerRecord);
        }
    }
    if (Weapons.Length == 0)
    {
        for (idx = 0; idx < CharacterClass.default.Loadout.Weapons.Length; ++idx)
        {
            oWeaponRecord.WeaponClassName = Name(PathName(CharacterClass.default.Loadout.Weapons[idx]));
            Weapons.AddItem(oWeaponRecord);
        }
    }
    RecalculateTalentPoints();
}
public final function InitializeWeaponsFromEnginePlayerLoadout()
{
    local SFXEngine Engine;
    local WeaponRecord oWeaponRecord;
    local WeaponModRecord oWeaponModRecord;
    local Name WeaponModClassName;
    local int idx;
    local int Idx2;
    
    Engine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    Weapons.Length = 0;
    for (idx = 0; idx < Engine.PlayerLoadoutGroups.Length; ++idx)
    {
        oWeaponRecord.WeaponClassName = Engine.PlayerLoadoutWeapons[int(Engine.PlayerLoadoutGroups[idx])];
        if (oWeaponRecord.WeaponClassName != 'None')
        {
            Weapons.AddItem(oWeaponRecord);
        }
    }
    WeaponMods.Length = 0;
    for (idx = 0; idx < Engine.PlayerWeaponMods.Length; ++idx)
    {
        oWeaponModRecord.WeaponClassName = Engine.PlayerWeaponMods[idx].WeaponClassName;
        oWeaponModRecord.WeaponModClassNames.Length = 0;
        for (Idx2 = 0; Idx2 < Engine.PlayerWeaponMods[idx].WeaponModClassNames.Length; ++Idx2)
        {
            WeaponModClassName = Engine.PlayerWeaponMods[idx].WeaponModClassNames[Idx2];
            if (oWeaponModRecord.WeaponModClassNames.Find(WeaponModClassName) == -1)
            {
                oWeaponModRecord.WeaponModClassNames.AddItem(WeaponModClassName);
            }
        }
        WeaponMods.AddItem(oWeaponModRecord);
    }
}
public function bool IsDeployed()
{
    return Deployed;
}
public function bool IsUnlocked()
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager;
    return MPSaveManager.GetPlayerVariable(KitName) > 0;
}
private final function Class<SFXPowerCustomActionBase> LoadPower(string PowerClassName)
{
    return Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.GetSeekFreeObject(PowerClassName, Class'Class'));
}
public function RecalculateTalentPoints()
{
    local int PowerIdx;
    local int TotalTalentPoints;
    local int UsedTalentPoints;
    local PowerRecord PowerRec;
    local Class<SFXPowerCustomActionBase> PowerClass;
    local SFXMPClassRecord ParentClass;
    
    ParentClass = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager.GetClassRecord(className);
    UsedTalentPoints = 0;
    TotalTalentPoints = Class'BioLevelUpSystem'.static.GetTalentPointSum(ParentClass.Level, FALSE);
    for (PowerIdx = 0; PowerIdx < Powers.Length; ++PowerIdx)
    {
        PowerRec = Powers[PowerIdx];
        PowerClass = LoadPower(string(PowerRec.PowerClassName));
        if (PowerClass != None)
        {
            UsedTalentPoints += Class'SFXPowerManager'.static.GetRefundAmount(PowerClass, int(PowerRec.CurrentRank));
            continue;
        }
    }
    TalentPointsAvailable = TotalTalentPoints - UsedTalentPoints;
    TalentPointsInitialized = TRUE;
}
public function ResetCharacter()
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = Class'SFXEngine'.static.GetSFXEngine().MPSaveManager;
    CharacterName = MPSaveManager.GetUniqueCharacterName(KitName);
    Tint1ID = default.Tint1ID;
    Tint2ID = default.Tint2ID;
    PatternID = default.PatternID;
    PatternColorID = default.PatternColorID;
    PhongID = default.PhongID;
    EmissiveID = default.EmissiveID;
    SkinToneID = default.SkinToneID;
    Deployed = FALSE;
    LeveledUp = TRUE;
    Weapons.Length = 0;
    WeaponMods.Length = 0;
    ResetPowers();
    bSerializedFromBlaze = FALSE;
}
public function ResetPowers()
{
    Powers.Length = 0;
    TalentPointsInitialized = FALSE;
}
public function SetLeveledUp(bool bLeveledUp)
{
    LeveledUp = bLeveledUp;
}
public final function SetPowersFromPawn(SFXPawn Pawn)
{
    local int idx;
    local int Idx2;
    local SFXPowerManager PowerMan;
    
    PowerMan = Pawn.PowerManager;
    if (PowerMan != None)
    {
        Powers.Length = PowerMan.Powers.Length;
        for (idx = 0; idx < PowerMan.Powers.Length; idx++)
        {
            Powers[idx].PowerName = PowerMan.Powers[idx].PowerName;
            Powers[idx].CurrentRank = PowerMan.Powers[idx].Rank;
            for (Idx2 = 0; Idx2 < 6; Idx2++)
            {
                Powers[idx].EvolvedChoices[Idx2] = PowerMan.Powers[idx].EvolvedChoices[Idx2];
            }
            Powers[idx].PowerClassName = Name(PathName(PowerMan.Powers[idx].Class));
            Powers[idx].WheelDisplayIndex = PowerMan.Powers[idx].WheelDisplayIndex;
            Powers[idx].bUsesTalentPoints = PowerMan.Powers[idx].DisplayInCharacterRecord;
        }
    }
}
public final function TransferCharacterDataToPawn(SFXPawn_Player Pawn)
{
    local SFXSaveManagerMP MPSaveManager;
    local SFXMPClassRecord ClassRecord;
    
    MPSaveManager = Class'SFXEngine'.static.GetSFXEngine().MPSaveManager;
    ClassRecord = MPSaveManager.GetClassRecord(className);
    Pawn.firstName = CharacterName;
    Pawn.TotalXP = ClassRecord.GetTotalXP();
    Pawn.CharacterLevel = ClassRecord.Level;
    Pawn.TalentPoints = GetTalentPoints();
}
public final function TransferPowersToPawn(SFXPawn_Player Pawn)
{
    local array<PowerSaveInfo> PawnPowers;
    local array<Name> PowerNames;
    local int idx;
    local int Idx2;
    local SFXPowerManager PowerMan;
    local SFXPowerCustomActionBase Power;
    
    PowerMan = Pawn.PowerManager;
    if (PowerMan != None)
    {
        for (idx = 0; idx < Powers.Length; ++idx)
        {
            PowerNames.Add(1);
            PowerNames[idx] = Powers[idx].PowerClassName;
        }
        if (!VerifySavedPawnPowers(PowerNames, Pawn))
        {
            return;
        }
        PawnPowers.Length = Powers.Length;
        if (Powers.Length > 0)
        {
            for (idx = 0; idx < Powers.Length; idx++)
            {
                PawnPowers[idx].PowerName = Powers[idx].PowerName;
                PawnPowers[idx].CurrentRank = Powers[idx].CurrentRank;
                for (Idx2 = 0; Idx2 < 6; Idx2++)
                {
                    PawnPowers[idx].EvolvedChoices[Idx2] = Powers[idx].EvolvedChoices[Idx2];
                }
                PawnPowers[idx].PowerClassName = Powers[idx].PowerClassName;
                PawnPowers[idx].WheelDisplayIndex = Powers[idx].WheelDisplayIndex;
            }
            for (idx = 0; idx < PowerMan.Powers.Length; ++idx)
            {
                PowerMan.Powers[idx].ResetPower();
            }
            PowerMan.LoadPowers(PawnPowers);
            foreach PowerMan.Powers(Power, )
            {
                Power.OnPowersLoaded();
            }
        }
    }
}
public final function TransferWeaponsToEnginePlayerLoadout()
{
    local int WeaponIdx;
    local int WeaponModIdx;
    local int GroupID;
    local int WeaponID;
    local int idx;
    local Class<SFXWeapon> WClass;
    local SFXEngine Engine;
    local WeaponModSaveRecord ModRecord;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    Engine.PlayerLoadoutGroups.Length = 0;
    for (idx = 0; idx < 6; ++idx)
    {
        Engine.PlayerLoadoutWeapons[idx] = 'None';
    }
    Engine.PlayerWeaponMods.Length = 0;
    for (WeaponIdx = 0; WeaponIdx < Weapons.Length; ++WeaponIdx)
    {
        WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(Weapons[WeaponIdx].WeaponClassName);
        Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(WClass, GroupID, WeaponID);
        Engine.PlayerLoadoutWeapons[GroupID] = Weapons[WeaponIdx].WeaponClassName;
        Engine.PlayerLoadoutGroups.AddItem(byte(GroupID));
    }
    for (WeaponIdx = 0; WeaponIdx < WeaponMods.Length; ++WeaponIdx)
    {
        ModRecord.WeaponClassName = WeaponMods[WeaponIdx].WeaponClassName;
        ModRecord.WeaponModClassNames.Length = 0;
        for (WeaponModIdx = 0; WeaponModIdx < WeaponMods[WeaponIdx].WeaponModClassNames.Length; ++WeaponModIdx)
        {
            ModRecord.WeaponModClassNames.AddItem(WeaponMods[WeaponIdx].WeaponModClassNames[WeaponModIdx]);
        }
        Engine.PlayerWeaponMods.AddItem(ModRecord);
    }
}
public static final function bool VerifySavedPawnPowers(out array<Name> SavedPowers, SFXPawn_Player Pawn)
{
    local int idx;
    local int Idx2;
    local bool bFoundPower;
    local Name PawnPowerPath;
    local Class<SFXCharacterClass> CharacterClass;
    
    CharacterClass = Class<SFXCharacterClass>(FindObject(Pawn.default.PlayerClassName, Class'Class'));
    for (idx = 0; idx < SavedPowers.Length; ++idx)
    {
        bFoundPower = FALSE;
        for (Idx2 = 0; Idx2 < CharacterClass.default.PowerCustomActionClasses.Length; ++Idx2)
        {
            if (CharacterClass.default.PowerCustomActionClasses[Idx2] == None)
            {
                continue;
            }
            PawnPowerPath = Name(PathName(CharacterClass.default.PowerCustomActionClasses[Idx2]));
            if (SavedPowers[idx] == PawnPowerPath)
            {
                bFoundPower = TRUE;
                break;
            }
        }
        if (!bFoundPower)
        {
            return FALSE;
        }
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tint2ID = 45
    PatternColorID = 47
    PhongID = 45
    EmissiveID = 9
    SkinToneID = 9
    LeveledUp = TRUE
}