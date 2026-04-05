Class SFXGUI_WeaponSelection extends SFXGUIMovie
    config(UI);

struct WeaponStatesToKeep 
{
    var Name WeaponClassName;
    var Name AmmoPowerName;
    var Name AmmoPowerSourceTag;
    var BioPawn Pawn;
    var float CurrentSpareAmmo;
    var float AmmoUsedCount;
};
struct SFXWeaponUIPawnPositioning 
{
    var Rotator RotationOffset;
    var Vector PositionOffset;
    var Name Tag;
};
const NO_WEAPON = -2;
const PLAYER_ID = -1;

var transient array<int> TeamSelectPawns;
var transient array<int> CurrentInventoryWeapons;
var transient array<Name> EntryWeaponNames;
var transient string WeaponActionMethod;
var array<WeaponStatesToKeep> SavedWeaponStates;
var config transient array<SFXWeaponUIPawnPositioning> AppearancePositions;
var transient int CurrentLoadoutWeapons[6];
var config transient Rotator BaseRotationOffset;
var config transient Vector BasePositionOffset;
var transient Rotator InitialRotation;
var transient Vector InitialPosition;
var config transient stringref WeaponLoadoutTitle;
var config transient stringref ChangeWeaponButtonText;
var config transient stringref SelectWeaponButtonText;
var config transient stringref ExitButtonText;
var config transient stringref ReturnToLoadoutText;
var config transient stringref ModifyWeaponText;
var config transient stringref EmptyModSlotText;
var config transient stringref LoadingDataText;
var config transient stringref EmptySlotText;
var config transient stringref EncumbranceText;
var config transient stringref EncumbranceTitle;
var config transient stringref DiscardWeaponMessageText;
var config transient stringref CancelDiscardWeaponButtonText;
var config transient stringref MinimumWeaponCountRequirementMessage;
var config transient stringref MinimumWeaponCountRequirementPluralMessage;
var config transient stringref MinimumWeaponCountAwknowledgementButtonText;
var config transient stringref StatsButtonText;
var config transient stringref DescriptionButtonText;
var config transient stringref WeaponModTitle;
var config transient stringref InstructionText;
var config transient stringref EquipButtonText;
var transient int CurrentlySelectedLoadoutWeapon;
var transient int CurrentlySelectedSelectionWeapon;
var transient int CurrentPawnID;
var transient stringref WeaponActionText;
var config transient float MinDisplayBonus;
var transient int nMinimumRequiredWeapons;
var export SFXWeaponUIDataManager DataManager;
var(WeaponSelect) bool ShowAllWeapons;
var(WeaponSelect) bool AutoEquipWhenDone;
var transient bool InWeaponSelection;
var transient bool LoadoutLoaded;
var transient bool LaunchOnStart;
var bool bWasPaused;
var transient bool bSwitchingHenchmen;
var transient ELoadoutWeapons CurrentLoadoutWeaponType;
var transient ELoadoutWeapons EntryWeaponGroup;

