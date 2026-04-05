Class SFXGUI_SquadRecord extends SFXGUIMovieLegacyAdapter
    config(UI);

const DEFAULT_INITIAL_HIDDEN_TIMER = 0.1;
struct EvoDetails 
{
    var string Name;
    var string Desc;
    var int State;
    var int Cost;
};
struct PowerDetails 
{
    var string Name;
    var string Desc;
    var string Resource;
    var int State;
    var int IconFrame;
};
struct CharDetails 
{
    var string CharName;
    var string Face;
    var string Abbrev;
    var string Thumb;
    var string XP;
    var string PrettyLevel;
    var string ShieldTitle;
    var stringref CharClass;
    var int allocated;
    var int Spendable;
    var int Level;
    var int PctToLevel;
    var int Health;
    var int Shield;
    var int Pgn;
    var int Rng;
};
enum EvolutionStateEnum
{
    STATE_LOCKED,
    STATE_BUYABLE,
    STATE_BOUGHT,
};
enum PowerStateEnum
{
    STATE_LOCKED,
    STATE_UNLOCKED,
};

var config array<float> m_ParagonRenegadeBarValues;
var transient array<SFXPowerCustomActionBase> PowerCache;
var transient array<stringref> m_SquadNames;
var transient array<Texture> m_SquadIcons;
var transient array<int> m_bPowerLockedStatus;
var transient array<SFXPawn> m_SpawnedSquadMembersSource;
var array<delegate<OnNewTutorialCallback>> Tutorials;
var delegate<OnNewTutorialCallback> __OnNewTutorialCallback__Delegate;
var delegate<OnDoneTutorialsCallback> __OnDoneTutorialsCallback__Delegate;
var delegate<OnCloseCallback> __OnCloseCallback__Delegate;
var transient BioWorldInfo m_WorldInfo;
var transient int m_CurrentPawnIndex;
var transient float m_fScrollValue;
var transient SFXPowerLevelUpHelper m_Helper;
var int m_RespecMemberIndex;
var transient int m_nUIWorldProcessingFrames;
var transient float m_InitialHiddenTimer;
var config stringref m_srXPFormat;
var config stringref m_srSpendTalentPointsMessageXBox;
var config stringref m_srParagonRenegadeMessageXBox;
var config stringref m_srSpendTalentPointsMessagePC;
var config stringref m_srParagonRenegadeMessagePC;
var config stringref m_srSpendTalentPointsMessagePS3;
var config stringref m_srParagonRenegadeMessagePS3;
var config stringref m_srOk;
var config stringref m_srRespecMessage;
var config stringref m_srRespecCancel;
var config stringref m_srShepardLevelClassFormat;
var config stringref m_srTalentDescriptionFormat;
var config stringref m_srRequiredLevelFormat;
var config stringref m_srRankDescriptionFormat;
var config stringref m_srFaceCodeFormat;
var config stringref m_srCostTokenFormat;
var config stringref m_srCantBuyLocked;
var config stringref m_srCantBuyCost;
var config stringref m_srCantBuyBought;
var config stringref m_srCantBuyRank;
var config stringref m_srExitText;
var config stringref m_srCostText;
var config stringref m_srScarHint;
var config stringref m_AText;
var config stringref m_BText;
var config stringref m_XText;
var config stringref m_YText;
var transient bool m_bCloseGUIButtonPressed;
var transient bool m_bFinished;
var transient bool m_bCheckingNotifications;

public event function ASNativeReady()
{
    ActionScriptVoid("SquadRecordStage.NativeReady");
}
public event function ASSetTitles(string sTitle, string sAText, string sBText, string sXText, string sYText, string sExitText)
{
    ActionScriptVoid("SquadRecordStage.SetTitles");
}
private final function AutoLevelUp()
{
    m_Helper.AutoLevelUp();
}
public function HandleEvent(byte nCommand, const out array<string> Parameters);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    if (Event == BioGuiEvents.BIOGUI_EVENT_BUTTON_B || Event == BioGuiEvents.BIOGUI_EVENT_BUTTON_START)
    {
        oWorldInfo.GetInputLock(-1.0);
        m_bCloseGUIButtonPressed = TRUE;
    }
    else if (m_bCloseGUIButtonPressed || oWorldInfo.GetGuiInputPermission(Event) == FALSE)
    {
        return FALSE;
    }
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            ProcessRStickAxisInput(fValue);
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public delegate function OnCloseCallback();

