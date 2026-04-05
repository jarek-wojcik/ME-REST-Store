Class SFXGUI_TeamSelect extends SFXGUIMovie
    config(UI);

const MAX_DISPLAY_WEAPONS = 3;
const MAX_DISPLAY_ABILITIES = 5;

var array<Name> ForceInParty;
var array<Name> ForceOutParty;
var array<Name> DeadToParty;
var array<int> Party;
var delegate<OnRequestExitDelegate> __OnRequestExitDelegate__Delegate;
var SFXGUIData_TeamSelect HenchmenPool;
var SFXGUIData_TeamSelect BaseHenchPool;
var export SFXWeaponUIDataManager DataManager;
var transient bool bIsFinished;
var transient bool bIsAborted;
var transient bool bWasPaused;
var transient bool bNoSelect;

public event function ASNativeReady()
{
    ActionScriptVoid("TeamSelectStage.NativeReady");
}
public event function ASSetTitles(string Title, string AText, string BText, string XText, string YText)
{
    ActionScriptVoid("TeamSelectStage.SetTitles");
}
public function Initialize(SFXGUIData_TeamSelect InitialHenchPool)
{
    HenchmenPool = InitialHenchPool;
    if (HenchmenPool == None)
    {
        bIsAborted = TRUE;
        return;
    }
    ASSetTotalPartySize(GetPartySize());
    SetGameMode(TRUE);
    if (bNoSelect)
    {
        ASRequestNoSelect();
    }
    DataManager.LoadData(OnWeaponUIDataLoaded);
}
public delegate function OnRequestExitDelegate();