public final function Exit()
{
    local SFXPawn_Player pPawn;
    
    if (CountCurrentPawnWeapons() < nMinimumRequiredWeapons)
    {
        ShowMinimumRequiredWeaponsMessage();
        return;
    }
    if (LoadoutLoaded)
    {
        ApplyWeaponLoadout();
        MakeLoadoutsActive();
        RestorePowerBonuses();
        pPawn = SFXPawn_Player(GetBioPawn(-1));
        if (pPawn != None)
        {
            pPawn.ApplyBonuses();
        }
    }
    DataManager.Clear();
    PlayGuiSound('WeaponGUIExit');
    LoadoutLoaded = FALSE;
    if (GetPC().Pawn != None)
    {
        GetPC().Pawn.SetHidden(FALSE);
    }
    Close(TRUE);
}
public final function BioPawn GetBioPawn(int nPawnID)
{
    local int nSquadMember;
    local BioPawn oPlayer;
    local BioPawn oPawn;
    local BioPawn oPendingPawn;
    local BioBaseSquad oSquad;
    local int nCount;
    
    oPlayer = BioPawn(BioPlayerController(GetPC()).Pawn);
    oSquad = oPlayer == None ? None : oPlayer.Squad;
    if (oPlayer == None || oSquad == None || !oSquad.bIsPlayerSquad)
    {
        return None;
    }
    if (nPawnID == -1)
    {
        oPawn = oPlayer;
    }
    else
    {
        nCount = nPawnID;
        for (nSquadMember = 0; nSquadMember < oSquad.Members.Length; nSquadMember++)
        {
            oPendingPawn = BioPawn(oSquad.Members[nSquadMember]);
            if (oPendingPawn == None || oPendingPawn == oPlayer)
            {
                oPendingPawn = None;
                continue;
            }
            --nCount;
            if (nCount < 0)
            {
                oPawn = oPendingPawn;
                break;
            }
        }
    }
    if (oPawn == None)
    {
    }
    return oPawn;
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            AS_ScrollInfoText(fValue);
            break;
        default:
            return Super.HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public event function OnStart()
{
    Super.OnStart();
    if (SFXEngine(Class'Engine'.static.GetEngine()) == None)
    {
        DisplayNoEngineMessage();
        Close(TRUE);
        return;
    }
    m_bHandleKeyPresses = FALSE;
    if (LaunchOnStart)
    {
        Launch();
    }
}
public event function OnClose()
{
    CleanupUIWorld();
    oWorldInfo.ForceGarbageCollection();
    SetGameMode(FALSE);
    Super.OnClose();
    oWorldInfo.PauseGame(bWasPaused);
}
private final function ApplyPlayerPawnCustomization(Object InData)
{
    local SFXPawn_Player PlayerPawn;
    local Actor SpawnedActor;
    
    PlayerPawn = SFXPawn_Player(InData);
    if (PlayerPawn != None)
    {
        SpawnedActor = oWorldInfo.m_UIWorld.GetSpawnedActor(PlayerPawn);
        if (SpawnedActor != None)
        {
            PlayerPawn.ApplyCustomizationToActor(SpawnedActor);
            InitialRotation = SpawnedActor.Rotation;
            InitialPosition = SpawnedActor.location;
            UpdateUIWorldPawnPosition();
        }
    }
}
public final function ApplyWeaponLoadout()
{
    local SFXEngine oEngine;
    local int nIndex;
    local Name nmWeapClassName;
    local Name nmOldWeapClassName;
    local int nWeapIndex;
    local int nTypeIndex;
    local int nHenchIndex;
    local BioPawn pPawn;
    local array<Name> WeaponMods;
    local int nMod;
    local array<TelemetryAttribute> aTelAttribs;
    local string sTelAttVal;
    local int nTelAttribs;
    local int nTelWeapon;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    pPawn = GetBioPawn(CurrentPawnID);
    if (pPawn == None)
    {
        return;
    }
    if (CurrentPawnID != -1)
    {
        nHenchIndex = -1;
        for (nIndex = 0; nIndex < oEngine.HenchmanRecords.Length; nIndex++)
        {
            if (pPawn.Tag == oEngine.HenchmanRecords[nIndex].Tag)
            {
                nHenchIndex = nIndex;
                break;
            }
        }
        if (nHenchIndex == -1)
        {
            return;
        }
    }
    else
    {
        oEngine.PlayerLoadoutGroups.Length = 0;
    }
    nTelAttribs = 0;
    nTelWeapon = 0;
    for (nTypeIndex = 0; nTypeIndex < 6; ++nTypeIndex)
    {
        nWeapIndex = CurrentLoadoutWeapons[nTypeIndex];
        if (nWeapIndex == -1 || DataManager.WeaponIndexIsValid(nWeapIndex) == FALSE)
        {
            nmWeapClassName = 'None';
        }
        else
        {
            nmWeapClassName = Name(DataManager.WeaponUIData[nWeapIndex].ClassPath);
        }
        if (CurrentPawnID == -1)
        {
            if (nmWeapClassName != 'None')
            {
                oEngine.PlayerLoadoutGroups.AddItem(byte(nTypeIndex));
            }
            nmOldWeapClassName = oEngine.PlayerLoadoutWeapons[nTypeIndex];
            if (nmOldWeapClassName != nmWeapClassName)
            {
                oEngine.PlayerLoadoutWeapons[nTypeIndex] = nmWeapClassName;
            }
        }
        else
        {
            oEngine.HenchmanRecords[nHenchIndex].LoadoutWeapons[nTypeIndex] = nmWeapClassName;
        }
        if (nmWeapClassName != 'None')
        {
            WeaponMods = DataManager.GetCurrentWeaponMods(nWeapIndex, GetCurrentHenchTag());
            aTelAttribs.Add(1 + WeaponMods.Length);
            aTelAttribs[nTelAttribs].Type = ETelemetryAttributeType.AttributeType_String;
            sTelAttVal = "wp0" $ nTelWeapon + 1;
            aTelAttribs[nTelAttribs].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
            sTelAttVal = DataManager.WeaponUIData[nWeapIndex].ClassPath;
            aTelAttribs[nTelAttribs].sData = Class'SFXTelemetry'.static.GenerateUniqueClassIdFromString(sTelAttVal);
            nTelAttribs++;
            for (nMod = 0; nMod < WeaponMods.Length; ++nMod)
            {
                aTelAttribs[nTelAttribs].Type = ETelemetryAttributeType.AttributeType_String;
                sTelAttVal = "wm" $ nTelWeapon + 1 $ nMod + 1;
                aTelAttribs[nTelAttribs].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
                sTelAttVal = string(WeaponMods[nMod]);
                aTelAttribs[nTelAttribs].sData = Class'SFXTelemetry'.static.GenerateUniqueClassIdFromString(sTelAttVal);
                nTelAttribs++;
            }
            nTelWeapon++;
        }
    }
    if (nTelAttribs > 0 && !oWorldInfo.GRI.IsA('SFXGRIMP_Lobby'))
    {
        if (CurrentPawnID != -1)
        {
            aTelAttribs.Add(1);
            sTelAttVal = "smem";
            aTelAttribs[nTelAttribs].Type = ETelemetryAttributeType.AttributeType_String;
            aTelAttribs[nTelAttribs].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
            aTelAttribs[nTelAttribs].sData = string(GetCurrentHenchTag());
            nTelAttribs++;
        }
        Class'SFXTelemetry'.static.SendArray('TelemetryHook_SelectWeapon', aTelAttribs);
    }
}
public final function AS_AddWeaponStat(string sName, float fValue, float fBonus, float fCompare)
{
    ActionScriptVoid("WeaponSelect.AddWeaponStat");
}
public final function AS_ClearWeaponStatsDisplay()
{
    ActionScriptVoid("WeaponSelect.ClearWeaponStatsDisplay");
}
public final function AS_PerformPlayerWeaponAction(bool bAccept)
{
    ActionScriptVoid("WeaponSelect.PerformPlayerWeaponAction");
}
public final function AS_ScrollInfoText(float fScroll)
{
    ActionScriptVoid("WeaponSelect.ScrollInfoText");
}
public final function AS_SelectWeaponSlot(int nSlotID)
{
    ActionScriptVoid("WeaponSelect.SelectWeaponSlot");
}
public final function AS_SetCurrentNameText(const string sName)
{
    ActionScriptVoid("Team.SetCurrentNameText");
}
public final function AS_SetInventoryWeapon(string sName, string sDesc, string sIconResource, bool bNew, int nNum, int nTotal, bool bFlourish)
{
    ActionScriptVoid("WeaponSelect.SetInventoryWeapon");
}
public final function AS_SetLoading(bool bLoading, string sText)
{
    ActionScriptVoid("WeaponSelect.SetLoading");
}
public final function AS_SetModDisplay(int nDisplay, string sName, string sImgPath)
{
    ActionScriptVoid("WeaponSelect.SetModDisplay");
}
public final function AS_SetSlotNewIcon(int nSlot, bool bHasNew)
{
    ActionScriptVoid("WeaponSelect.SetSlotNewIcon");
}
public final function AS_SetVisible(bool bVisible)
{
    ActionScriptVoid("WeaponSelect.SetVisible");
}
public final function AS_SetWeaponAction(string sButtonText, string sCallbackMethodName)
{
    ActionScriptVoid("WeaponSelect.SetWeaponAction");
}
public final function AS_SetWeaponInfoDisplay(string sWeaponName, string sWeaponDescription, string sCategory, string sWeaponImage)
{
    ActionScriptVoid("WeaponSelect.SetWeaponInfoDisplay");
}
public final function AS_SetWeaponSlot(int nSlotID, int nWeaponID, string sWeaponIconResource, int nWeaponIconIndex, int nNumOtherWeapons, bool bHaveNewWeapons, int nCategory, bool bValid, bool bHasModsAvailable)
{
    ActionScriptVoid("WeaponSelect.SetWeaponSlot");
}
public final function AS_SetWeightDisplay(int nPercent, int nComparePct, string sBarLabel, string sInfo)
{
    ActionScriptVoid("WeaponSelect.SetWeightDisplay");
}
public final function AS_TeamSetHenchman(int nIndex, const string sName, const string sIconResource)
{
    ActionScriptVoid("Team.SetHenchman");
}
public final function AS_TeamSetVisible(bool bVisible)
{
    ActionScriptVoid("Team.SetVisible");
}
public final function BuildWeaponLoadout(int nPawnID)
{
    local int nIndex;
    local int nWeaponIndex;
    local BioPawn pPawn;
    local int nHenchIndex;
    local Name nmWeapClass;
    local Class<SFXWeapon> pWeapClass;
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    for (nIndex = 0; nIndex < 6; ++nIndex)
    {
        CurrentLoadoutWeapons[nIndex] = -1;
    }
    pPawn = GetBioPawn(nPawnID);
    if (pPawn == None)
    {
        return;
    }
    if (!IsMultiPlayerCharacter())
    {
        if (nPawnID != -1)
        {
            nHenchIndex = -1;
            for (nIndex = 0; nIndex < oEngine.HenchmanRecords.Length; nIndex++)
            {
                if (pPawn.Tag == oEngine.HenchmanRecords[nIndex].Tag)
                {
                    nHenchIndex = nIndex;
                    break;
                }
            }
            if (nHenchIndex == -1)
            {
                return;
            }
        }
        else if (!bSwitchingHenchmen)
        {
            SFXPawn_Player(pPawn).UpdatePlayerLoadoutInfo();
        }
    }
    for (nIndex = 0; nIndex < 6; ++nIndex)
    {
        if (nPawnID == -1)
        {
            nmWeapClass = oEngine.PlayerLoadoutWeapons[nIndex];
        }
        else
        {
            nmWeapClass = oEngine.HenchmanRecords[nHenchIndex].LoadoutWeapons[nIndex];
        }
        if (nmWeapClass == 'None')
        {
            continue;
        }
        pWeapClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(nmWeapClass);
        if (pWeapClass == None || nPawnID == -1 && oEngine.GetPlayerVariable(nmWeapClass) == 0)
        {
            pWeapClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(nIndex)[0].className);
        }
        DataManager.GetWeaponUIDataFromClassName(pWeapClass.Name, nWeaponIndex);
        CurrentLoadoutWeapons[nIndex] = nWeaponIndex;
    }
    for (nIndex = 0; nIndex < 6; ++nIndex)
    {
        RefreshLoadoutWeaponDisplay(byte(nIndex));
    }
    LoadoutLoaded = TRUE;
}
public final function bool CanPawnUseWeaponGroup(int nPawnID, ELoadoutWeapons eWeaponGroupID)
{
    local BioPawn oHench;
    
    if (nPawnID == -1)
    {
        return Class'SFXPlayerSquadLoadoutData'.static.CanPlayerUseWeaponGroup(eWeaponGroupID);
    }
    else
    {
        oHench = GetBioPawn(nPawnID);
        if (oHench != None)
        {
            return Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponGroup(oHench.Tag, eWeaponGroupID);
        }
    }
    return FALSE;
}
public final function bool CheckCanEquipWeapon(int nWeapCategory)
{
    local int nEquippedCount;
    local int nIndex;
    
    if (!IsMultiPlayerCharacter())
    {
        return TRUE;
    }
    if (!CanPawnUseWeaponGroup(CurrentPawnID, byte(nWeapCategory)))
    {
        return FALSE;
    }
    if (CurrentLoadoutWeapons[nWeapCategory] == -1)
    {
        return TRUE;
    }
    for (nIndex = 0; nIndex < 6; ++nIndex)
    {
        if (nIndex != nWeapCategory && CurrentLoadoutWeapons[nIndex] != -1)
        {
            ++nEquippedCount;
        }
    }
    if (nEquippedCount < 2)
    {
        return TRUE;
    }
    PromptPlayerToDiscardMPWeapon(nWeapCategory);
    return FALSE;
}
public final function bool CheckCanSelectWeapon(int nWeapCategory)
{
    if (!CanPawnUseWeaponGroup(CurrentPawnID, byte(nWeapCategory)))
    {
        return FALSE;
    }
    return TRUE;
}
public final function CleanupUIWorld()
{
    local BioPawn oPawn;
    local int nIndex;
    
    if (oWorldInfo == None || oWorldInfo.m_UIWorld == None)
    {
        return;
    }
    oPawn = GetBioPawn(-1);
    if (oPawn != None)
    {
        oWorldInfo.m_UIWorld.HidePawn(oPawn, TRUE);
        oWorldInfo.m_UIWorld.CleanupPawn(oPawn);
    }
    for (nIndex = 0; nIndex <= 2 && nIndex < TeamSelectPawns.Length; ++nIndex)
    {
        oPawn = GetBioPawn(TeamSelectPawns[nIndex]);
        if (oPawn != None)
        {
            oWorldInfo.m_UIWorld.HidePawn(oPawn, TRUE);
            oWorldInfo.m_UIWorld.CleanupPawn(oPawn);
        }
    }
    oWorldInfo.m_UIWorld.FlushPendingCommands();
}
public final function int CountCurrentPawnWeapons()
{
    local int nIndex;
    local int nCount;
    
    for (nIndex = 0; nIndex < 6; ++nIndex)
    {
        if (CurrentLoadoutWeapons[nIndex] != -1)
        {
            ++nCount;
        }
    }
    return nCount;
}
public final function bool CurrentPawnHasWeapon()
{
    return CountCurrentPawnWeapons() > 0;
}
public final function DisplayCurrentWeaponSelection(bool bFlourish)
{
    local int nInventoryIndex;
    local SFXWeaponSelectWeaponData oData;
    local bool bIsNew;
    
    nInventoryIndex = CurrentInventoryWeapons.Find(CurrentlySelectedSelectionWeapon);
    if (DataManager.WeaponIndexIsValid(CurrentlySelectedSelectionWeapon) == FALSE)
    {
        nInventoryIndex = -1;
    }
    if (nInventoryIndex == -1)
    {
        AS_SetInventoryWeapon(UIStrRef(EmptySlotText), "", "", FALSE, 0, CurrentInventoryWeapons.Length, bFlourish);
    }
    else
    {
        oData = DataManager.WeaponUIData[CurrentlySelectedSelectionWeapon];
        bIsNew = DataManager.IsWeaponNew(CurrentlySelectedSelectionWeapon);
        AS_SetInventoryWeapon(DataManager.GetWeaponName(CurrentlySelectedSelectionWeapon), UIStrRef(oData.Description), PathName(oData.Image), bIsNew, nInventoryIndex + 1, CurrentInventoryWeapons.Length, bFlourish);
        Class'SFXPlayerSquadLoadoutData'.static.SetWeaponLoadoutFlag(Name(oData.ClassPath), 0);
        AS_SetSlotNewIcon(WeaponTypeToSlotIndex(oData.Type), DataManager.CategoryHasNewWeapons(oData.Type, !ShowAllWeapons));
    }
}
public final function DisplayNoEngineMessage()
{
    local Color Clr;
    local string S;
    
    Clr.R = 61;
    Clr.G = 166;
    Clr.B = 252;
    Clr.A = 255;
    S = "No instance of SFXEngine found; this is required for the weapon selection screen.";
    GetSFXUIController().AddLogEntry(S, 30.0, Clr);
}
public final function Name GetCurrentHenchTag()
{
    local BioPawn pPawn;
    
    if (CurrentPawnID == -1)
    {
        return 'None';
    }
    pPawn = GetBioPawn(CurrentPawnID);
    return pPawn.Tag;
}
public final function InitializeTeamSelectOverlay()
{
    local int nIndex;
    local BioPawn oPawn;
    
    TeamSelectPawns.Length = 0;
    nIndex = -1;
    oPawn = GetBioPawn(nIndex);
    while (oPawn != None)
    {
        TeamSelectPawns.AddItem(nIndex);
        nIndex++;
        oPawn = GetBioPawn(nIndex);
    }
    if (TeamSelectPawns.Length > 1)
    {
        AS_TeamSetVisible(TRUE);
    }
}
public final function bool IsMultiPlayerCharacter()
{
    return SFXGRI(BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GRI).bIsMultiplayerCharacter;
}
public final function Launch(optional bool bPauseGame = TRUE)
{
    local SFXHeavyWeapon HeavyWeapon;
    local SFXPawn_Player pPawn;
    local SFXWeapon Weapon;
    local WeaponStatesToKeep AmmoState;
    local BioPawn pCurrentPawn;
    local int nIndex;
    
    CurrentPawnID = -1;
    nMinimumRequiredWeapons = 1;
    InWeaponSelection = FALSE;
    bWasPaused = oWorldInfo.bPlayersOnly;
    if (bPauseGame)
    {
        oWorldInfo.PauseGame(TRUE);
    }
    MakeLoadoutsActive();
    pPawn = SFXPawn_Player(GetBioPawn(-1));
    if (pPawn != None)
    {
        if (!IsMultiPlayerCharacter())
        {
            foreach pPawn.InvManager.InventoryActors(Class'SFXHeavyWeapon', HeavyWeapon)
            {
                pPawn.TossWeapon(HeavyWeapon);
            }
        }
        if (pPawn.Weapon != None)
        {
            EntryWeaponGroup = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(Name(PathName(pPawn.Weapon.Class)));
        }
        pPawn.SetHidden(TRUE);
    }
    EntryWeaponNames = Class'SFXPlayerSquadLoadoutData'.static.GetCurrentPlayerWeaponNames();
    if (pPawn != None && pPawn.Squad != None)
    {
        SavedWeaponStates.Length = 0;
        for (nIndex = 0; nIndex < pPawn.Squad.Members.Length; nIndex++)
        {
            pCurrentPawn = BioPawn(pPawn.Squad.Members[nIndex]);
            if (pCurrentPawn != None)
            {
                foreach pCurrentPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
                {
                    AmmoState.Pawn = pCurrentPawn;
                    AmmoState.WeaponClassName = Weapon.Class.Name;
                    AmmoState.AmmoPowerName = Weapon.AmmoPowerName;
                    AmmoState.AmmoPowerSourceTag = Weapon.AmmoPowerSourceTag;
                    AmmoState.CurrentSpareAmmo = float(Weapon.CurrentSpareAmmo);
                    AmmoState.AmmoUsedCount = float(Weapon.AmmoUsedCount);
                    SavedWeaponStates.AddItem(AmmoState);
                }
            }
        }
    }
    AS_SetLoading(TRUE, UIStrRef(LoadingDataText));
    DataManager.LoadData(OnWeaponUIDataLoaded);
    if (IsMultiPlayerCharacter() == FALSE)
    {
        InitializeTeamSelectOverlay();
        if (TeamSelectPawns.Length > 1)
        {
            UpdateHenchmenDisplay();
        }
    }
    SetupUIWorld();
    SetGameMode(TRUE);
}
public final function MainMovieLoaded();