public function OnPanelAdded()
{
    local SFXGame oGame;
    
    Super.OnPanelAdded();
    if (oPanel == None)
    {
        m_bFinished = TRUE;
        if (__OnCloseCallback__Delegate != None)
        {
            __OnCloseCallback__Delegate();
        }
        return;
    }
    oPanel.SetExternalInterface(Self);
    oPanel.m_bApplyRightThumbstickDeadzone = TRUE;
    oGame = SFXGame(Class'Engine'.static.GetCurrentWorldInfo().Game);
    if (oGame != None && oGame.bShowSquadScreenMessageBoxes)
    {
        Tutorials.AddItem(Tutorial_BuildPoints);
        Tutorials.AddItem(Tutorial_ParagonRenegade);
    }
    __OnDoneTutorialsCallback__Delegate = InitializeSquadRecord;
    NextTutorial();
}
public function OnPanelRemoved()
{
    local SFXPawn SourcePawn;
    
    Super.OnPanelRemoved();
    if (m_WorldInfo != None)
    {
        if (m_Helper != None && m_Helper.m_Pawn != None)
        {
            if (m_WorldInfo.EventNotifier != None)
            {
                m_WorldInfo.EventNotifier.RemoveTalentNotify(m_Helper.m_Pawn);
            }
        }
        if (m_WorldInfo.m_UIWorld != None)
        {
            foreach m_SpawnedSquadMembersSource(SourcePawn, )
            {
                m_WorldInfo.m_UIWorld.CleanupPawn(SourcePawn);
            }
        }
    }
    m_WorldInfo = None;
    m_CurrentPawnIndex = 0;
    m_fScrollValue = 0.0;
    m_bCloseGUIButtonPressed = FALSE;
    m_SquadNames.Length = 0;
    __OnCloseCallback__Delegate = None;
    m_Helper = None;
}
public function Update(float fDeltaT)
{
    if (m_bCheckingNotifications)
    {
        if (m_WorldInfo.EventNotifier.PendingTalentNotify(m_Helper.m_Pawn))
        {
            m_WorldInfo.EventNotifier.ShowTalentNotify(m_Helper.m_Pawn);
        }
        else
        {
            m_bCheckingNotifications = FALSE;
            ASOnCloseNotifications();
        }
    }
    if (m_Helper != None && m_Helper.m_Pawn != None && m_InitialHiddenTimer > 0.0)
    {
        m_InitialHiddenTimer -= fDeltaT;
        if (m_InitialHiddenTimer <= 0.0)
        {
            m_WorldInfo.m_UIWorld.HidePawn(m_Helper.m_Pawn, FALSE);
        }
    }
    if (m_nUIWorldProcessingFrames > 0)
    {
        m_nUIWorldProcessingFrames--;
        if (m_nUIWorldProcessingFrames < 1)
        {
            ASOnUIWorldProcessed();
        }
    }
}
private final function ApplyCustomization(Object InData)
{
    local SFXPawn_Player PlayerPawn;
    local Actor SpawnedActor;
    
    PlayerPawn = SFXPawn_Player(InData);
    if (PlayerPawn != None)
    {
        SpawnedActor = m_WorldInfo.m_UIWorld.GetSpawnedActor(PlayerPawn);
        if (SpawnedActor != None)
        {
            PlayerPawn.ApplyCustomizationToActor(SpawnedActor);
        }
    }
}
public event function ASAddCharacter(bool KeepAlive, int MemberIdx, string CharName, string CharClass, string Face, string Abbrev, string Thumb, int allocated, int Spendable, string XP, int Level, string PrettyLevel, int PctToLevel, int Health, int Shield, string ShieldTitle, int Pgn, int Rng)
{
    ActionScriptVoid("SquadRecordStage.AddCharacter");
}
public event function ASAddCharacterPower(string PowerName, string Desc, int State, int IconFrame, string Resource)
{
    ActionScriptVoid("SquadRecordStage.AddCharacterPower");
}
public event function ASAddEvoStat(string Title, int Pct, string TotalTitle, int BonusPct)
{
    ActionScriptVoid("SquadRecordStage.AddEvoStat");
}
public event function ASAddPowerEvo(string EvoName, string Desc, int EvoRank, int EvoFile, int State, int Cost)
{
    ActionScriptVoid("SquadRecordStage.AddPowerEvo");
}
public event function ASOnCloseNotifications()
{
    ActionScriptVoid("SquadRecordStage.onCloseNotifications");
}
public event function ASOnUIWorldProcessed()
{
    ActionScriptVoid("SquadRecordStage.onUIWorldProcessed");
}
public event function ASPostRefresh()
{
    ActionScriptVoid("SquadRecordStage.PostRefresh");
}
public event function ASRefreshCharData(int CharIdx, int MemberIdx, string CharName, string CharClass, string Face, string Abbrev, string Thumb, int allocated, int Spendable, string XP, int Level, string PrettyLevel, int PctToLevel, int Health, int Shield, string ShieldTitle, int Pgn, int Rng, bool bUseNewAllocatedPoints)
{
    ActionScriptVoid("SquadRecordStage.RefreshCharData");
}
public function ASRefreshDataAfterRespec(int nCharIndex)
{
    ActionScriptVoid("SquadRecordStage.RefreshAllCharacterData");
}
public event function ASRefreshEvoData(int EvoIdx, string EvoName, string Desc, int RankIdx, int FileIdx, int State, int Cost)
{
    ActionScriptVoid("SquadRecordStage.RefreshEvoData");
}
public event function ASRefreshPowerData(int PowerIdx, string PowerName, string Desc, int State, int IconFrame, string Resource)
{
    ActionScriptVoid("SquadRecordStage.RefreshPowerData");
}
public event function ASRefreshStatData(int StatIdx, string Title, int Pct, string TotalTitle, int BonusPct)
{
    ActionScriptVoid("SquadRecordStage.RefreshStatData");
}
public function CantBuy(stringref Explanation)
{
    Class'SFXGUIInteraction'.static.GetInstance().ShowHint(Explanation, 6.0, 0, 0);
}
private final function bool ChangeToCharacter(BioPawn NextCharacter)
{
    local BioGlobalVariableTable VarTable;
    local SFXEngine Engine;
    local SFXPawn_Player Player;
    
    if (m_WorldInfo == None || m_WorldInfo.m_UIWorld == None)
    {
        return FALSE;
    }
    if (NextCharacter == None)
    {
        return FALSE;
    }
    m_Helper.SetPawn(NextCharacter);
    if (ShouldShowMultiplayerCharacter() || m_WorldInfo.m_playerSquad == None)
    {
        m_CurrentPawnIndex = 0;
    }
    else
    {
        m_CurrentPawnIndex = m_SpawnedSquadMembersSource.Find(m_Helper.m_Pawn);
    }
    if (ShouldShowMultiplayerCharacter() == FALSE)
    {
        Engine = Class'SFXEngine'.static.GetSFXEngine();
        Player = SFXPawn_Player(m_Helper.m_Pawn);
        if (Engine != None && Player != None && Engine.GetPlayerVariable('ShownScarHint') == 0)
        {
            VarTable = m_WorldInfo.GetGlobalVariables();
            if (Player.CalculateScarIndex(FALSE, Player.GetCharmSkill(), Player.GetIntimidateSkill(), Player.GetReputationSkill()) < Class'SFXPlayerCustomization'.default.Scars.Length - 1 && (VarTable == None || VarTable.GetBool(Class'SFXPlayerCustomization'.default.CosmeticSurgeryPlotID) == FALSE && VarTable.GetBool(Class'SFXPlayerCustomization'.default.CosmeticSUrgeryPlotID_ME3) == FALSE))
            {
                Class'SFXGUIInteraction'.static.GetInstance().ShowHint(m_srScarHint, 6.0, 0, 0);
                Engine.SetPlayerVariable('ShownScarHint', 1);
            }
        }
    }
    m_WorldInfo.m_UIWorld.TriggerEvent('SetupCharRec', m_WorldInfo);
    if (m_InitialHiddenTimer <= 0.0)
    {
        m_WorldInfo.m_UIWorld.HidePawn(m_Helper.m_Pawn, FALSE);
    }
    PlayGuiSound('ChangeCharacter');
    return TRUE;
}
private final function CleanupCharacter()
{
    if (m_WorldInfo == None || m_WorldInfo.m_UIWorld == None)
    {
        return;
    }
    m_WorldInfo.m_UIWorld.HidePawn(m_Helper.m_Pawn, TRUE);
    if (SFXPawn_Player(m_Helper.m_Pawn) != None)
    {
        SFXPawn_Player(m_Helper.m_Pawn).AutoMap();
    }
}
public function int EvoChoiceIndex(int nRankIndex, int nFileIndex)
{
    return (nRankIndex - 3) * 2 + (nFileIndex - 1);
}
public function ExAutoLevelUp()
{
    AutoLevelUp();
}
public function ExBuyRank(int nPowerIndex, int nRankIndex, int nEvoIndex)
{
    PurchasePowerRank(nPowerIndex, nRankIndex, nEvoIndex);
}
public function ExCancelHint()
{
    Class'SFXGUIInteraction'.static.GetInstance().CancelHint();
}
public function ExCantBuyBought()
{
    CantBuy(m_srCantBuyBought);
}
public function ExCantBuyCost()
{
    CantBuy(m_srCantBuyCost);
}
public function ExCantBuyLocked()
{
    CantBuy(m_srCantBuyLocked);
}
public function ExCantBuyRank()
{
    CantBuy(m_srCantBuyRank);
}
public function ExCommit()
{
    CleanupCharacter();
}
public function ExOpenNotifications()
{
    if (m_Helper != None && m_Helper.m_Pawn != None && m_WorldInfo != None && m_WorldInfo.EventNotifier != None)
    {
        m_bCheckingNotifications = TRUE;
    }
    else
    {
        ASOnCloseNotifications();
    }
}
public function ExPullCharacters()
{
    local SFXGRI GRI;
    local BioPlayerController oController;
    local CharDetails MemberDetails;
    local SFXPawn MemberPawn;
    local SFXPawn_Player PlayerPawn;
    local int MemberIdx;
    local int PlayerLevel;
    
    if (oWorldInfo != None)
    {
        oController = oWorldInfo.GetLocalPlayerController();
    }
    foreach m_SpawnedSquadMembersSource(MemberPawn, )
    {
        PlayerPawn = SFXPawn_Player(MemberPawn);
        if (PlayerPawn != None)
        {
            break;
        }
    }
    if (PlayerPawn == None)
    {
        ASAddCharacter(FALSE, -1, "", "", "", "", "", -1, -1, "", -1, "", -1, -1, -1, "", -1, -1);
        return;
    }
    GRI = oWorldInfo != None ? SFXGRI(oWorldInfo.GRI) : None;
    if (GRI == None)
    {
        if (PlayerPawn == None)
        {
            return;
        }
        PlayerLevel = PlayerPawn.CharacterLevel;
    }
    else
    {
        GRI.GetPlayerLevel(LocalPlayer(oController.Player).ControllerId, PlayerLevel);
    }
    MemberIdx = 0;
    foreach m_SpawnedSquadMembersSource(MemberPawn, )
    {
        PrepMemberDetails(MemberPawn, MemberDetails);
        ASAddCharacter(TRUE, MemberIdx, MemberDetails.CharName, GetUIString(MemberDetails.CharClass), MemberDetails.Face, MemberDetails.Abbrev, MemberDetails.Thumb, MemberDetails.allocated, MemberDetails.Spendable, MemberDetails.XP, MemberDetails.Level, MemberDetails.PrettyLevel, MemberDetails.PctToLevel, MemberDetails.Health, MemberDetails.Shield, MemberDetails.ShieldTitle, MemberDetails.Pgn, MemberDetails.Rng);
        MemberIdx++;
    }
    ASAddCharacter(FALSE, -1, "", "", "", "", "", -1, -1, "", -1, "", -1, -1, -1, "", -1, -1);
}
public function ExPullEvoStats(int MemberIdx, int PowerIdx, int RankIdx, int FileIdx)
{
    local SFXPawn MemberPawn;
    local array<SFXPowerCustomActionBase> MemberPowers;
    local SFXPowerCustomActionBase Power;
    local PowerEvolveStatDetails Details;
    local int BarIdx;
    
    MemberPawn = m_SpawnedSquadMembersSource[MemberIdx];
    MemberPawn.PowerManager.GetSquadRecordPowers(MemberPowers);
    Power = MemberPowers[PowerIdx];
    Power.PopulatePowerStatBarEvolves();
    for (BarIdx = 0; Power.GetPowerStatBarData(RankIdx - 1, FileIdx, BarIdx, Details); BarIdx++)
    {
        ASAddEvoStat(Details.Title, Details.Pct, Details.TotalTitle, Details.BonusPct);
    }
}
public function ExPullPowerEvos(int MemberIdx, int PowerIdx)
{
    local SFXPawn MemberPawn;
    local array<SFXPowerCustomActionBase> MemberPowers;
    local SFXPowerCustomActionBase Power;
    local int RankIdx;
    local EvoDetails Details;
    
    MemberPawn = m_SpawnedSquadMembersSource[MemberIdx];
    MemberPawn.PowerManager.GetSquadRecordPowers(MemberPowers);
    Power = MemberPowers[PowerIdx];
    for (RankIdx = 0; RankIdx < Power.Ranks.Length; RankIdx++)
    {
        PrepEvoDetails(MemberPawn, Power, RankIdx, 1, Details);
        ASAddPowerEvo(Details.Name, Details.Desc, RankIdx + 1, 1, Details.State, Details.Cost);
        if (RankIdx > 2)
        {
            PrepEvoDetails(MemberPawn, Power, RankIdx, 2, Details);
            ASAddPowerEvo(Details.Name, Details.Desc, RankIdx + 1, 2, Details.State, Details.Cost);
        }
    }
}
public function ExPullPowers(int MemberIdx)
{
    local SFXPawn MemberPawn;
    local array<SFXPowerCustomActionBase> MemberPowers;
    local SFXPowerCustomActionBase Power;
    local PowerDetails Details;
    
    MemberPowers.Length = 0;
    MemberPawn = m_SpawnedSquadMembersSource[MemberIdx];
    MemberPawn.PowerManager.GetSquadRecordPowers(MemberPowers);
    foreach MemberPowers(Power, )
    {
        PrepPowerDetails(MemberPawn, Power, Details);
        ASAddCharacterPower(Details.Name, Details.Desc, Details.State, Details.IconFrame, Details.Resource);
    }
}
public function ExPullTitles()
{
    local string Title;
    
    Title = "$340882";
    ASSetTitles(Title, GetUIString(m_AText), GetUIString(m_BText), GetUIString(m_XText), GetUIString(m_YText), GetUIString(m_srExitText));
}
public function ExRefreshCharData(int BackRef, int CharRef, int PowerRef, int RankRef, int FileRef, int BarRef, bool bUseNewAllocatedPoints)
{
    local CharDetails MemberDetails;
    
    PrepMemberDetails(m_SpawnedSquadMembersSource[CharRef], MemberDetails);
    ASRefreshCharData(BackRef, CharRef, MemberDetails.CharName, GetUIString(MemberDetails.CharClass), MemberDetails.Face, MemberDetails.Abbrev, MemberDetails.Thumb, MemberDetails.allocated, MemberDetails.Spendable, MemberDetails.XP, MemberDetails.Level, MemberDetails.PrettyLevel, MemberDetails.PctToLevel, MemberDetails.Health, MemberDetails.Shield, MemberDetails.ShieldTitle, MemberDetails.Pgn, MemberDetails.Rng, bUseNewAllocatedPoints);
}
public function ExRefreshEvoData(int BackRef, int CharRef, int PowerRef, int RankRef, int FileRef, int BarRef)
{
    local SFXPawn MemberPawn;
    local array<SFXPowerCustomActionBase> MemberPowers;
    local SFXPowerCustomActionBase Power;
    local EvoDetails Details;
    
    MemberPowers.Length = 0;
    MemberPawn = m_SpawnedSquadMembersSource[CharRef];
    MemberPawn.PowerManager.GetSquadRecordPowers(MemberPowers);
    Power = MemberPowers[PowerRef];
    PrepEvoDetails(MemberPawn, Power, RankRef - 1, FileRef, Details);
    ASRefreshEvoData(BackRef, Details.Name, Details.Desc, RankRef, FileRef, Details.State, Details.Cost);
}
public function ExRefreshPowerData(int BackRef, int CharRef, int PowerRef, int RankRef, int FileRef, int BarRef)
{
    local SFXPawn MemberPawn;
    local array<SFXPowerCustomActionBase> MemberPowers;
    local SFXPowerCustomActionBase Power;
    local PowerDetails Details;
    
    MemberPowers.Length = 0;
    MemberPawn = m_SpawnedSquadMembersSource[CharRef];
    MemberPawn.PowerManager.GetSquadRecordPowers(MemberPowers);
    Power = MemberPowers[PowerRef];
    PrepPowerDetails(MemberPawn, Power, Details);
    ASRefreshPowerData(BackRef, Details.Name, Details.Desc, Details.State, Details.IconFrame, Details.Resource);
}
public function ExRefreshStatData(int BackRef, int CharRef, int PowerRef, int RankRef, int FileRef, int BarRef)
{
    local SFXPawn MemberPawn;
    local array<SFXPowerCustomActionBase> MemberPowers;
    local SFXPowerCustomActionBase Power;
    local PowerEvolveStatDetails Details;
    
    MemberPowers.Length = 0;
    MemberPawn = m_SpawnedSquadMembersSource[CharRef];
    MemberPawn.PowerManager.GetSquadRecordPowers(MemberPowers);
    Power = MemberPowers[PowerRef];
    Power.PopulatePowerStatBarEvolves();
    if (Power.GetPowerStatBarData(RankRef - 1, FileRef, BarRef, Details) == TRUE)
    {
        ASRefreshStatData(BackRef, Details.Title, Details.Pct, Details.TotalTitle, Details.BonusPct);
    }
    else
    {
        ASPostRefresh();
    }
}
public function ExRespecTalents(int MemberIdx)
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local string RespecMessage;
    local int nNumRespecCardsAfterUse;
    local int nNumRespecCards;
    
    nNumRespecCards = GetNumMPRespecCards();
    if (nNumRespecCards > 0)
    {
        m_RespecMemberIndex = MemberIdx;
        nNumRespecCardsAfterUse = nNumRespecCards - 1;
        SetCustomToken(0, string(nNumRespecCardsAfterUse));
        RespecMessage = GetUIString(m_srRespecMessage, TRUE);
        ClearCustomTokens();
        Params.srAText = m_srOk;
        Params.srBText = m_srRespecCancel;
        messageBox = GetSFXUIController().CreateMessageBox(GetPC());
        messageBox.SetInputDelegate(OnRespecMessageBoxConfirm);
        messageBox.DisplayMessageBoxEx(RespecMessage, Params);
    }
    else
    {
        PlayGuiError();
    }
}
public function ExShutdownRecord()
{
    m_bFinished = TRUE;
    if (__OnCloseCallback__Delegate != None)
    {
        __OnCloseCallback__Delegate();
    }
    else
    {
        Close();
    }
}
public function ExSnapCharacterFocus(int MemberIdx)
{
    if (MemberIdx == m_CurrentPawnIndex || MemberIdx < 0 || MemberIdx >= m_SpawnedSquadMembersSource.Length)
    {
        ASOnUIWorldProcessed();
        return;
    }
    CleanupCharacter();
    if (ChangeToCharacter(m_SpawnedSquadMembersSource[MemberIdx]) == FALSE)
    {
    }
    m_nUIWorldProcessingFrames = 2;
}
public function ExToggleHelmet(int MemberIdx)
{
    local SFXPawn_PlayerParty HelmetablePawn;
    
    if (MemberIdx < 0 || MemberIdx >= m_SpawnedSquadMembersSource.Length)
    {
        ASOnUIWorldProcessed();
        return;
    }
    HelmetablePawn = SFXPawn_PlayerParty(m_SpawnedSquadMembersSource[MemberIdx]);
    if (HelmetablePawn == None)
    {
        ASOnUIWorldProcessed();
        return;
    }
    m_nUIWorldProcessingFrames = 2;
}
public function ExUndo()
{
    m_Helper.UndoChanges();
}
private final function bool GetExperienceProgress(out int BaseXP, out int CurrentXP, out int TargetXP)
{
    local PlayerController PC;
    local SFXPawn_Player Player;
    local SFXGRI GRI;
    
    PC = GetPC();
    Player = PC != None ? SFXPawn_Player(PC.Pawn) : None;
    if (Player != None)
    {
        GRI = SFXGRI(Player.WorldInfo.GRI);
        if (Player.CharacterLevel >= GRI.DifficultyHandler.MaxPlayerLevel)
        {
            return FALSE;
        }
        if (Class'BioLevelUpSystem'.static.GetXPNeededForLevel(Player.CharacterLevel, BaseXP) == FALSE)
        {
            return FALSE;
        }
        CurrentXP = int(Player.TotalXP);
        if (Class'BioLevelUpSystem'.static.GetXPNeededForLevel(Player.CharacterLevel + 1, TargetXP) == FALSE)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function int GetNumMPRespecCards()
{
    local SFXEngine Engine;
    local SFXSaveManagerMP MPSaveManager;
    
    if (!ShouldShowMultiplayerCharacter())
    {
        return 0;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return 0;
    }
    MPSaveManager = Engine.MPSaveManager;
    if (MPSaveManager == None || !MPSaveManager.bInitialized)
    {
        return 0;
    }
    return MPSaveManager.GetPlayerVariable('MPRespec');
}
private final function InitializeSquadRecord()
{
    local int nIndex;
    local int nSquadSize;
    local BioPawn oPawn;
    local array<BioPawn> lstPawnsToUse;
    local int nFrontOfTheLine;
    local SFXPawn_Player PlayerPawn;
    local Actor TargetActor;
    local SFXPawn SquadMember;
    
    m_InitialHiddenTimer = 0.100000001;
    m_WorldInfo = oWorldInfo;
    if (m_WorldInfo == None)
    {
        return;
    }
    if (m_WorldInfo.m_playerSquad == None && m_WorldInfo.LocalPlayerController.Pawn == None)
    {
        return;
    }
    m_Helper = new (Self) Class'SFXPowerLevelUpHelper';
    if (m_Helper == None)
    {
        return;
    }
    m_Helper.Initialize(m_WorldInfo);
    m_Helper.SaveCurrentPowerStates();
    if (ShouldShowMultiplayerCharacter() || !SFXGRI(oWorldInfo.GRI).bCanSpawnHenchmen || m_WorldInfo.m_playerSquad == None)
    {
        if (m_WorldInfo.LocalPlayerController.Pawn != None)
        {
            nSquadSize = 1;
            lstPawnsToUse.AddItem(SFXPawn(m_WorldInfo.LocalPlayerController.Pawn));
        }
    }
    else
    {
        nSquadSize = m_WorldInfo.m_playerSquad.Members.Length;
        for (nIndex = 0; nIndex < nSquadSize; nIndex++)
        {
            SquadMember = SFXPawn(m_WorldInfo.m_playerSquad.Members[nIndex]);
            if (SquadMember != None)
            {
                lstPawnsToUse.AddItem(SquadMember);
            }
        }
        nSquadSize = lstPawnsToUse.Length;
    }
    nFrontOfTheLine = 0;
    for (nIndex = 0; nIndex < nSquadSize; nIndex++)
    {
        oPawn = lstPawnsToUse[nIndex];
        if (lstPawnsToUse[nIndex].TalentPoints > 0)
        {
            nFrontOfTheLine = nIndex;
            break;
            continue;
        }
        if (nFrontOfTheLine < 1 && m_WorldInfo.EventNotifier.PendingTalentNotify(oPawn))
        {
            nFrontOfTheLine = nIndex;
        }
    }
    for (nIndex = nFrontOfTheLine; nIndex < nFrontOfTheLine + lstPawnsToUse.Length; nIndex++)
    {
        oPawn = lstPawnsToUse[nIndex %  lstPawnsToUse.Length];
        m_SpawnedSquadMembersSource.AddItem(oPawn);
        m_WorldInfo.m_UIWorld.SpawnPawn(oPawn, 'CharRecSpawnPoint', 'CharRecPawn', None, 'None', 4 | 8);
        PlayerPawn = SFXPawn_Player(oPawn);
        if (PlayerPawn != None)
        {
            m_WorldInfo.m_UIWorld.AddDeferredOperation(ApplyCustomization, PlayerPawn);
        }
        if (ShouldShowMultiplayerCharacter())
        {
            TargetActor = oWorldInfo.m_UIWorld.GetSpawnedActor(oPawn);
            if (TargetActor != None)
            {
                TargetActor.SetLocation(m_UIWorldMPPawnInitialLocation, );
                TargetActor.SetRotation(m_UIWorldMPPawnInitialRotation);
            }
        }
    }
    m_CurrentPawnIndex = -1;
    ASNativeReady();
}
public function NextTutorial()
{
    if (Tutorials.Length > 0)
    {
        __OnNewTutorialCallback__Delegate = Tutorials[0];
        Tutorials.Remove(0, 1);
        __OnNewTutorialCallback__Delegate();
    }
    else
    {
        __OnDoneTutorialsCallback__Delegate();
    }
}
public delegate function OnDoneTutorialsCallback();

public delegate function OnNewTutorialCallback();

public function OnRespecMessageBoxConfirm(bool bAPressed, int nContext)
{
    local int nRespecCardCount;
    local SFXSaveManagerMP MPSaveManager;
    local SFXMPCharacterRecord CharacterRecord;
    
    nRespecCardCount = GetNumMPRespecCards();
    if (bAPressed && nRespecCardCount > 0)
    {
        m_SpawnedSquadMembersSource[m_RespecMemberIndex].PowerManager.RefundAllTalentPoints();
        m_Helper.SetPawn(m_SpawnedSquadMembersSource[m_RespecMemberIndex]);
        m_Helper.SaveCurrentPowerStates();
        if (ShouldShowMultiplayerCharacter())
        {
            MPSaveManager = Class'SFXEngine'.static.GetSFXEngine().MPSaveManager;
            CharacterRecord = MPSaveManager.GetCurrentSelectedCharacterRecord();
            CharacterRecord.ResetPowers();
            CharacterRecord.SetPowersFromPawn(m_SpawnedSquadMembersSource[m_RespecMemberIndex]);
            Class'SFXEngine'.static.GetSFXEngine().MPSaveManager.SetPlayerVariable('MPRespec', nRespecCardCount - 1);
            PlayGuiSound('CharRecRespecPowers');
        }
        ASRefreshDataAfterRespec(m_RespecMemberIndex);
    }
}
private final function PrepEvoDetails(SFXPawn MemberPawn, SFXPowerCustomActionBase Power, int RankIdx, int FileIdx, out EvoDetails Details)
{
    local SFXPawn_PlayerParty PlayerPartyPawn;
    local bool PowerLocked;
    local PowerUnlockRequirement Req;
    
    Details.Name = "";
    Details.Desc = "";
    Details.State = 1;
    Details.Cost = 0;
    PlayerPartyPawn = SFXPawn_PlayerParty(MemberPawn);
    if (PlayerPartyPawn == None)
    {
        return;
    }
    PowerLocked = FALSE;
    foreach PlayerPartyPawn.PowerUnlockRequirements(Req, )
    {
        if (Power.Class == Req.PowerClass)
        {
            if (PlayerPartyPawn.CharacterLevel < Req.RequiredLevel)
            {
                PowerLocked = TRUE;
                break;
            }
        }
    }
    if (RankIdx < 3)
    {
        if (PowerLocked)
        {
            Details.State = 0;
        }
        else if (float(RankIdx) < Power.Rank)
        {
            Details.State = 2;
        }
        Details.Cost = Power.RankCosts[RankIdx];
    }
    else if (RankIdx < 6)
    {
        if (PowerLocked)
        {
            Details.State = 0;
        }
        else if (Power.IsEvolvedWithChoice(byte(EvoChoiceIndex(RankIdx, FileIdx))))
        {
            Details.State = 2;
        }
        else if (Power.IsEvolvedWithChoice(byte(EvoChoiceIndex(RankIdx, 3 - FileIdx))))
        {
            Details.State = 0;
        }
        Details.Cost = Power.EvolvedRankCosts[(RankIdx - 3) * 2 + (FileIdx - 1)];
    }
    if (FileIdx == 1)
    {
        Details.Name = GetUIString(Power.Ranks[RankIdx].Evolved1Name, FALSE);
        Power.GetParsedString(Power.Ranks[RankIdx].Evolved1Description, RankIdx, Details.Desc);
    }
    else if (FileIdx == 2)
    {
        Details.Name = GetUIString(Power.Ranks[RankIdx].Evolved2Name, FALSE);
        Power.GetParsedString(Power.Ranks[RankIdx].Evolved2Description, RankIdx, Details.Desc);
    }
}
private final function PrepMemberDetails(SFXPawn MemberPawn, out CharDetails MemberDetails)
{
    local SFXGRI GRI;
    local BioPlayerController oController;
    local SFXPawn_Player PlayerPawn;
    local SFXPawn_Henchman HenchPawn;
    local int nXP_NextLevel;
    local int nXP_Current;
    local int nXP_Base;
    local float PgnPct;
    local float RngPct;
    local Texture2D HenchIcon;
    
    MemberDetails.CharName = "";
    MemberDetails.CharClass = stringref(0);
    MemberDetails.Face = "";
    MemberDetails.Abbrev = "";
    MemberDetails.Thumb = "";
    MemberDetails.allocated = 0;
    MemberDetails.Spendable = 0;
    MemberDetails.XP = "";
    MemberDetails.Level = 0;
    MemberDetails.PrettyLevel = "";
    MemberDetails.PctToLevel = 0;
    MemberDetails.Health = 0;
    MemberDetails.Shield = 0;
    MemberDetails.ShieldTitle = "";
    MemberDetails.Pgn = -1;
    MemberDetails.Rng = -1;
    if (oWorldInfo != None)
    {
        oController = oWorldInfo.GetLocalPlayerController();
    }
    if (MemberPawn == None)
    {
        return;
    }
    PlayerPawn = SFXPawn_Player(MemberPawn);
    HenchPawn = SFXPawn_Henchman(MemberPawn);
    GRI = oWorldInfo != None ? SFXGRI(oWorldInfo.GRI) : None;
    if (GRI == None)
    {
        if (PlayerPawn == None && HenchPawn == None)
        {
            return;
        }
        MemberDetails.Level = PlayerPawn.CharacterLevel;
    }
    else
    {
        GRI.GetPlayerLevel(LocalPlayer(oController.Player).ControllerId, MemberDetails.Level);
    }
    if (PlayerPawn != None)
    {
        MemberDetails.CharName = PlayerPawn.GetFullName();
        MemberDetails.Abbrev = UIStrRef(PlayerPawn.GetPrettyName());
        MemberDetails.CharClass = stringref(PlayerPawn.PlayerClass.srClassName);
        ClearCustomTokens();
        SetCustomToken(0, string(MemberDetails.Level));
        SetCustomToken(1, " ");
        MemberDetails.PrettyLevel = GetUIString(m_srShepardLevelClassFormat, TRUE);
        ClearCustomTokens();
        if (Len(PlayerPawn.faceCode) > 0)
        {
            ClearCustomTokens();
            SetCustomToken(0, PlayerPawn.faceCode);
            MemberDetails.Face = GetUIString(m_srFaceCodeFormat, TRUE);
            ClearCustomTokens();
        }
        else
        {
            MemberDetails.Face = "";
        }
        if (!ShouldShowMultiplayerCharacter())
        {
            PlayerPawn.GetParagonRenegadePercentage(PgnPct, RngPct);
            MemberDetails.Pgn = int(PgnPct *= 100.0);
            MemberDetails.Rng = int(RngPct *= 100.0);
        }
    }
    else if (HenchPawn != None)
    {
        MemberDetails.CharName = GetUIString(HenchPawn.GetPrettyName());
        MemberDetails.Abbrev = MemberDetails.CharName;
        MemberDetails.CharClass = stringref(0);
        MemberDetails.Level = HenchPawn.CharacterLevel;
        ClearCustomTokens();
        SetCustomToken(0, string(HenchPawn.CharacterLevel));
        SetCustomToken(1, " ");
        MemberDetails.PrettyLevel = GetUIString(m_srShepardLevelClassFormat, TRUE);
        ClearCustomTokens();
        MemberDetails.Face = "";
        MemberDetails.Pgn = -1;
        MemberDetails.Rng = -1;
    }
    HenchIcon = MemberPawn.GetGUIIcon();
    MemberDetails.Thumb = HenchIcon == None ? "" : PathName(HenchIcon);
    MemberDetails.Health = int(MemberPawn.GetMaxHealth());
    MemberDetails.Shield = Round(MemberPawn.GetMaxShields());
    MemberDetails.ShieldTitle = MemberPawn.GetShieldTypeAsDisplayString();
    GetExperienceProgress(nXP_Base, nXP_Current, nXP_NextLevel);
    if (nXP_NextLevel - nXP_Current > 0)
    {
        ClearCustomTokens();
        SetCustomToken(0, string(nXP_NextLevel - nXP_Current));
        MemberDetails.XP = GetUIString(m_srXPFormat, TRUE);
        ClearCustomTokens();
    }
    MemberDetails.PctToLevel = Max(Min(100 * (nXP_Current - nXP_Base) / (nXP_NextLevel - nXP_Base), 100), 1);
    MemberDetails.allocated = MemberPawn.TalentPoints;
    MemberDetails.Spendable = MemberPawn.TalentPoints;
}
private final function PrepPowerDetails(SFXPawn MemberPawn, SFXPowerCustomActionBase Power, out PowerDetails Details)
{
    local SFXPawn_PlayerParty PlayerPartyPawn;
    local PowerUnlockRequirement Req;
    local string UnlockDetails;
    local string UnlockDetailsSeparator;
    
    Details.Name = "";
    Details.Desc = "";
    Details.State = 1;
    Details.IconFrame = 1;
    Details.Resource = "";
    PlayerPartyPawn = SFXPawn_PlayerParty(MemberPawn);
    if (PlayerPartyPawn == None)
    {
        return;
    }
    Power.GetStringFromStringRef(Power.DisplayName, Details.Name);
    UnlockDetails = "";
    UnlockDetailsSeparator = "";
    foreach PlayerPartyPawn.PowerUnlockRequirements(Req, )
    {
        if (Power.Class == Req.PowerClass)
        {
            if (PlayerPartyPawn.CharacterLevel < Req.RequiredLevel)
            {
                Details.State = 0;
                ClearCustomTokens();
                SetCustomToken(0, string(Req.RequiredLevel));
                UnlockDetails = GetUIString(m_srRequiredLevelFormat, TRUE);
                ClearCustomTokens();
                UnlockDetailsSeparator = "<BR><BR>";
                break;
            }
        }
    }
    Power.GetStringFromStringRef(Power.Description, Details.Desc, TRUE, int(Power.Rank - float(1)));
    ClearCustomTokens();
    SetCustomToken(0, UnlockDetails);
    SetCustomToken(1, UnlockDetailsSeparator);
    SetCustomToken(2, Details.Desc);
    Details.Desc = GetUIString(m_srTalentDescriptionFormat, TRUE);
    ClearCustomTokens();
    if (Power.Ranks.Length > 0)
    {
        Details.IconFrame = Power.Ranks[0].Icon;
    }
    Details.Resource = PathName(Power.IconResource);
}
public function ProcessRStickAxisInput(float fValue)
{
    if (Abs(fValue) > 0.25)
    {
        m_fScrollValue = -fValue;
    }
    else
    {
        m_fScrollValue = 0.0;
    }
}
private final function PurchasePowerRank(int nPowerIndex, int nRankIndex, int nEvoIndex)
{
    if (m_Helper.IncreaseRank(nPowerIndex) == FALSE)
    {
        return;
    }
    if (nRankIndex > 3 && nPowerIndex >= 0 && nPowerIndex < m_Helper.m_Powers.Length)
    {
        m_Helper.EvolvePower(m_Helper.m_Powers[nPowerIndex], (nRankIndex - 4) * 2 + nEvoIndex - 1);
    }
}
public function SetOnCloseCallback(delegate<OnCloseCallback> fn_OnCloseDelegate)
{
    __OnCloseCallback__Delegate = fn_OnCloseDelegate;
}
public function bool ShouldShowMultiplayerCharacter()
{
    return SFXGRI(oWorldInfo.GRI).bIsMultiplayerCharacter;
}
public function Tutorial_BuildPoints()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams stParams;
    local stringref srMessage;
    
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    messageBox.SetInputDelegate(TutorialConfirm);
    stParams.srAText = m_srOk;
    stParams.bModal = TRUE;
    stParams.bNoFade = TRUE;
    if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        srMessage = m_srSpendTalentPointsMessageXBox;
    }
    else if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        srMessage = m_srSpendTalentPointsMessagePS3;
    }
    else if (!Class'WorldInfo'.static.IsConsoleBuild(0))
    {
        srMessage = m_srSpendTalentPointsMessagePC;
    }
    messageBox.DisplayMessageBox(srMessage, stParams);
}
public function Tutorial_ParagonRenegade()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams stParams;
    local stringref srMessage;
    
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    messageBox.SetInputDelegate(TutorialConfirm);
    stParams.srAText = m_srOk;
    stParams.bModal = TRUE;
    stParams.bNoFade = TRUE;
    if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        srMessage = m_srParagonRenegadeMessageXBox;
    }
    else if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        srMessage = m_srParagonRenegadeMessagePS3;
    }
    else if (!Class'WorldInfo'.static.IsConsoleBuild(0))
    {
        srMessage = m_srParagonRenegadeMessagePC;
    }
    messageBox.DisplayMessageBox(srMessage, stParams);
}
public function TutorialConfirm(bool bAPressed, int nContext)
{
    NextTutorial();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_ParagonRenegadeBarValues = (1.0)
    m_srXPFormat = $340883
    m_srSpendTalentPointsMessageXBox = $348754
    m_srParagonRenegadeMessageXBox = $348755
    m_srSpendTalentPointsMessagePC = $348753
    m_srParagonRenegadeMessagePC = $348755
    m_srSpendTalentPointsMessagePS3 = $348754
    m_srParagonRenegadeMessagePS3 = $348755
    m_srOk = $153007
    m_srRespecMessage = $717630
    m_srRespecCancel = $568219
    m_srShepardLevelClassFormat = $346691
    m_srTalentDescriptionFormat = $347303
    m_srRequiredLevelFormat = $620733
    m_srRankDescriptionFormat = $347304
    m_srFaceCodeFormat = $348486
    m_srCostTokenFormat = $512730
    m_srCantBuyLocked = $722350
    m_srCantBuyCost = $722351
    m_srCantBuyBought = $722352
    m_srCantBuyRank = $722353
    m_srExitText = $328909
    m_srCostText = $612693
    m_srScarHint = $724699
    m_AText = $103240
    m_BText = $103236
    m_XText = $152095
    m_YText = $166224
    nHandlerID = 3
}