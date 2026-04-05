Class SFXWeaponUIDataManager
    native
    config(UI);

struct native SFXUIDataResource 
{
    var string Resource;
    var Name Package;
};

var config transient array<SFXUIDataResource> WeaponUIDataResources;
var transient array<SFXWeaponSelectWeaponData> WeaponUIData;
var transient array<SFXWeaponModData> ModUIData;
var config array<stringref> RomanNumerals;
var delegate<OnDataLoadedDelegate> __OnDataLoadedDelegate__Delegate;
var config transient stringref StatNameAccuracy;
var config transient stringref StatNameDamage;
var config transient stringref StatNameFireRate;
var config transient stringref StatNameMagSize;
var config transient stringref StatNameWeight;
var config transient float MaxAccuracyValue;
var config transient float MaxDamageValue;
var config transient float MaxFireRateValue;
var config transient float MaxMagazineValue;
var config transient float MaxWeightValue;
var config float MaxWeaponLevel;
var transient bool DataIsLoaded;

public final function Clear()
{
    WeaponUIData.Length = 0;
    ModUIData.Length = 0;
    DataIsLoaded = FALSE;
}
public final native function bool GetWeaponIniData(string WeaponPath, float WeaponLevelOverMaxLevel, out float Accuracy, out float Damage, out float RateOfFire, out float AmmoCapacity, out float Weight);

public final function string GetWeaponName(int nWeaponIndex)
{
    local string sName;
    
    if (WeaponIndexIsValid(nWeaponIndex) == FALSE)
    {
        return "";
    }
    SetCustomToken(0, GetRomanNumeral(WeaponUIData[nWeaponIndex].Level));
    sName = Class'SFXGUIMovie'.static.GetUIString(WeaponUIData[nWeaponIndex].Name, TRUE);
    ClearCustomTokens();
    return sName;
}
public delegate function OnDataLoadedDelegate();

public final function CalculateMaximumStatBarValues();

