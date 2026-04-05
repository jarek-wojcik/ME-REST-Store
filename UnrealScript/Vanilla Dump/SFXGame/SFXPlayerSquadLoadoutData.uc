Class SFXPlayerSquadLoadoutData extends SFXLoadoutData
    native
    config(Game);

struct native SpecialWeaponInfo 
{
    var Name WeaponClassName;
    var Name HenchmanClassName;
    var Name UnlockPlotName;
};
struct native BonusWeaponInfo 
{
    var Name UnlockPlotName;
    var ELoadoutWeapons WeaponClass;
};
struct native LoadoutInfo 
{
    var array<ELoadoutWeapons> WeaponClasses;
    var Name className;
};
struct native PlayerLoadoutInfoStruct 
{
    var array<ELoadoutWeapons> RequiredWeaponClasses;
    var array<ELoadoutWeapons> StartingWeaponClasses;
    var Name className;
    var int NumOptionalSlots;
};
struct native UnlockableWeaponClass 
{
    var(UnlockableWeaponClass) Name UnlockPlotId;
    var(UnlockableWeaponClass) ELoadoutWeapons WeaponType;
};
struct native PlotWeapon 
{
    var string WeaponClassName;
    var Name UnlockPlotId;
    var Name EquippedPlotId;
};
struct native PlotWeaponEditor 
{
    var(PlotWeaponEditor) Class<SFXWeapon> WeaponClass;
    var(PlotWeaponEditor) Name UnlockPlotId;
    var(PlotWeaponEditor) Name EquippedPlotId;
};
struct native LoadoutWeaponInfo 
{
    var(LoadoutWeaponInfo) Name className;
    var(LoadoutWeaponInfo) Name UnlockPlotId;
    var(LoadoutWeaponInfo) int Rating;
    var(LoadoutWeaponInfo) bool bNotRegularWeaponGUI;
    var(LoadoutWeaponInfo) bool bStartsUnlocked;
    
    structdefaultproperties
    {
        Rating = 10
    }
};
enum ELoadoutWeapons
{
    LoadoutWeapons_AssaultRifles,
    LoadoutWeapons_Shotguns,
    LoadoutWeapons_SniperRifles,
    LoadoutWeapons_AutoPistols,
    LoadoutWeapons_HeavyPistols,
    LoadoutWeapons_HeavyWeapons,
};
enum ELoadoutWeaponFlags
{
    LoadoutWeaponFlag_NotNew,
};

var config array<LoadoutWeaponInfo> AssaultRifles;
var config array<LoadoutWeaponInfo> Shotguns;
var config array<LoadoutWeaponInfo> SniperRifles;
var config array<LoadoutWeaponInfo> AutoPistols;
var config array<LoadoutWeaponInfo> HeavyPistols;
var config array<LoadoutWeaponInfo> HeavyWeapons;
var array<PlotWeapon> PlotWeapons;
var(Weapons) array<ELoadoutWeapons> StandardWeapons;
var(Weapons) array<UnlockableWeaponClass> UnlockableStandardWeapons;
var config array<PlayerLoadoutInfoStruct> PlayerLoadoutInfo;
var config array<LoadoutInfo> HenchLoadoutInfo;
var config array<BonusWeaponInfo> PlayerBonusWeapons;
var config array<SpecialWeaponInfo> PlayerSpecialWeapons;
var config array<SpecialWeaponInfo> HenchmenSpecialWeapons;
var int MaxWeapons;