public final function MakeLoadoutsActive()
{
    local BioBaseSquad pSquad;
    local SFXWeapon pWeapon;
    local int nIndex;
    local SFXPawn_PlayerParty pPawn;
    
    if (!IsMultiPlayerCharacter())
    {
        pSquad = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).m_playerSquad;
        for (nIndex = 0; nIndex < pSquad.Members.Length; nIndex++)
        {
            pPawn = SFXPawn_PlayerParty(pSquad.Members[nIndex]);
            pPawn.CreateWeapons(pPawn.Loadout, TRUE);
            pPawn.ApplyAppropriateModsIfNoneExist(EntryWeaponNames);
            if (SFXPawn_Player(pPawn) != None)
            {
                SFXPawn_Player(pPawn).UpdateWeaponVisibility_DEPRECATED();
            }
            if (AutoEquipWhenDone)
            {
                if (Class'SFXPlayerSquadLoadoutData'.static.IsPlayerUsingWeaponGroup(EntryWeaponGroup) == FALSE)
                {
                    foreach pPawn.InvManager.InventoryActors(Class'SFXWeapon', pWeapon)
                    {
                        pPawn.SetWeaponImmediately(pWeapon);
                        break;
                    }
                    continue;
                }
                foreach pPawn.InvManager.InventoryActors(Class'SFXWeapon', pWeapon)
                {
                    if (int(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(Name(PathName(pWeapon.Class)))) == int(EntryWeaponGroup))
                    {
                        pPawn.SetWeaponImmediately(pWeapon);
                        break;
                    }
                }
            }
        }
    }
}
public final function OnWeaponUIDataLoaded()
{
    BuildWeaponLoadout(CurrentPawnID);
    if (oWorldInfo.IsConsoleBuild(0))
    {
        AS_SelectWeaponSlot(WeaponTypeToSlotIndex(EntryWeaponGroup));
    }
    if (!IsMultiPlayerCharacter())
    {
        m_bHandleKeyPresses = TRUE;
    }
    PlayGuiSound('WeaponGUIEnter');
    AS_SetLoading(FALSE, "");
    SetMouseVisible(TRUE);
}
public final function PlayerDiscardWeaponCallback(BioSFHandler_MessageBox oMsgBox, int nChoiceID, bool bCancelled)
{
    if (bCancelled)
    {
        AS_PerformPlayerWeaponAction(FALSE);
        return;
    }
    CurrentLoadoutWeapons[nChoiceID] = -1;
    RefreshLoadoutWeaponDisplay(byte(nChoiceID));
    AS_PerformPlayerWeaponAction(TRUE);
}
public final function PreLoadData(delegate<SFXWeaponUIDataManager.OnDataLoadedDelegate> doneCallback)
{
    DataManager.LoadData(doneCallback);
}
public final function PromptPlayerToDiscardMPWeapon(int nWeapCategory)
{
    local int nIndex;
    local int nOption1;
    local int nOption2;
    local stringref srOption1;
    local stringref srOption2;
    local BioSFHandler_MessageBox oMB;
    
    nOption1 = -1;
    nOption2 = -1;
    for (nIndex = 0; nIndex < 6; ++nIndex)
    {
        if (nIndex != nWeapCategory && CurrentLoadoutWeapons[nIndex] != -1)
        {
            if (nOption1 == -1)
            {
                nOption1 = nIndex;
                srOption1 = stringref(Class'SFXPlayerSquadLoadoutData'.static.GetPluralPrettyName(int(DataManager.WeaponUIData[CurrentLoadoutWeapons[nIndex]].Type)));
                continue;
            }
            if (nOption2 == -1)
            {
                nOption2 = nIndex;
                srOption2 = stringref(Class'SFXPlayerSquadLoadoutData'.static.GetPluralPrettyName(int(DataManager.WeaponUIData[CurrentLoadoutWeapons[nIndex]].Type)));
                continue;
            }
            break;
        }
    }
    oMB = GetSFXUIController().CreateMessageBox(GetPC());
    if (oMB != None)
    {
        oMB.SetChoiceResultCallback(PlayerDiscardWeaponCallback);
        oMB.ShowChoiceDialog(DiscardWeaponMessageText, CancelDiscardWeaponButtonText, srOption1, nOption1, TRUE, srOption2, nOption2, TRUE);
    }
}
public final function RefreshLoadoutWeaponDisplay(ELoadoutWeapons eWeaponType)
{
    local int nSlot;
    local int nIndex;
    local bool bNewWeaponsAvailable;
    local array<int> aOtherWeaponsOfType;
    local bool bCanUseThisType;
    local array<int> aAvailableMods;
    local bool bHasModsAvailable;
    local SFXWeaponSelectWeaponData oData;
    
    nIndex = -1;
    if (CurrentLoadoutWeapons[int(eWeaponType)] != -1)
    {
        nIndex = CurrentLoadoutWeapons[int(eWeaponType)];
        if (nIndex == -1)
        {
            return;
        }
    }
    bCanUseThisType = CanPawnUseWeaponGroup(CurrentPawnID, eWeaponType);
    nSlot = WeaponTypeToSlotIndex(eWeaponType);
    if (bCanUseThisType)
    {
        aOtherWeaponsOfType = DataManager.GetWeaponsByType(eWeaponType, !ShowAllWeapons);
        bNewWeaponsAvailable = DataManager.CategoryHasNewWeapons(eWeaponType, !ShowAllWeapons);
    }
    aAvailableMods = DataManager.GetModsForWeaponType(eWeaponType);
    bHasModsAvailable = aAvailableMods.Length > 0;
    if (nIndex != -1 && DataManager.WeaponIndexIsValid(nIndex))
    {
        oData = DataManager.WeaponUIData[nIndex];
        AS_SetWeaponSlot(nSlot, nIndex, PathName(oData.IconResource), oData.IconIndex, aOtherWeaponsOfType.Length, bNewWeaponsAvailable, int(eWeaponType), bCanUseThisType, bHasModsAvailable);
    }
    else
    {
        AS_SetWeaponSlot(nSlot, nIndex, "", 0, aOtherWeaponsOfType.Length, bNewWeaponsAvailable, int(eWeaponType), bCanUseThisType, bHasModsAvailable);
    }
    UpdateWeaponEncumbranceDisplay();
}
public final function RestorePowerBonuses()
{
    local SFXWeapon pWeapon;
    local BioPawn pPawn;
    local int nIndex;
    local int nAmmoIndex;
    local SFXPowerCustomAction_AmmoPowerBase AmmoPower;
    local BioBaseSquad pSquad;
    
    pSquad = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).m_playerSquad;
    if (pSquad != None)
    {
        for (nIndex = 0; nIndex < pSquad.Members.Length; nIndex++)
        {
            pPawn = BioPawn(pSquad.Members[nIndex]);
            if (pPawn == None)
            {
                continue;
            }
            if (pPawn.PowerManager != None)
            {
                pPawn.PowerManager.OnPawnEquippedNewWeapon();
            }
            for (nAmmoIndex = 0; nAmmoIndex < SavedWeaponStates.Length; nAmmoIndex++)
            {
                if (SavedWeaponStates[nAmmoIndex].Pawn == pPawn)
                {
                    foreach pPawn.InvManager.InventoryActors(Class'SFXWeapon', pWeapon)
                    {
                        if (pWeapon.Class.Name == SavedWeaponStates[nAmmoIndex].WeaponClassName)
                        {
                            AmmoPower = Class'SFXPowerCustomAction_AmmoPowerBase'.static.GetSourceAmmoPower(SavedWeaponStates[nAmmoIndex].AmmoPowerName, SavedWeaponStates[nAmmoIndex].AmmoPowerSourceTag);
                            if (AmmoPower != None)
                            {
                                AmmoPower.SetWeaponPower(pPawn, pWeapon, TRUE);
                            }
                            pWeapon.AmmoUsedCount = int(SavedWeaponStates[nAmmoIndex].AmmoUsedCount);
                            pWeapon.CurrentSpareAmmo = int(SavedWeaponStates[nAmmoIndex].CurrentSpareAmmo);
                        }
                    }
                }
            }
        }
    }
    SavedWeaponStates.Length = 0;
}
public final function SelectNextHenchman()
{
    local int N;
    
    if (TeamSelectPawns.Length <= 1)
    {
        PlayGuiError();
        return;
    }
    if (CountCurrentPawnWeapons() < nMinimumRequiredWeapons)
    {
        ShowMinimumRequiredWeaponsMessage();
        return;
    }
    bSwitchingHenchmen = TRUE;
    ApplyWeaponLoadout();
    N = TeamSelectPawns[TeamSelectPawns.Length - 1];
    TeamSelectPawns.Remove(TeamSelectPawns.Length - 1, 1);
    TeamSelectPawns.InsertItem(0, N);
    UpdateHenchmenDisplay();
    SetCurrentPawnID(TeamSelectPawns[0]);
    UpdateCurrentLoadoutWeaponDisplay();
    bSwitchingHenchmen = FALSE;
}
public final function SelectNextWeapon()
{
    local int nInventoryIndex;
    
    nInventoryIndex = CurrentInventoryWeapons.Find(CurrentlySelectedSelectionWeapon);
    if (nInventoryIndex == -1 && CurrentInventoryWeapons.Length > 0)
    {
        CurrentlySelectedSelectionWeapon = CurrentInventoryWeapons[0];
    }
    else if (nInventoryIndex < CurrentInventoryWeapons.Length - 1)
    {
        CurrentlySelectedSelectionWeapon = CurrentInventoryWeapons[nInventoryIndex + 1];
    }
    else
    {
        PlayGuiError();
        return;
    }
    WeaponSelectionItemChanged();
}
public final function SelectPreviousHenchman()
{
    local int N;
    
    if (TeamSelectPawns.Length <= 1)
    {
        PlayGuiError();
        return;
    }
    if (CountCurrentPawnWeapons() < nMinimumRequiredWeapons)
    {
        ShowMinimumRequiredWeaponsMessage();
        return;
    }
    bSwitchingHenchmen = TRUE;
    ApplyWeaponLoadout();
    N = TeamSelectPawns[0];
    TeamSelectPawns.Remove(0, 1);
    TeamSelectPawns.AddItem(N);
    UpdateHenchmenDisplay();
    SetCurrentPawnID(TeamSelectPawns[0]);
    UpdateCurrentLoadoutWeaponDisplay();
    bSwitchingHenchmen = FALSE;
}
public final function SelectPrevWeapon()
{
    local int nInventoryIndex;
    
    nInventoryIndex = CurrentInventoryWeapons.Find(CurrentlySelectedSelectionWeapon);
    if (nInventoryIndex == -1 || CurrentInventoryWeapons.Length == 0)
    {
        PlayGuiError();
        return;
    }
    else if (nInventoryIndex > 0)
    {
        CurrentlySelectedSelectionWeapon = CurrentInventoryWeapons[nInventoryIndex - 1];
    }
    else
    {
        CurrentlySelectedSelectionWeapon = -1;
    }
    WeaponSelectionItemChanged();
}
public final function SetCurrentPawnID(int nID)
{
    if (oWorldInfo != None && oWorldInfo.m_UIWorld != None)
    {
        oWorldInfo.m_UIWorld.HidePawn(GetBioPawn(CurrentPawnID), TRUE);
    }
    CurrentPawnID = nID;
    BuildWeaponLoadout(nID);
    RefreshLoadoutWeaponDisplay(CurrentLoadoutWeaponType);
    if (oWorldInfo != None && oWorldInfo.m_UIWorld != None)
    {
        oWorldInfo.m_UIWorld.HidePawn(GetBioPawn(CurrentPawnID), FALSE);
        UpdateUIWorldPawnPosition();
    }
    nMinimumRequiredWeapons = CurrentPawnID == -1 ? 1 : 2;
}
public final function SetupUIWorld()
{
    local BioPawn oPawn;
    local int nIndex;
    local Actor oUIWorldActor;
    
    if (oWorldInfo == None || oWorldInfo.m_UIWorld == None)
    {
        return;
    }
    oPawn = BioPawn(GetPC().Pawn);
    oWorldInfo.m_UIWorld.SpawnPawn(oPawn, 'CharRecSpawnPoint', 'CharRecPawn', None, 'None', 4);
    if (SFXPawn_Player(oPawn) != None)
    {
        oWorldInfo.m_UIWorld.AddDeferredOperation(ApplyPlayerPawnCustomization, oPawn);
        oUIWorldActor = oWorldInfo.m_UIWorld.GetSpawnedActor(oPawn);
    }
    if (IsMultiPlayerCharacter())
    {
        if (oUIWorldActor != None)
        {
            oUIWorldActor.SetLocation(m_UIWorldMPPawnInitialLocation, );
            oUIWorldActor.SetRotation(m_UIWorldMPPawnInitialRotation);
        }
    }
    for (nIndex = 1; nIndex <= 2 && nIndex < TeamSelectPawns.Length; ++nIndex)
    {
        oPawn = GetBioPawn(TeamSelectPawns[nIndex]);
        if (oPawn != None)
        {
            oWorldInfo.m_UIWorld.SpawnPawn(oPawn, 'CharRecSpawnPoint', 'CharRecPawn', None, 'None', 4 | 8);
        }
    }
    oWorldInfo.m_UIWorld.TriggerEvent('SetupCharRec', oWorldInfo);
}
public final function SetWeaponInfoDisplay(int nWeaponIndex, optional int nCategory = -1)
{
    local SFXWeaponSelectWeaponData oData;
    local stringref srCategoryTitle;
    
    if (nCategory == -1 && DataManager.WeaponIndexIsValid(nWeaponIndex) != FALSE)
    {
        srCategoryTitle = stringref(Class'SFXPlayerSquadLoadoutData'.static.GetPluralPrettyName(int(DataManager.WeaponUIData[nWeaponIndex].Type)));
    }
    else
    {
        srCategoryTitle = stringref(Class'SFXPlayerSquadLoadoutData'.static.GetPluralPrettyName(nCategory));
    }
    if (DataManager.WeaponIndexIsValid(nWeaponIndex) == FALSE)
    {
        AS_SetWeaponInfoDisplay("", "", UIStrRef(srCategoryTitle), "");
        return;
    }
    oData = DataManager.WeaponUIData[nWeaponIndex];
    AS_SetWeaponInfoDisplay(DataManager.GetWeaponName(nWeaponIndex), UIStrRef(oData.Description), UIStrRef(srCategoryTitle), PathName(oData.Image));
}
public final function SetWeaponModsDisplay(int nWeapIndex)
{
    local array<Name> WeaponMods;
    local int nMod;
    local int nModDataIndex;
    local SFXWeaponModData Mod;
    local string ImagePath;
    
    AS_SetModDisplay(1, UIStrRef(EmptyModSlotText), "");
    AS_SetModDisplay(2, UIStrRef(EmptyModSlotText), "");
    if (DataManager.WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        return;
    }
    WeaponMods = DataManager.GetCurrentWeaponMods(nWeapIndex, GetCurrentHenchTag());
    for (nMod = 0; nMod < WeaponMods.Length && nMod < 2; ++nMod)
    {
        Mod = DataManager.GetWeaponModUIDataFromClassName(WeaponMods[nMod], nModDataIndex);
        if (nModDataIndex != -1)
        {
            ImagePath = Mod.Image == None ? "" : PathName(Mod.Image);
            AS_SetModDisplay(nMod + 1, DataManager.GetModDisplayName(nModDataIndex), ImagePath);
        }
    }
}
public final function SetWeaponStatsDisplay(int nWeapIndex)
{
    local bool bDoCompare;
    local SFXWeaponUIStats oModValues;
    local SFXWeaponUIStats oCompareModValues;
    local float fValue;
    local float fBonus;
    local float fCompare;
    
    AS_ClearWeaponStatsDisplay();
    if (DataManager.WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        return;
    }
    bDoCompare = FALSE;
    if (InWeaponSelection == TRUE && CurrentlySelectedLoadoutWeapon != nWeapIndex)
    {
        if (DataManager.WeaponIndexIsValid(CurrentlySelectedLoadoutWeapon))
        {
            bDoCompare = TRUE;
            oCompareModValues = DataManager.GetWeaponModValues(CurrentlySelectedLoadoutWeapon, GetCurrentHenchTag());
        }
    }
    oModValues = DataManager.GetWeaponModValues(nWeapIndex, GetCurrentHenchTag());
    fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 0, oModValues, FALSE, fBonus);
    fCompare = bDoCompare ? DataManager.GetWeaponUIStatValue(CurrentlySelectedLoadoutWeapon, 0, oCompareModValues, TRUE) : -1.0;
    AS_AddWeaponStat(UIStrRef(DataManager.StatNameAccuracy), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, fCompare);
    fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 1, oModValues, FALSE, fBonus);
    fCompare = bDoCompare ? DataManager.GetWeaponUIStatValue(CurrentlySelectedLoadoutWeapon, 1, oCompareModValues, TRUE) : -1.0;
    AS_AddWeaponStat(UIStrRef(DataManager.StatNameDamage), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, fCompare);
    fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 2, oModValues, FALSE, fBonus);
    fCompare = bDoCompare ? DataManager.GetWeaponUIStatValue(CurrentlySelectedLoadoutWeapon, 2, oCompareModValues, TRUE) : -1.0;
    AS_AddWeaponStat(UIStrRef(DataManager.StatNameFireRate), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, fCompare);
    fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 3, oModValues, FALSE, fBonus);
    fCompare = bDoCompare ? DataManager.GetWeaponUIStatValue(CurrentlySelectedLoadoutWeapon, 3, oCompareModValues, TRUE) : -1.0;
    AS_AddWeaponStat(UIStrRef(DataManager.StatNameMagSize), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, fCompare);
    fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 4, oModValues, FALSE, fBonus);
    fCompare = bDoCompare ? DataManager.GetWeaponUIStatValue(CurrentlySelectedLoadoutWeapon, 4, oCompareModValues, TRUE) : -1.0;
    AS_AddWeaponStat(UIStrRef(DataManager.StatNameWeight), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, fCompare);
}
public final function ShowMinimumRequiredWeaponsMessage()
{
    local BioSFHandler_MessageBox oMB;
    local BioMessageBoxOptionalParams mbp;
    local string sMessage;
    
    mbp.srAText = MinimumWeaponCountAwknowledgementButtonText;
    mbp.m_SkinType = SFX_MB_Skin.SFX_MB_Skin_User;
    oMB = GetSFXUIController().CreateMessageBox(GetPC());
    if (oMB != None)
    {
        if (nMinimumRequiredWeapons > 1)
        {
            SetCustomToken(0, string(nMinimumRequiredWeapons));
            sMessage = GetUIString(MinimumWeaponCountRequirementPluralMessage, TRUE);
            ClearCustomTokens();
        }
        else
        {
            sMessage = UIStrRef(MinimumWeaponCountRequirementMessage);
        }
        oMB.DisplayMessageBoxEx(sMessage, mbp);
    }
}
public final function SwitchToWeaponLoadout()
{
    local SFXPawn_Player oPlayerPawn;
    
    InWeaponSelection = FALSE;
    if (CurrentlySelectedLoadoutWeapon != CurrentLoadoutWeapons[int(CurrentLoadoutWeaponType)])
    {
        CurrentlySelectedLoadoutWeapon = CurrentLoadoutWeapons[int(CurrentLoadoutWeaponType)];
        oPlayerPawn = SFXPawn_Player(GetBioPawn(-1));
        if (oPlayerPawn != None)
        {
            oPlayerPawn.TransferModsToNewWeapon(EntryWeaponNames, Name(DataManager.WeaponUIData[CurrentlySelectedLoadoutWeapon].ClassPath));
        }
    }
    RefreshLoadoutWeaponDisplay(CurrentLoadoutWeaponType);
    WeaponLoadoutItemChanged(CurrentlySelectedLoadoutWeapon, int(CurrentLoadoutWeaponType));
    if (TeamSelectPawns.Length > 1)
    {
        AS_TeamSetVisible(TRUE);
    }
}
public final function SwitchToWeaponSelection(int nWeaponType)
{
    InWeaponSelection = TRUE;
    if (CurrentlySelectedLoadoutWeapon != -1 && DataManager.WeaponIndexIsValid(CurrentlySelectedLoadoutWeapon) == FALSE)
    {
        PlayGuiError();
        return;
    }
    if (nWeaponType < 0 || nWeaponType >= 6)
    {
        PlayGuiError();
        return;
    }
    CurrentLoadoutWeaponType = byte(nWeaponType);
    CurrentlySelectedSelectionWeapon = CurrentlySelectedLoadoutWeapon;
    CurrentInventoryWeapons = DataManager.GetWeaponsByType(CurrentLoadoutWeaponType, !ShowAllWeapons);
    DisplayCurrentWeaponSelection(FALSE);
    if (TeamSelectPawns.Length > 1)
    {
        AS_TeamSetVisible(FALSE);
    }
}
public final function UndoWeaponSelection()
{
    CurrentLoadoutWeapons[int(CurrentLoadoutWeaponType)] = CurrentlySelectedLoadoutWeapon;
}
public final function UpdateCurrentLoadoutWeaponDisplay()
{
    local int nWeapIndex;
    
    if (int(CurrentLoadoutWeaponType) >= 6)
    {
        nWeapIndex = -1;
    }
    else
    {
        nWeapIndex = CurrentLoadoutWeapons[int(CurrentLoadoutWeaponType)];
    }
    SetWeaponModsDisplay(nWeapIndex);
    SetWeaponStatsDisplay(nWeapIndex);
    SetWeaponInfoDisplay(nWeapIndex, int(CurrentLoadoutWeaponType));
}
public final function UpdateHenchmenDisplay()
{
    local SFXPawn oPawn;
    local int nIndex;
    local string sHenchName;
    local string sIconPath;
    local Texture2D oHenchIcon;
    
    if (TeamSelectPawns.Length <= 1)
    {
        return;
    }
    oPawn = SFXPawn(GetBioPawn(TeamSelectPawns[0]));
    if (oPawn != None)
    {
        AS_SetCurrentNameText(UIStrRef(oPawn.GetPrettyName()));
    }
    for (nIndex = 1; nIndex <= 2 && nIndex < TeamSelectPawns.Length; ++nIndex)
    {
        oPawn = SFXPawn(GetBioPawn(TeamSelectPawns[nIndex]));
        if (oPawn != None)
        {
            oHenchIcon = oPawn.GetGUIIcon();
            sHenchName = UIStrRef(oPawn.GetPrettyName());
            sIconPath = oHenchIcon == None ? "" : PathName(oHenchIcon);
            AS_TeamSetHenchman(nIndex, sHenchName, sIconPath);
        }
    }
}
public final function UpdateUIWorldPawnPosition()
{
    local Rotator rotOffset;
    local Rotator rotFinal;
    local Vector vOffset;
    local Vector vFinal;
    local int N;
    local SFXPawn_PlayerParty oPartyPawn;
    local Actor oUIWorldActor;
    local Name nmAppearanceTag;
    
    oPartyPawn = SFXPawn_PlayerParty(GetBioPawn(CurrentPawnID));
    if (oPartyPawn == None)
    {
        return;
    }
    oUIWorldActor = oWorldInfo.m_UIWorld.GetSpawnedActor(oPartyPawn);
    if (oUIWorldActor == None)
    {
        return;
    }
    oUIWorldActor.bCollideWorld = FALSE;
    oUIWorldActor.SetCollision(FALSE, FALSE, TRUE);
    oUIWorldActor.SetPhysics(7);
    nmAppearanceTag = oPartyPawn.GetUIAppearanceTag();
    if (nmAppearanceTag != 'None')
    {
        for (N = 0; N < AppearancePositions.Length; ++N)
        {
            if (AppearancePositions[N].Tag == nmAppearanceTag)
            {
                rotOffset = AppearancePositions[N].RotationOffset;
                vOffset = AppearancePositions[N].PositionOffset;
            }
        }
    }
    rotFinal = BaseRotationOffset + rotOffset + InitialRotation;
    vFinal = BasePositionOffset + vOffset + InitialPosition;
    oUIWorldActor.SetRotation(rotFinal);
    oUIWorldActor.SetLocation(vFinal, TRUE);
}
public final function UpdateWeaponEncumbranceDisplay()
{
    local SFXPawn_Player oPlayerPawn;
    local int nIndex;
    local int nWeapIndex;
    local SFXWeaponSelectWeaponData oWeapData;
    local float fEncumbrance;
    local int nBarPercent;
    local int nDisplayValue;
    local string sEncumbranceValue;
    local float fAccuracy;
    local float fDamage;
    local float fRoF;
    local float fCapacity;
    local float fWeight;
    local SFXWeaponUIStats WeaponStats;
    
    oPlayerPawn = SFXPawn_Player(GetPC().Pawn);
    if (oPlayerPawn != None && CurrentPawnID == -1)
    {
        for (nIndex = 0; nIndex < 6; ++nIndex)
        {
            nWeapIndex = CurrentLoadoutWeapons[nIndex];
            if (DataManager.WeaponIndexIsValid(nWeapIndex))
            {
                oWeapData = DataManager.WeaponUIData[nWeapIndex];
                DataManager.GetWeaponIniData(oWeapData.ClassPath, FMax(float(oWeapData.Level - 1), 0.0) / (DataManager.MaxWeaponLevel - float(1)), fAccuracy, fDamage, fRoF, fCapacity, fWeight);
                WeaponStats = DataManager.GetWeaponModValues(nWeapIndex, 'None');
                if (WeaponStats.Weight > float(0))
                {
                    fWeight -= fWeight * WeaponStats.Weight;
                }
                if (fWeight + (oPlayerPawn.WeaponEncumbranceModifiers[int(oWeapData.Type)].Value - 1.0) > float(0))
                {
                    fEncumbrance += fWeight + (oPlayerPawn.WeaponEncumbranceModifiers[int(oWeapData.Type)].Value - 1.0);
                }
            }
        }
        nBarPercent = int((fEncumbrance - oPlayerPawn.EncumbranceCapacity) / (oPlayerPawn.EncumbranceMaxCooldown - oPlayerPawn.EncumbranceMinCooldown) * 100.0);
        fEncumbrance = oPlayerPawn.GetWeaponEncumbranceCooldown(fEncumbrance);
        nDisplayValue = FCeil(fEncumbrance * 100.0);
        sEncumbranceValue = (nDisplayValue > 0 ? "+" : "") $ nDisplayValue;
        SetCustomToken(0, sEncumbranceValue);
        sEncumbranceValue = GetUIString(EncumbranceText, TRUE);
        ClearCustomTokens();
        AS_SetWeightDisplay(nBarPercent, -1, UIStrRef(EncumbranceTitle), sEncumbranceValue);
    }
    else
    {
        AS_SetWeightDisplay(-1, -1, "", "");
    }
}
public final function WeaponLoadoutItemChanged(int nID, int nCategory)
{
    CurrentlySelectedLoadoutWeapon = nID;
    CurrentLoadoutWeaponType = byte(nCategory);
    UpdateCurrentLoadoutWeaponDisplay();
}
public final function WeaponSelectionItemChanged()
{
    CurrentLoadoutWeapons[int(CurrentLoadoutWeaponType)] = CurrentlySelectedSelectionWeapon;
    SetWeaponModsDisplay(CurrentlySelectedSelectionWeapon);
    SetWeaponStatsDisplay(CurrentlySelectedSelectionWeapon);
    UpdateWeaponEncumbranceDisplay();
    DisplayCurrentWeaponSelection(TRUE);
}
public final function int WeaponTypeToSlotIndex(ELoadoutWeapons eWeaponType)
{
    switch (eWeaponType)
    {
        case ELoadoutWeapons.LoadoutWeapons_AssaultRifles:
            return 1;
            break;
        case ELoadoutWeapons.LoadoutWeapons_Shotguns:
            return 3;
            break;
        case ELoadoutWeapons.LoadoutWeapons_SniperRifles:
            return 0;
            break;
        case ELoadoutWeapons.LoadoutWeapons_AutoPistols:
            return 2;
            break;
        case ELoadoutWeapons.LoadoutWeapons_HeavyPistols:
            return 4;
            break;
        default:
            break;
    }
    return -1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXWeaponUIDataManager Name=oDataManager
    End Object
    AppearancePositions = ({
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = -30.0, Y = 3.70000005, Z = 0.0}, 
                            Tag = 'FemShep'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = -20.0, Y = 2.79999995, Z = -1.0}, 
                            Tag = 'hench_liara'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = -30.0, Y = 3.70000005, Z = -1.5}, 
                            Tag = 'hench_ashley'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = -50.0, Y = 6.0, Z = -4.0}, 
                            Tag = 'hench_edi'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = 35.0, Y = -3.79999995, Z = -14.8000002}, 
                            Tag = 'hench_garrus'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = 9.0, Y = -1.0, Z = 2.0}, 
                            Tag = 'hench_kaidan'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = 0.0, Y = 0.0, Z = -6.0}, 
                            Tag = 'hench_marine'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = -10.0, Y = 1.0, Z = -4.0}, 
                            Tag = 'hench_prothean'
                           }, 
                           {
                            RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            PositionOffset = {X = -30.0, Y = 3.79999995, Z = -0.100000001}, 
                            Tag = 'hench_tali'
                           }
                          )
    BaseRotationOffset = {Pitch = 0, Yaw = 35350, Roll = 0}
    BasePositionOffset = {X = 60.0, Y = -9.10000038, Z = 41.2000008}
    WeaponLoadoutTitle = $589198
    ChangeWeaponButtonText = $593572
    SelectWeaponButtonText = $593574
    ExitButtonText = $328909
    ReturnToLoadoutText = $600214
    EmptyModSlotText = $618818
    LoadingDataText = $620744
    EmptySlotText = $659926
    EncumbranceText = $715383
    EncumbranceTitle = $715400
    DiscardWeaponMessageText = $716856
    CancelDiscardWeaponButtonText = $168246
    MinimumWeaponCountRequirementMessage = $716904
    MinimumWeaponCountRequirementPluralMessage = $727420
    MinimumWeaponCountAwknowledgementButtonText = $152938
    StatsButtonText = $716160
    DescriptionButtonText = $716159
    WeaponModTitle = $722314
    EquipButtonText = $371717
    MinDisplayBonus = 1.0
    DataManager = oDataManager
    AutoEquipWhenDone = TRUE
    LaunchOnStart = TRUE
    m_bFocusOnStart = TRUE
    m_bRequiresUIWorld = TRUE
}