public final function bool CategoryHasNewWeapons(ELoadoutWeapons eType, optional bool bOnlyAvailableWeapons = TRUE)
{
    local int nIndex;
    local array<int> aIndices;
    
    aIndices = GetWeaponsByType(eType, bOnlyAvailableWeapons);
    for (nIndex = 0; nIndex < aIndices.Length; ++nIndex)
    {
        if (IsWeaponNew(aIndices[nIndex]))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final function array<Name> GetCurrentWeaponMods(int nWeaponIndex, Name nmHench)
{
    local array<Name> aMods;
    
    if (WeaponIndexIsValid(nWeaponIndex) == FALSE)
    {
        aMods.Length = 0;
        return aMods;
    }
    return GetWeaponModsByClassName(Name(WeaponUIData[nWeaponIndex].ClassPath), nmHench);
}
public final function string GetModDescription(int nModIndex, optional int nLevel = 0)
{
    local int idx;
    local int nToken;
    local string sFinalString;
    local string sTokenString;
    local SFXWeaponModData modData;
    
    if (ModIndexIsValid(nModIndex) == FALSE)
    {
        return "";
    }
    if (nLevel <= 0)
    {
        nLevel = ModUIData[nModIndex].Level;
    }
    if (nLevel <= 0)
    {
        nLevel = 1;
    }
    modData = ModUIData[nModIndex];
    ClearCustomTokens();
    nToken = 0;
    for (idx = 0; idx < modData.Stats.Length; idx++)
    {
        if (nLevel == modData.Stats[idx].Level)
        {
            sTokenString = string(modData.Stats[idx].Value * 100.0);
            if (Len(sTokenString) > 2)
            {
                sTokenString = Left(sTokenString, Len(sTokenString) - 2);
            }
            SetCustomToken(nToken++, sTokenString);
        }
    }
    sFinalString = Class'SFXGUIMovie'.static.GetUIString(modData.Description, TRUE);
    ClearCustomTokens();
    return sFinalString;
}
public final function string GetModDisplayName(int nModIndex, optional int nLevel = 0)
{
    local string sFinalString;
    
    if (ModIndexIsValid(nModIndex) == FALSE)
    {
        return "";
    }
    if (nLevel <= 0)
    {
        nLevel = ModUIData[nModIndex].Level;
    }
    if (nLevel <= 0)
    {
        nLevel = 1;
    }
    ClearCustomTokens();
    if (nLevel > 0 && nLevel <= ModUIData[nModIndex].ModLevelTokens.Length)
    {
        SetCustomToken(0, GetRomanNumeral(nLevel));
    }
    sFinalString = Class'SFXGUIMovie'.static.GetUIString(ModUIData[nModIndex].Name, TRUE);
    ClearCustomTokens();
    return sFinalString;
}
public final function array<int> GetModsForWeapon(int nWeapIndex, optional bool bAllowAllMods = FALSE)
{
    local array<int> aMods;
    
    if (WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        aMods.Length = 0;
        return aMods;
    }
    return GetModsForWeaponType(WeaponUIData[nWeapIndex].Type, bAllowAllMods);
}
public final function array<int> GetModsForWeaponType(ELoadoutWeapons eType, optional bool bAllowAllMods = FALSE)
{
    local array<string> aAllowedModNames;
    local array<int> aMods;
    local int nIndex;
    
    switch (eType)
    {
        case ELoadoutWeapons.LoadoutWeapons_AssaultRifles:
            aAllowedModNames = Class'SFXWeapon_AssaultRifle_Base'.default.AllowableWeaponMods;
            break;
        case ELoadoutWeapons.LoadoutWeapons_Shotguns:
            aAllowedModNames = Class'SFXWeapon_Shotgun_Base'.default.AllowableWeaponMods;
            break;
        case ELoadoutWeapons.LoadoutWeapons_SniperRifles:
            aAllowedModNames = Class'SFXWeapon_SniperRifle_Base'.default.AllowableWeaponMods;
            break;
        case ELoadoutWeapons.LoadoutWeapons_AutoPistols:
            aAllowedModNames = Class'SFXWeapon_SMG_Base'.default.AllowableWeaponMods;
            break;
        case ELoadoutWeapons.LoadoutWeapons_HeavyPistols:
            aAllowedModNames = Class'SFXWeapon_Pistol_Base'.default.AllowableWeaponMods;
            break;
        case ELoadoutWeapons.LoadoutWeapons_HeavyWeapons:
            aAllowedModNames = Class'SFXHeavyWeapon'.default.AllowableWeaponMods;
            break;
        default:
    }
    for (nIndex = 0; nIndex < ModUIData.Length; ++nIndex)
    {
        if (bAllowAllMods == FALSE && ModUIData[nIndex].Unlocked == FALSE)
        {
            continue;
        }
        if (aAllowedModNames.Find(ModUIData[nIndex].ClassPath) != -1)
        {
            aMods.AddItem(nIndex);
        }
    }
    return aMods;
}
public final function SFXWeaponUIStats GetModStatsForLevel(const SFXWeaponModData oModData, optional int nLevel = 0)
{
    local int nModStat;
    local SFXWeaponUIStats Stats;
    local SFXWeaponModUIStat oModStat;
    local int nAccuracyRank;
    local int nDamageRank;
    local int nFireRateRank;
    local int nMagazineRank;
    local int nWeightRank;
    
    if (nLevel <= 0)
    {
        nLevel = oModData.Level;
    }
    if (nLevel <= 0)
    {
        nLevel = 1;
    }
    for (nModStat = 0; nModStat < oModData.Stats.Length; ++nModStat)
    {
        oModStat = oModData.Stats[nModStat];
        switch (oModStat.Type)
        {
            case EWeaponStatBars.EWeaponStatBarAccuracy:
                if (oModStat.Level <= nLevel && oModStat.Level > nAccuracyRank)
                {
                    Stats.Accuracy = oModStat.Value;
                    nAccuracyRank = oModStat.Level;
                }
                break;
            case EWeaponStatBars.EWeaponStatBarDamage:
                if (oModStat.Level <= nLevel && oModStat.Level > nDamageRank)
                {
                    Stats.Damage = oModStat.Value;
                    nDamageRank = oModStat.Level;
                }
                break;
            case EWeaponStatBars.EWeaponStatBarFireRate:
                if (oModStat.Level <= nLevel && oModStat.Level > nFireRateRank)
                {
                    Stats.FireRate = oModStat.Value;
                    nFireRateRank = oModStat.Level;
                }
                break;
            case EWeaponStatBars.EWeaponStatBarMagSize:
                if (oModStat.Level <= nLevel && oModStat.Level > nMagazineRank)
                {
                    Stats.Magazine = oModStat.Value;
                    nMagazineRank = oModStat.Level;
                }
                break;
            case EWeaponStatBars.EWeaponStatBarWeight:
                if (oModStat.Level <= nLevel && oModStat.Level > nWeightRank)
                {
                    Stats.Weight = oModStat.Value;
                    nWeightRank = oModStat.Level;
                }
                break;
            default:
        }
    }
    return Stats;
}
public static final function string GetRomanNumeral(int nLevel)
{
    if (nLevel >= 0 && nLevel < default.RomanNumerals.Length)
    {
        return string(default.RomanNumerals[nLevel]);
    }
    else
    {
        return string(nLevel);
    }
}
public final function array<Name> GetWeaponModsByClassName(Name nmWeapClass, Name nmHench)
{
    local array<Name> aMods;
    local SFXEngine oEngine;
    local int nWeapMod;
    local int nIndex;
    local int nHenchIndex;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        aMods.Length = 0;
        return aMods;
    }
    if (nmHench == 'None')
    {
        for (nWeapMod = 0; nWeapMod < oEngine.PlayerWeaponMods.Length; ++nWeapMod)
        {
            if (oEngine.PlayerWeaponMods[nWeapMod].WeaponClassName == nmWeapClass)
            {
                break;
            }
        }
        if (nWeapMod < 0 || nWeapMod >= oEngine.PlayerWeaponMods.Length)
        {
            return aMods;
        }
        return oEngine.PlayerWeaponMods[nWeapMod].WeaponModClassNames;
    }
    nHenchIndex = -1;
    for (nIndex = 0; nIndex < oEngine.HenchmanRecords.Length; nIndex++)
    {
        if (nmHench == oEngine.HenchmanRecords[nIndex].Tag)
        {
            nHenchIndex = nIndex;
            break;
        }
    }
    if (nHenchIndex == -1)
    {
        return aMods;
    }
    for (nWeapMod = 0; nWeapMod < oEngine.HenchmanRecords[nHenchIndex].WeaponMods.Length; ++nWeapMod)
    {
        if (oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponClassName == nmWeapClass)
        {
            break;
        }
    }
    if (nWeapMod < 0 || nWeapMod >= oEngine.HenchmanRecords[nHenchIndex].WeaponMods.Length)
    {
        return aMods;
    }
    return oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponModClassNames;
}
public final function SFXWeaponModData GetWeaponModUIDataFromClassName(Name nmModClass, optional out int nIndex)
{
    local SFXWeaponModData noMod;
    
    for (nIndex = 0; nIndex < ModUIData.Length; ++nIndex)
    {
        if (Name(ModUIData[nIndex].ClassPath) == nmModClass)
        {
            return ModUIData[nIndex];
        }
    }
    nIndex = -1;
    noMod.Name = $-1;
    return noMod;
}
public final function SFXWeaponUIStats GetWeaponModValues(int nWeapIndex, Name nmHench)
{
    local SFXWeaponUIStats Stats;
    
    if (WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        return Stats;
    }
    return GetWeaponModValuesByClassName(Name(WeaponUIData[nWeapIndex].ClassPath), nmHench);
}
public final function SFXWeaponUIStats GetWeaponModValuesByClassName(Name nmWeapClass, Name nmHench)
{
    local SFXWeaponUIStats modValues;
    local SFXEngine oEngine;
    local int nPlayerWeapModClass;
    local Name nmWeapModClass;
    local SFXWeaponModData oModData;
    local int nModRank;
    local int nMaxModRank;
    local array<Name> WeaponMods;
    local SFXWeaponUIStats tempModValues;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return modValues;
    }
    nMaxModRank = Class'SFXWeaponMod'.static.GetMaxRank();
    WeaponMods = GetWeaponModsByClassName(nmWeapClass, nmHench);
    for (nPlayerWeapModClass = 0; nPlayerWeapModClass < WeaponMods.Length; ++nPlayerWeapModClass)
    {
        nmWeapModClass = WeaponMods[nPlayerWeapModClass];
        oModData = GetWeaponModUIDataFromClassName(nmWeapModClass);
        if (oModData.Name == -1)
        {
            continue;
        }
        nModRank = oModData.Level;
        if (nModRank == 0)
        {
            nModRank = 1;
        }
        if (nModRank <= 0 || nModRank > nMaxModRank)
        {
            continue;
        }
        tempModValues = GetModStatsForLevel(oModData, nModRank);
        modValues.Accuracy += tempModValues.Accuracy;
        modValues.Damage += tempModValues.Damage;
        modValues.FireRate += tempModValues.FireRate;
        modValues.Magazine += tempModValues.Magazine;
        modValues.Weight += tempModValues.Weight;
    }
    return modValues;
}
public final function array<int> GetWeaponsByType(ELoadoutWeapons eType, optional bool bOnlyAvailableWeapons)
{
    local array<int> aWeapons;
    local int nIndex;
    local SFXEngine oEngine;
    local SFXGRI oGRI;
    local bool bAvailable;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return aWeapons;
    }
    oGRI = SFXGRI(oEngine.GetCurrentWorldInfo().GRI);
    if (oGRI == None)
    {
    }
    for (nIndex = 0; nIndex < WeaponUIData.Length; ++nIndex)
    {
        if (int(WeaponUIData[nIndex].Type) == int(eType))
        {
            if (bOnlyAvailableWeapons)
            {
                bAvailable = oGRI != None && oGRI.bIsMultiplayerCharacter ? FALSE : WeaponUIData[nIndex].LoadoutInfo.bStartsUnlocked;
                if (!bAvailable)
                {
                    if (oEngine.GetPlayerVariable(Name(WeaponUIData[nIndex].ClassPath)) == 0)
                    {
                        continue;
                    }
                }
            }
            aWeapons.AddItem(nIndex);
        }
    }
    return aWeapons;
}
public final function SFXWeaponSelectWeaponData GetWeaponUIDataFromClassName(Name nmWeaponClass, out int nIndex)
{
    local SFXWeaponSelectWeaponData noWeap;
    
    for (nIndex = 0; nIndex < WeaponUIData.Length; ++nIndex)
    {
        if (WeaponUIData[nIndex].className == nmWeaponClass)
        {
            return WeaponUIData[nIndex];
        }
    }
    nIndex = -1;
    noWeap.Type = 6;
    return noWeap;
}
public final function SFXWeaponSelectWeaponData GetWeaponUIDataFromClassPath(Name nmWeaponClass, out int nIndex)
{
    local SFXWeaponSelectWeaponData noWeap;
    
    for (nIndex = 0; nIndex < WeaponUIData.Length; ++nIndex)
    {
        if (WeaponUIData[nIndex].ClassPath == string(nmWeaponClass))
        {
            return WeaponUIData[nIndex];
        }
    }
    nIndex = -1;
    noWeap.Type = 6;
    return noWeap;
}
public final function float GetWeaponUIStatValue(int nWeapIndex, EWeaponStatBars eStat, const SFXWeaponUIStats oModValues, optional bool bAddModStat = FALSE, optional out float fModBonus)
{
    local int WeaponLevel;
    local SFXEngine Engine;
    local float Accuracy;
    local float Damage;
    local float RateOfFire;
    local float AmmoCapacity;
    local float Weight;
    local float fBaseValue;
    local float fValue;
    local float fMaxValue;
    
    fModBonus = 0.0;
    if (WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        return 0.0;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine != None)
    {
        WeaponLevel = Engine.GetPlayerVariable(Name(WeaponUIData[nWeapIndex].ClassPath));
    }
    if (GetWeaponIniData(WeaponUIData[nWeapIndex].ClassPath, float(WeaponLevel) / MaxWeaponLevel, Accuracy, Damage, RateOfFire, AmmoCapacity, Weight))
    {
        switch (eStat)
        {
            case EWeaponStatBars.EWeaponStatBarAccuracy:
                fBaseValue = Accuracy;
                fMaxValue = MaxAccuracyValue;
                fModBonus = fBaseValue * oModValues.Accuracy;
                break;
            case EWeaponStatBars.EWeaponStatBarDamage:
                fBaseValue = Sqrt(Damage);
                fMaxValue = Sqrt(MaxDamageValue);
                fModBonus = fBaseValue * oModValues.Damage;
                break;
            case EWeaponStatBars.EWeaponStatBarFireRate:
                fBaseValue = RateOfFire;
                fMaxValue = MaxFireRateValue;
                fModBonus = fBaseValue * oModValues.FireRate;
                break;
            case EWeaponStatBars.EWeaponStatBarMagSize:
                fBaseValue = Sqrt(AmmoCapacity);
                fMaxValue = Sqrt(MaxMagazineValue);
                fModBonus = fBaseValue * oModValues.Magazine;
                break;
            case EWeaponStatBars.EWeaponStatBarWeight:
                fBaseValue = Weight;
                fMaxValue = MaxWeightValue;
                fBaseValue -= fBaseValue * oModValues.Weight;
                fModBonus = 0.0;
                break;
            default:
        }
    }
    fValue = fBaseValue + fModBonus;
    if (!bAddModStat)
    {
        fValue = fBaseValue;
    }
    fValue = FClamp(fValue, 0.0, fMaxValue);
    fModBonus = fModBonus / fMaxValue * 100.0;
    return fValue / fMaxValue * 100.0;
}
public final function bool IsWeaponNew(int nWeaponIndex)
{
    local SFXEngine oEngine;
    local SFXGRI oGRI;
    local SFXSaveManagerMP MPSaveManager;
    local bool bIsMultiplayer;
    
    if (WeaponIndexIsValid(nWeaponIndex) == FALSE)
    {
        return FALSE;
    }
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    oGRI = SFXGRI(oEngine.GetCurrentWorldInfo().GRI);
    bIsMultiplayer = oGRI != None && oGRI.bIsMultiplayerCharacter;
    if (bIsMultiplayer)
    {
        MPSaveManager = Class'SFXEngine'.static.GetSFXEngine().MPSaveManager;
        return MPSaveManager.HasNewReinforcement(4, WeaponUIData[nWeaponIndex].ClassPath) || MPSaveManager.HasNewReinforcement(5, WeaponUIData[nWeaponIndex].ClassPath) || MPSaveManager.HasNewReinforcement(2, WeaponUIData[nWeaponIndex].ClassPath) || MPSaveManager.HasNewReinforcement(3, WeaponUIData[nWeaponIndex].ClassPath) || MPSaveManager.HasNewReinforcement(1, WeaponUIData[nWeaponIndex].ClassPath);
    }
    else
    {
        return !Class'SFXPlayerSquadLoadoutData'.static.CheckWeaponLoadoutFlag(Name(WeaponUIData[nWeaponIndex].ClassPath), 0);
    }
}
public final function LoadData(delegate<OnDataLoadedDelegate> doneCallback, optional bool bForceReLoad)
{
    local SFXEngine oEngine;
    local int nPackage;
    local array<SFXAsyncAssetRequest> aRequests;
    
    if (DataIsLoaded != FALSE && bForceReLoad == FALSE)
    {
        if (doneCallback != None)
        {
            doneCallback();
            return;
        }
    }
    DataIsLoaded = FALSE;
    WeaponUIData.Length = 0;
    ModUIData.Length = 0;
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    aRequests.Length = WeaponUIDataResources.Length;
    for (nPackage = 0; nPackage < WeaponUIDataResources.Length; ++nPackage)
    {
        aRequests[nPackage].AltCookedPackageName = WeaponUIDataResources[nPackage].Package;
        aRequests[nPackage].FullAssetPath = WeaponUIDataResources[nPackage].Resource;
        aRequests[nPackage].AssetClass = Class'SFXWeaponUIData';
    }
    oEngine.AsyncAssetLoader.AsyncLoadAssets('WeaponUIData', aRequests, OnDataLoaded);
    __OnDataLoadedDelegate__Delegate = doneCallback;
}
public final function bool ModIndexIsValid(int nIndex)
{
    return nIndex >= 0 && nIndex < ModUIData.Length;
}
public final function OnDataLoaded()
{
    local int N;
    local int i;
    local SFXWeaponUIData oData;
    local SFXEngine oEngine;
    local array<Object> aAssets;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    oEngine.AsyncAssetLoader.GetAssetsForGroup('WeaponUIData', aAssets);
    for (N = 0; N < aAssets.Length; ++N)
    {
        oData = SFXWeaponUIData(aAssets[N]);
        if (oData == None)
        {
            continue;
        }
        for (i = 0; i < oData.m_aWeapons.Length; ++i)
        {
            WeaponUIData.AddItem(oData.m_aWeapons[i]);
            WeaponUIData[WeaponUIData.Length - 1].Level = oEngine.GetPlayerVariable(Name(WeaponUIData[WeaponUIData.Length - 1].ClassPath));
            WeaponUIData[WeaponUIData.Length - 1].Unlocked = WeaponUIData[WeaponUIData.Length - 1].Level > 0;
        }
        for (i = 0; i < oData.m_aMods.Length; ++i)
        {
            ModUIData.AddItem(oData.m_aMods[i]);
            ModUIData[ModUIData.Length - 1].Level = oEngine.GetPlayerVariable(Name(ModUIData[ModUIData.Length - 1].ClassPath));
            ModUIData[ModUIData.Length - 1].Unlocked = ModUIData[ModUIData.Length - 1].Level > 0;
        }
    }
    oEngine.AsyncAssetLoader.ClearAsyncGroup('WeaponUIData');
    CalculateMaximumStatBarValues();
    if (__OnDataLoadedDelegate__Delegate != None)
    {
        __OnDataLoadedDelegate__Delegate();
        __OnDataLoadedDelegate__Delegate = None;
    }
    DataIsLoaded = TRUE;
}
public final function bool WeaponIndexIsValid(int nIndex)
{
    return nIndex >= 0 && nIndex < WeaponUIData.Length;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponUIDataResources = ({Resource = "SFXGUI_WeaponUIData.Data", Package = 'SFXGUI_WeaponUIDataSF'}
                            )
    RomanNumerals = ($0, 
                     $702091, 
                     $702092, 
                     $702093, 
                     $702094, 
                     $702095, 
                     $702096, 
                     $702097, 
                     $702098, 
                     $702099, 
                     $702100
                    )
    StatNameAccuracy = $590476
    StatNameDamage = $590477
    StatNameFireRate = $590478
    StatNameMagSize = $590479
    StatNameWeight = $590480
    MaxAccuracyValue = 100.0
    MaxDamageValue = 1500.0
    MaxFireRateValue = 1000.0
    MaxMagazineValue = 800.0
    MaxWeightValue = 2.5
    MaxWeaponLevel = 10.0
}