public static function Name GetHenchmanClassname(Name HenchTag)
{
    local int idx;
    local Name HenchClassName;
    
    for (idx = 0; idx < Class'SFXPawn_Henchman'.default.HenchmenInfo.Length; idx++)
    {
        if (Class'SFXPawn_Henchman'.default.HenchmenInfo[idx].Tag == HenchTag)
        {
            HenchClassName = Class'SFXPawn_Henchman'.default.HenchmenInfo[idx].className;
        }
    }
    return HenchClassName;
}
public static function bool GetHenchmanLoadoutData(Name HenchClassName, out LoadoutInfo HenchInfo)
{
    local int Index;
    
    for (Index = 0; Index < default.HenchLoadoutInfo.Length; Index++)
    {
        HenchInfo = default.HenchLoadoutInfo[Index];
        if (HenchInfo.className == HenchClassName)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public static function GetWeaponCategory(Class<SFXWeapon> WClass, out int GroupIdx, out int EntryIdx)
{
    GetWeaponCategoryByName(Name(PathName(WClass)), GroupIdx, EntryIdx);
}
public static function array<LoadoutWeaponInfo> GetWeaponGroup(int idx)
{
    if (idx == 0)
    {
        return default.AssaultRifles;
    }
    else if (idx == 1)
    {
        return default.Shotguns;
    }
    else if (idx == 2)
    {
        return default.SniperRifles;
    }
    else if (idx == 3)
    {
        return default.AutoPistols;
    }
    else if (idx == 4)
    {
        return default.HeavyPistols;
    }
    else
    {
        return default.HeavyWeapons;
    }
}
public static function bool CanHenchmanUseWeaponClass(Name HenchTag, Class<SFXWeapon> Weapon)
{
    return CanHenchmanUseWeaponClass2(HenchTag, Name(PathName(Weapon)));
}
public static function bool CanHenchmanUseWeaponClass2(Name HenchTag, Name WeaponClassName)
{
    local int WeaponGroup;
    local int WeaponID;
    local SFXEngine Eng;
    local array<LoadoutWeaponInfo> WeaponGroupArray;
    local int idx;
    
    Eng = SFXEngine(Class'Engine'.static.GetEngine());
    if (Eng == None)
    {
        return FALSE;
    }
    GetWeaponCategoryByName(WeaponClassName, WeaponGroup, WeaponID);
    if (CanHenchmanUseWeaponGroup(HenchTag, byte(WeaponGroup)) == FALSE)
    {
        return FALSE;
    }
    WeaponGroupArray = GetWeaponGroup(WeaponGroup);
    for (idx = 0; idx < WeaponGroupArray.Length; idx++)
    {
        if (WeaponGroupArray[idx].className == WeaponClassName && WeaponGroupArray[idx].bStartsUnlocked)
        {
            return TRUE;
        }
    }
    if (Eng.GetPlayerVariable(WeaponClassName) == 0)
    {
        return FALSE;
    }
    return TRUE;
}
public static function bool CanHenchmanUseWeaponGroup(Name HenchTag, ELoadoutWeapons WeaponGroup)
{
    local LoadoutInfo Info;
    local Name HenchClassName;
    
    HenchClassName = GetHenchmanClassname(HenchTag);
    foreach default.HenchLoadoutInfo(Info, )
    {
        if (Info.className == HenchClassName)
        {
            return Info.WeaponClasses.Find(WeaponGroup) != -1;
        }
    }
    return FALSE;
}
public static function bool CanPlayerUseWeaponClass(Class<SFXWeapon> WeaponClass)
{
    return TRUE;
}
public static function bool CanPlayerUseWeaponGroup(ELoadoutWeapons eWeaponGroupID)
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(Class'Engine'.static.GetCurrentWorldInfo().GRI);
    if (GRI != None && GRI.bIsMultiplayerCharacter && eWeaponGroupID == ELoadoutWeapons.LoadoutWeapons_HeavyWeapons)
    {
        return FALSE;
    }
    return TRUE;
}
public static final function bool CheckWeaponLoadoutFlag(Name nmWeaponClassPath, ELoadoutWeaponFlags eFlag)
{
    local int nFlagToCheck;
    local int nData;
    local SFXEngine oEngine;
    local Name nmWeaponPlayerVariable;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return FALSE;
    }
    nmWeaponPlayerVariable = Name(nmWeaponClassPath $ ".Flags");
    nFlagToCheck = 1 << int(eFlag);
    nData = oEngine.GetPlayerVariable(nmWeaponPlayerVariable);
    return (nData & nFlagToCheck) != 0;
}
public static final function Class<SFXWeapon> FindWeaponClass(Name WeaponClassName)
{
    return Class<SFXWeapon>(Class'SFXEngine'.static.GetSeekFreeObjectByName(WeaponClassName, Class'Class'));
}
public static function array<Name> GetCurrentPlayerWeaponNames()
{
    local SFXEngine Engine;
    local array<Name> CurrentWeapons;
    local int idx;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return CurrentWeapons;
    }
    for (idx = 0; idx < 6; idx++)
    {
        if (Engine.PlayerLoadoutWeapons[idx] != 'None')
        {
            CurrentWeapons.AddItem(Engine.PlayerLoadoutWeapons[idx]);
        }
    }
    return CurrentWeapons;
}
public static function bool GetPlayerLoadoutData(coerce string PlayerClassName, out PlayerLoadoutInfoStruct PlayerData)
{
    local int Index;
    
    for (Index = 0; Index < default.PlayerLoadoutInfo.Length; Index++)
    {
        PlayerData = default.PlayerLoadoutInfo[Index];
        if (PlayerClassName == string(PlayerData.className))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public static function int GetPluralPrettyName(int idx)
{
    switch (idx)
    {
        case 0:
            return 326505;
        case 1:
            return 326503;
        case 2:
            return 326504;
        case 3:
            return 326501;
        case 4:
            return 326502;
        case 5:
            return 593649;
        default:
    }
    return 0;
}
public static function GetWeaponCategoryByName(Name WClassName, out int GroupIdx, out int EntryIdx)
{
    local LoadoutWeaponInfo LWI;
    
    for (EntryIdx = 0; EntryIdx < default.AssaultRifles.Length; EntryIdx++)
    {
        LWI = default.AssaultRifles[EntryIdx];
        if (LWI.className == WClassName)
        {
            GroupIdx = 0;
            return;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.Shotguns.Length; EntryIdx++)
    {
        LWI = default.Shotguns[EntryIdx];
        if (LWI.className == WClassName)
        {
            GroupIdx = 1;
            return;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.SniperRifles.Length; EntryIdx++)
    {
        LWI = default.SniperRifles[EntryIdx];
        if (LWI.className == WClassName)
        {
            GroupIdx = 2;
            return;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.AutoPistols.Length; EntryIdx++)
    {
        LWI = default.AutoPistols[EntryIdx];
        if (LWI.className == WClassName)
        {
            GroupIdx = 3;
            return;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.HeavyPistols.Length; EntryIdx++)
    {
        LWI = default.HeavyPistols[EntryIdx];
        if (LWI.className == WClassName)
        {
            GroupIdx = 4;
            return;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.HeavyWeapons.Length; EntryIdx++)
    {
        LWI = default.HeavyWeapons[EntryIdx];
        if (LWI.className == WClassName)
        {
            GroupIdx = 5;
            return;
        }
    }
    GroupIdx = -1;
    EntryIdx = -1;
}
public static function ELoadoutWeapons GetWeaponCategoryFromClassName(Name WClassName)
{
    local LoadoutWeaponInfo LWI;
    local int EntryIdx;
    
    for (EntryIdx = 0; EntryIdx < default.AssaultRifles.Length; EntryIdx++)
    {
        LWI = default.AssaultRifles[EntryIdx];
        if (LWI.className == WClassName)
        {
            return ELoadoutWeapons.LoadoutWeapons_AssaultRifles;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.Shotguns.Length; EntryIdx++)
    {
        LWI = default.Shotguns[EntryIdx];
        if (LWI.className == WClassName)
        {
            return ELoadoutWeapons.LoadoutWeapons_Shotguns;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.SniperRifles.Length; EntryIdx++)
    {
        LWI = default.SniperRifles[EntryIdx];
        if (LWI.className == WClassName)
        {
            return ELoadoutWeapons.LoadoutWeapons_SniperRifles;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.AutoPistols.Length; EntryIdx++)
    {
        LWI = default.AutoPistols[EntryIdx];
        if (LWI.className == WClassName)
        {
            return ELoadoutWeapons.LoadoutWeapons_AutoPistols;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.HeavyPistols.Length; EntryIdx++)
    {
        LWI = default.HeavyPistols[EntryIdx];
        if (LWI.className == WClassName)
        {
            return ELoadoutWeapons.LoadoutWeapons_HeavyPistols;
        }
    }
    for (EntryIdx = 0; EntryIdx < default.HeavyWeapons.Length; EntryIdx++)
    {
        LWI = default.HeavyWeapons[EntryIdx];
        if (LWI.className == WClassName)
        {
            return ELoadoutWeapons.LoadoutWeapons_HeavyWeapons;
        }
    }
    return 255;
}
public static function float GetWeaponPriority(Class<SFXWeapon> WClass)
{
    local int WeaponCategory;
    local int idx;
    local int Idx2;
    local WorldInfo WorldInfo;
    local PlayerController PC;
    local SFXPawn_Player pPawn;
    local Name className;
    local Name PlayerClassName;
    local float Priority;
    
    WorldInfo = Class'WorldInfo'.static.GetWorldInfo();
    if (WorldInfo == None)
    {
        return 0.0;
    }
    PC = WorldInfo.GetALocalPlayerController();
    if (PC == None)
    {
        return 0.0;
    }
    pPawn = SFXPawn_Player(PC.Pawn);
    if (pPawn == None)
    {
        return 0.0;
    }
    GetWeaponCategory(WClass, WeaponCategory, idx);
    for (idx = 0; idx < default.PlayerLoadoutInfo.Length; idx++)
    {
        className = default.PlayerLoadoutInfo[idx].className;
        PlayerClassName = pPawn.Class.Name;
        if (className != PlayerClassName)
        {
            continue;
        }
        Idx2 = default.PlayerLoadoutInfo[idx].StartingWeaponClasses.Find(byte(WeaponCategory));
        if (Idx2 < 0)
        {
            Priority = 0.0;
        }
        else
        {
            Priority = 1.0 - float(Idx2) / 10.0;
        }
        break;
    }
    return Priority;
}
public static function bool IsPlayerUsingWeaponGroup(ELoadoutWeapons WeaponGroup)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    PC = BWI.GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine == None)
    {
        return FALSE;
    }
    return Engine.PlayerLoadoutGroups.Find(WeaponGroup) != -1;
}
public static function bool IsWeaponClassInThePlayersDefaultWeaponGroups(Class<SFXWeapon> WClass)
{
    local int WeaponCategory;
    local int idx;
    local int Idx2;
    local WorldInfo WorldInfo;
    local PlayerController PC;
    local SFXPawn_Player pPawn;
    local Name className;
    
    WorldInfo = Class'WorldInfo'.static.GetWorldInfo();
    if (WorldInfo == None)
    {
        return FALSE;
    }
    PC = WorldInfo.GetALocalPlayerController();
    if (PC == None)
    {
        return FALSE;
    }
    pPawn = SFXPawn_Player(PC.Pawn);
    if (pPawn == None)
    {
        return FALSE;
    }
    GetWeaponCategory(WClass, WeaponCategory, idx);
    for (idx = 0; idx < default.PlayerLoadoutInfo.Length; idx++)
    {
        className = default.PlayerLoadoutInfo[idx].className;
        if (string(className) != pPawn.PlayerClassName)
        {
            continue;
        }
        Idx2 = default.PlayerLoadoutInfo[idx].StartingWeaponClasses.Find(byte(WeaponCategory));
        if (Idx2 < 0)
        {
            return FALSE;
        }
        break;
    }
    return TRUE;
}
public static final function SetWeaponLoadoutFlag(Name nmWeaponClassPath, ELoadoutWeaponFlags eFlag)
{
    local int nFlagToSet;
    local int nData;
    local SFXEngine oEngine;
    local Name nmWeaponPlayerVariable;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    nmWeaponPlayerVariable = Name(nmWeaponClassPath $ ".Flags");
    nFlagToSet = 1 << int(eFlag);
    nData = oEngine.GetPlayerVariable(nmWeaponPlayerVariable);
    nData = nData | nFlagToSet;
    oEngine.SetPlayerVariable(nmWeaponPlayerVariable, nData);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AssaultRifles = ({className = 'SFXGameContent.SFXWeapon_AssaultRifle_Avenger', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Argus', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Cobra', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Collector', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Falcon', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Geth', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Mattock', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Reckoning', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Revenant', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Saber', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Valkyrie', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                     {className = 'SFXGameContent.SFXWeapon_AssaultRifle_Vindicator', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}
                    )
    Shotguns = ({className = 'SFXGameContent.SFXWeapon_Shotgun_Katana', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Claymore', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Crusader', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Disciple', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Eviscerator', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Geth', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Graal', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Raider', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Scimitar', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                {className = 'SFXGameContent.SFXWeapon_Shotgun_Striker', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}
               )
    SniperRifles = ({className = 'SFXGameContent.SFXWeapon_SniperRifle_Mantis', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_BlackWidow', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Incisor', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Indra', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Javelin', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Raptor', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Valiant', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Viper', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_SniperRifle_Widow', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}
                   )
    AutoPistols = ({className = 'SFXGameContent.SFXWeapon_SMG_Shuriken', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                   {className = 'SFXGameContent.SFXWeapon_SMG_Hornet', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                   {className = 'SFXGameContent.SFXWeapon_SMG_Hurricane', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                   {className = 'SFXGameContent.SFXWeapon_SMG_Locust', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                   {className = 'SFXGameContent.SFXWeapon_SMG_Tempest', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}
                  )
    HeavyPistols = ({className = 'SFXGameContent.SFXWeapon_Pistol_Predator', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Carnifex', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Eagle', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Ivory', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Phalanx', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Scorpion', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Talon', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Pistol_Thor', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}
                   )
    HeavyWeapons = ({className = 'SFXGameContent.SFXWeapon_Heavy_ArcProjector', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_Avalanche', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_Blackstorm', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_Cain', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_FlameThrower_Player', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_Geth02LaserTarget', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_GrenadeLauncher', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_LegionDisinfectionWeapon', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_LegionInfectionLauncher', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_LegionInfectionLauncher_Inaccurate', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_MiniGun', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_MissileLauncher', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_ParticleBeam', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_RocketLauncher', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}, 
                    {className = 'SFXGameContent.SFXWeapon_Heavy_TitanMissileLauncher', UnlockPlotId = 'None', Rating = 10, bNotRegularWeaponGUI = FALSE, bStartsUnlocked = FALSE}
                   )
    PlayerLoadoutInfo = ({
                          RequiredWeaponClasses = (), 
                          StartingWeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_AutoPistols), 
                          className = 'SFXGameContent.SFXCharacterClass_Adept', 
                          NumOptionalSlots = 3
                         }, 
                         {
                          RequiredWeaponClasses = (), 
                          StartingWeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AutoPistols, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                          className = 'SFXGameContent.SFXCharacterClass_Engineer', 
                          NumOptionalSlots = 3
                         }, 
                         {
                          RequiredWeaponClasses = (), 
                          StartingWeaponClasses = (ELoadoutWeapons.LoadoutWeapons_SniperRifles, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                          className = 'SFXGameContent.SFXCharacterClass_Infiltrator', 
                          NumOptionalSlots = 3
                         }, 
                         {
                          RequiredWeaponClasses = (), 
                          StartingWeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_Shotguns, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                          className = 'SFXGameContent.SFXCharacterClass_Soldier', 
                          NumOptionalSlots = 4
                         }, 
                         {
                          RequiredWeaponClasses = (), 
                          StartingWeaponClasses = (ELoadoutWeapons.LoadoutWeapons_Shotguns, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                          className = 'SFXGameContent.SFXCharacterClass_Sentinel', 
                          NumOptionalSlots = 3
                         }, 
                         {
                          RequiredWeaponClasses = (), 
                          StartingWeaponClasses = (ELoadoutWeapons.LoadoutWeapons_Shotguns, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                          className = 'SFXGameContent.SFXCharacterClass_Vanguard', 
                          NumOptionalSlots = 3
                         }
                        )
    HenchLoadoutInfo = ({
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_SniperRifles), 
                         className = 'SFXPawn_Garrus'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_Shotguns), 
                         className = 'SFXPawn_Grunt'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_Shotguns), 
                         className = 'SFXPawn_Jack'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_Shotguns), 
                         className = 'SFXPawn_Jacob'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_SniperRifles), 
                         className = 'SFXPawn_Legion'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_AutoPistols), 
                         className = 'SFXPawn_Miranda'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_AutoPistols), 
                         className = 'SFXPawn_Mordin'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AutoPistols, ELoadoutWeapons.LoadoutWeapons_AssaultRifles), 
                         className = 'SFXPawn_Samara'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_Shotguns), 
                         className = 'SFXPawn_Tali'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AutoPistols, ELoadoutWeapons.LoadoutWeapons_SniperRifles), 
                         className = 'SFXPawn_Thane'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AutoPistols, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                         className = 'SFXPawn_Kasumi'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_SniperRifles), 
                         className = 'SFXPawn_Zaeed'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AutoPistols, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                         className = 'SFXPawn_Liara'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_SniperRifles), 
                         className = 'SFXPawn_Ashley'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                         className = 'SFXPawn_Kaidan'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AutoPistols, ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                         className = 'SFXPawn_EDI'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols, ELoadoutWeapons.LoadoutWeapons_Shotguns), 
                         className = 'SFXPawn_Prothean'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_AssaultRifles, ELoadoutWeapons.LoadoutWeapons_Shotguns), 
                         className = 'SFXPawn_Marine'
                        }, 
                        {
                         WeaponClasses = (ELoadoutWeapons.LoadoutWeapons_HeavyPistols), 
                         className = 'SFXPawn_Anderson'
                        }
                       )
    MaxWeapons = 5
}