public function OnStart()
{
    local SFXGUIInteraction GuiMgr;
    local GUIDependency GD;
    
    Super.OnStart();
    GuiMgr = oWorldInfo.GetLocalPlayerController().GetSFXUIController();
    if (GuiMgr.RetrieveGUIDependent(GuiMgr.MovieTag_PartySelect, GD) == TRUE)
    {
        bNoSelect = GD.OptContext == 1;
    }
    Initialize(BaseHenchPool);
}
public function OnClose()
{
    local SFXGUIInteraction GuiMgr;
    
    SetGameMode(FALSE);
    Super.OnClose();
    ClearDelegates();
    DataManager.Clear();
    DataManager.__OnDataLoadedDelegate__Delegate = None;
    GuiMgr = oWorldInfo.GetLocalPlayerController().GetSFXUIController();
    GuiMgr.RevokeGUIDependency(GuiMgr.MovieTag_PartySelect);
}
public function ClearDelegates()
{
    __OnRequestExitDelegate__Delegate = None;
}
public event function ASAddPartyMember(bool KeepAlive, int MemberId, string MemberName, int State, int Req, bool AvailableAsDLC, int Mission)
{
    ActionScriptVoid("TeamSelectStage.AddPartyMember");
}
public event function ASAddPartyMemberAppearance(int Id, string Selected, string Unselected, bool bCurrentlySelected)
{
    ActionScriptVoid("TeamSelectStage.AddPartyMemberAppearance");
}
public event function ASAddPartyMemberInfo(int HenchmanName, int Ability1, int Ability2, int Ability3, int Ability4, int Ability5, int Rank1, int Rank2, int Rank3, int Rank4, int Rank5, string Weapon1, string Weapon2, string Weapon3, int Dossier)
{
    ActionScriptVoid("TeamSelectStage.AddPartyMemberInfo");
}
public event function ASCancelConfirmation()
{
    ActionScriptVoid("TeamSelectStage.CancelConfirmation");
}
public event function ASRequestNoSelect()
{
    ActionScriptVoid("TeamSelectStage.RequestNoSelect");
}
public event function ASSetSquadSize(int Size)
{
    ActionScriptVoid("TeamSelectStage.SetSquadSize");
}
public function ASSetTotalPartySize(int nPartySize)
{
    ActionScriptVoid("TeamSelectStage.SetTotalPartySize");
}
public function ConfirmParty()
{
    local BioMessageBoxOptionalParams stParams;
    
    stParams.srAText = HenchmenPool.srPartyConfirm;
    stParams.srBText = HenchmenPool.srPartyCancel;
    Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('ConfirmParty', 4, HenchmenPool.srPartyQuestion, stParams, FinalizeParty, 0, GetPC());
}
public function ExitScreen()
{
    if (__OnRequestExitDelegate__Delegate == None)
    {
        GetSFXUIController().HidePartySelect(GetPC());
    }
    else
    {
        __OnRequestExitDelegate__Delegate();
    }
}
public function ExPullAppearances(int HenchId, int IsForcedOut)
{
    local SelectIdentity Hench;
    local AppearanceSet Appearance;
    local Name HenchTag;
    local Name ToeTag;
    local bool IsDead;
    local bool bCurrentlySelected;
    local BioGlobalVariableTable oGV;
    
    oGV = oWorldInfo.GetGlobalVariables();
    foreach HenchmenPool.HenchIdentities(Hench, )
    {
        if (Hench.MemberId == HenchId)
        {
            HenchTag = Hench.MemberTag;
            break;
        }
    }
    IsDead = FALSE;
    if (IsForcedOut != 0)
    {
        foreach DeadToParty(ToeTag, )
        {
            if (ToeTag == HenchTag)
            {
                IsDead = TRUE;
                break;
            }
        }
    }
    foreach HenchmenPool.SelectAppearances(Appearance, )
    {
        if (Appearance.MemberTag == HenchTag && (Appearance.PlotUnlockCID < 1 || oWorldInfo.CheckConditional(Appearance.PlotUnlockCID) == FALSE))
        {
            bCurrentlySelected = oGV.GetIntByName(Appearance.MemberAppearancePlotLabel) == Appearance.MemberAppearanceValue;
            ASAddPartyMemberAppearance(Appearance.AppearanceId, Appearance.HighlightImage, IsDead ? Appearance.DeadImage : IsForcedOut == 1 ? Appearance.SilhouetteImage : Appearance.AvailableImage, bCurrentlySelected);
        }
    }
}
public function ExPullInfos(int HenchId)
{
    local SFXEngine Engine;
    local int nHenchIdendityIndex;
    local int nHenchInfoIndex;
    local int nHenchPowerRecordIndex;
    local int idx;
    local int nWeaponDataManagerIdx;
    local int nCurrWeaponIndex;
    local array<stringref> CurrAbilityDisplayNames;
    local array<string> CurrWeaponDisplayNames;
    local array<int> CurrAbilityRanks;
    local array<PowerSaveRecord> PowerRecords;
    local SFXWeaponSelectWeaponData CurrWeaponUIData;
    local string CurrWeaponName;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    nHenchIdendityIndex = HenchmenPool.HenchIdentities.Find('MemberId', HenchId);
    if (nHenchIdendityIndex < 0)
    {
        return;
    }
    nHenchInfoIndex = HenchmenPool.SelectInfos.Find('MemberTag', HenchmenPool.HenchIdentities[nHenchIdendityIndex].MemberTag);
    if (nHenchInfoIndex < 0)
    {
        return;
    }
    nHenchPowerRecordIndex = Engine.HenchmanRecords.Find('Tag', HenchmenPool.HenchIdentities[nHenchIdendityIndex].MemberTag);
    if (nHenchPowerRecordIndex < 0)
    {
        PowerRecords.Length = 5;
    }
    else
    {
        PowerRecords = Engine.HenchmanRecords[nHenchPowerRecordIndex].Powers;
    }
    CurrAbilityDisplayNames.AddItem(GetPowerDisplayName(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability1ID));
    CurrAbilityRanks.AddItem(GetPowerRank(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability1ID, PowerRecords));
    CurrAbilityDisplayNames.AddItem(GetPowerDisplayName(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability2ID));
    CurrAbilityRanks.AddItem(GetPowerRank(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability2ID, PowerRecords));
    CurrAbilityDisplayNames.AddItem(GetPowerDisplayName(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability3ID));
    CurrAbilityRanks.AddItem(GetPowerRank(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability3ID, PowerRecords));
    CurrAbilityDisplayNames.AddItem(GetPowerDisplayName(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability4ID));
    CurrAbilityRanks.AddItem(GetPowerRank(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability4ID, PowerRecords));
    CurrAbilityDisplayNames.AddItem(GetPowerDisplayName(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability5ID));
    CurrAbilityRanks.AddItem(GetPowerRank(HenchmenPool.SelectInfos[nHenchInfoIndex].Ability5ID, PowerRecords));
    CurrWeaponDisplayNames.Length = 3;
    if (nHenchPowerRecordIndex >= 0)
    {
        nCurrWeaponIndex = 0;
        for (idx = 0; idx < 6; ++idx)
        {
            if (Engine.HenchmanRecords[nHenchPowerRecordIndex].LoadoutWeapons[idx] != 'None')
            {
                CurrWeaponUIData = DataManager.GetWeaponUIDataFromClassPath(Engine.HenchmanRecords[nHenchPowerRecordIndex].LoadoutWeapons[idx], nWeaponDataManagerIdx);
                SetCustomToken(0, string(CurrWeaponUIData.Level));
                CurrWeaponName = GetUIString(CurrWeaponUIData.Name, TRUE);
                ClearCustomTokens();
                CurrWeaponDisplayNames[nCurrWeaponIndex] = CurrWeaponName;
                nCurrWeaponIndex++;
                if (nCurrWeaponIndex >= 3)
                {
                    break;
                }
            }
        }
    }
    ASAddPartyMemberInfo(int(HenchmenPool.HenchIdentities[nHenchIdendityIndex].MemberName), int(CurrAbilityDisplayNames[0]), int(CurrAbilityDisplayNames[1]), int(CurrAbilityDisplayNames[2]), int(CurrAbilityDisplayNames[3]), int(CurrAbilityDisplayNames[4]), CurrAbilityRanks[0], CurrAbilityRanks[1], CurrAbilityRanks[2], CurrAbilityRanks[3], CurrAbilityRanks[4], CurrWeaponDisplayNames[0], CurrWeaponDisplayNames[1], CurrWeaponDisplayNames[2], int(HenchmenPool.HenchIdentities[nHenchIdendityIndex].MemberDossier));
}
public function ExPullParty()
{
    local BioGlobalVariableTable gv;
    local SelectIdentity Identity;
    local bool Restricted;
    local bool Dead;
    local bool ForceIn;
    local bool ForceOut;
    local Name ForceName;
    
    gv = oWorldInfo.GetGlobalVariables();
    foreach HenchmenPool.HenchIdentities(Identity, )
    {
        if (Identity.MemberValidCID > 0 && oWorldInfo.CheckConditional(Identity.MemberValidCID) == FALSE)
        {
            continue;
        }
        Dead = Identity.MemberDeadPlotID > 0 && gv.GetBool(Identity.MemberDeadPlotID) == TRUE;
        Restricted = Dead || Identity.MemberAvailablePlotLabel != 'None' && gv.GetBoolByName(Identity.MemberAvailablePlotLabel) == FALSE;
        ForceIn = !Dead && Restricted && gv.GetBoolByName(Identity.MemberInPartyPlotLabel) == TRUE;
        ForceOut = !ForceIn && (Restricted || Dead);
        if (Dead)
        {
            DeadToParty.AddItem(Identity.MemberTag);
        }
        if (!Restricted)
        {
            foreach ForceInParty(ForceName, )
            {
                if (Identity.MemberTag == ForceName)
                {
                    ForceIn = TRUE;
                    break;
                }
            }
            if (!ForceIn)
            {
                foreach ForceOutParty(ForceName, )
                {
                    if (Identity.MemberTag == ForceName)
                    {
                        ForceOut = TRUE;
                        break;
                    }
                }
            }
        }
        ASAddPartyMember(TRUE, Identity.MemberId, GetUIString(Identity.MemberName), Restricted == FALSE ? 2 : 1, ForceIn == TRUE ? 1 : ForceOut == TRUE ? 2 : 0, FALSE, 0);
    }
    ASAddPartyMember(FALSE, -1, "", -1, -1, FALSE, -1);
}
public function ExPullSquadSize()
{
    ASSetSquadSize(2);
}
public function ExPullTitles()
{
    ASSetTitles(GetUIString(HenchmenPool.srSelectTitle), GetUIString(HenchmenPool.srDefaultAButtonText), GetUIString(HenchmenPool.srDefaultBButtonText), GetUIString(HenchmenPool.srDefaultXButtonText), GetUIString(HenchmenPool.srDefaultYButtonText));
}
public function ExSelectAppearance(int HenchId, int AppearanceId)
{
    local AppearanceSet Appearance;
    local BioGlobalVariableTable oGV;
    
    oGV = oWorldInfo.GetGlobalVariables();
    foreach HenchmenPool.SelectAppearances(Appearance, )
    {
        if (Appearance.AppearanceId == AppearanceId)
        {
            oGV.SetIntByName(Appearance.MemberAppearancePlotLabel, Appearance.MemberAppearanceValue);
            break;
        }
    }
    oWorldInfo.ForceGarbageCollection();
}
public function ExSelectParty(int HenchId1, int HenchId2)
{
    Party.Length = 0;
    Party.AddItem(HenchId1);
    Party.AddItem(HenchId2);
    ConfirmParty();
}
public function FinalizeParty(bool bAPressed, int nContext)
{
    local BioGlobalVariableTable oGV;
    local SelectIdentity Hench;
    local int InPartyMemberId;
    
    if (bAPressed)
    {
        oGV = oWorldInfo.GetGlobalVariables();
        foreach HenchmenPool.HenchIdentities(Hench, )
        {
            oGV.SetBoolByName(Hench.MemberInPartyPlotLabel, FALSE);
        }
        foreach Party(InPartyMemberId, )
        {
            if (InPartyMemberId > -1)
            {
                foreach HenchmenPool.HenchIdentities(Hench, )
                {
                    if (InPartyMemberId == Hench.MemberId)
                    {
                        oGV.SetBoolByName(Hench.MemberInPartyPlotLabel, TRUE);
                        Class'SFXTelemetry'.static.SendName('TelemetryHook_SelectHenchman', Hench.MemberTag);
                        break;
                    }
                }
            }
        }
        ExitScreen();
    }
    else
    {
        ASCancelConfirmation();
    }
}
public function ForceIn(Name HenchTag)
{
    ForceInParty.AddItem(HenchTag);
}
public function ForceOut(Name HenchTag)
{
    ForceOutParty.AddItem(HenchTag);
}
private final function string GetAppearanceBonus(int AppearanceId)
{
    local int nAppearanceIndex;
    local int idx;
    local string DescriptionString;
    
    DescriptionString = "";
    nAppearanceIndex = HenchmenPool.SelectAppearances.Find('AppearanceId', AppearanceId);
    if (nAppearanceIndex >= 0)
    {
        for (idx = 0; idx < HenchmenPool.SelectAppearances[nAppearanceIndex].DescriptionText.Length; idx++)
        {
            ClearCustomTokens();
            if (idx < HenchmenPool.SelectAppearances[nAppearanceIndex].CustomToken0.Length)
            {
                SetCustomToken(0, string(HenchmenPool.SelectAppearances[nAppearanceIndex].CustomToken0[idx]));
            }
            else
            {
                SetCustomToken(0, "");
            }
            SetCustomToken(1, DescriptionString);
            DescriptionString = GetUIString(HenchmenPool.SelectAppearances[nAppearanceIndex].DescriptionText[idx], TRUE);
            ClearCustomTokens();
        }
        return DescriptionString;
    }
    return "";
}
public function string GetInfoPanelCloseButtonText()
{
    return GetUIString(HenchmenPool.srInfoExit);
}
public function int GetPartySize()
{
    local int nPartySize;
    local SelectIdentity Identity;
    
    nPartySize = 0;
    foreach HenchmenPool.HenchIdentities(Identity, )
    {
        if (Identity.MemberValidCID > 0 && oWorldInfo.CheckConditional(Identity.MemberValidCID) == FALSE)
        {
            continue;
        }
        nPartySize++;
    }
    return nPartySize;
}
private final function stringref GetPowerDisplayName(int PowerID)
{
    local int nPowerIndex;
    
    nPowerIndex = HenchmenPool.PowerInfos.Find('PowerInfoID', PowerID);
    if (nPowerIndex < 0)
    {
        return $0;
    }
    return HenchmenPool.PowerInfos[nPowerIndex].DisplayName;
}
private final function int GetPowerRank(int PowerID, out array<PowerSaveRecord> PowerData)
{
    local int nPowerIndex;
    local int nPowerDataIndex;
    
    nPowerIndex = HenchmenPool.PowerInfos.Find('PowerInfoID', PowerID);
    if (nPowerIndex < 0)
    {
        return 0;
    }
    nPowerDataIndex = PowerData.Find('PowerName', HenchmenPool.PowerInfos[nPowerIndex].PowerName);
    if (nPowerDataIndex < 0)
    {
        return 0;
    }
    return int(PowerData[nPowerDataIndex].CurrentRank);
}
public final function OnWeaponUIDataLoaded()
{
    ASNativeReady();
}
public function SetOnRequestExitCallback(delegate<OnRequestExitDelegate> fn_OnRequestExitDelegate)
{
    __OnRequestExitDelegate__Delegate = fn_OnRequestExitDelegate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXGUIData_TeamSelect Name=SelectData
    End Object
    Begin Object Class=SFXWeaponUIDataManager Name=oDataManager
    End Object
    BaseHenchPool = SelectData
    DataManager = oDataManager
    m_bFocusOnStart = TRUE
}