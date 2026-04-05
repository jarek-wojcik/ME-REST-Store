Class BioSFHandler_NewCharacter extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum NewCharacterLookAtTarget
{
    NCLAT_Ahead,
    NCLAT_Left,
    NCLAT_Right,
    NCLAT_Up,
    NCLAT_Down,
};
struct native BonusTalentData 
{
    var Name PowerClassName;
    var int BonusPowerID;
    var stringref srChoiceName;
    var stringref srChoiceTitle;
    var Texture2D oChoiceImage;
    var stringref srChoiceDescription;
};
struct native TemplateGenderPair 
{
    var Name UIWorldVar;
    var Name BuildClass;
    var BioPawn Placed;
    var BioPawn Spawned;
};
enum BioNewCharacterTemplates
{
    BNCT_ICONIC,
    BNCT_CUSTOM,
    BNCT_IMPORTED,
};
enum ECreateCharacterGUIGender
{
    ECreateCharacterGUIGender_Male,
    ECreateCharacterGUIGender_Female,
};
enum EDataOrigin
{
    DataOrigin_NewGame,
    DataOrigin_ME1,
    DataOrigin_ME2,
    DataOrigin_ME3,
};
enum EPlotChoice
{
    EPlotChoice_None,
    EPlotChoice_KaidenDies,
    EPlotChoice_AshleyDies,
};
const MAX_CLASS_CHOICES = 6;
const SelectStorageDevice = 24;
const SetCode = 21;
const ShowCodeKeyboard = 20;
const UpdateBonusTalents = 18;
const Set3DModelState = 17;
const ResetCategory = 16;
const ZoomOutFromFace = 15;
const ZoomInOnFace = 14;
const Show3DModel = 13;
const StartCustom = 12;
const Hide3DModel = 11;
const SelectPreviousChar = 10;
const ClassChange = 9;
const ConfirmCharCreate = 8;
const ShowNameKeyboard = 7;
const ExitNewCharacter = 6;
const StartGameWithCustom = 5;
const InitializeNC = 4;
const StartGameWithIconic = 3;
const SliderValueChanged = 2;
const NextGeneratedHead = 1;

var transient MorphHeadSaveRecord DefaultFemaleME2SaveProperties;
var string m_sMaleName;
var string m_sFemaleName;
var transient string sImportedFaceCode;
var transient string sCustomFaceCode;
var array<AnimSet> lstClassAnimSetRefs;
var array<Class<SFXCharacterClass>> lstCharacterClasses;
var array<Class<SFXPawn_Player>> lstSpawnableClasses;
var const config array<BonusTalentData> BonusTalents;
var transient array<BonusTalentData> UnlockedBonusTalents;
var config array<int> NewGameStartingCodexEntries;
var config array<string> MalePregeneratedHeadCodes;
var config array<string> FemalePregeneratedHeadCodes;
var config string DefaultFemaleME2HeadCode;
var delegate<OnCloseCallback> __OnCloseCallback__Delegate;
var TemplateGenderPair lstTemplates[3];
var Name m_nmAllianceComputerPleaseLogin;
var Name m_nmClassAnimSet;
var float fLookAtUpDownValue;
var float fLookAtLeftRightValue;
var config stringref srCustomMaleName;
var config stringref srCustomFemaleName;
var config stringref srNewCharConfirm;
var config stringref srNewCharCancel;
var config stringref srNewCharQuestion;
var config stringref srFacialCategoryDescription;
var config stringref srConfirm;
var config stringref srSetName;
var config stringref srSetCode;
var config stringref srFailedToFindFaceCode;
var int m_nDefaultOrigin;
var int m_nDefaultNotoriety;
var config int m_nDefaultClass;
var config stringref srNameTitle;
var config int nMaxNameLength;
var config stringref srCodeTitle;
var config int nMaxCodeLength;
var config int m_nInfoScrollSpeed;
var(BioSFHandler_NewCharacter) transient stringref NoSaveDevice;
var(BioSFHandler_NewCharacter) transient stringref ConfirmSelectDevice;
var(BioSFHandler_NewCharacter) transient stringref CancelSelectDevice;
var SFXMorphFaceFrontEndDataSource MaleDataSource;
var SFXMorphFaceFrontEndDataSource FemaleDataSource;
var RvrClientEffectInterface CE_SchematicEffect;
var AnimSet SchematicAnimSet;
var SFXGUIHelper_ConsoleKeyboard oKeyboard;
var transient int CurrentPregeneratedHeadIndex;
var transient BioMorphFace CurrentMorphFace;
var transient int ImportedCharmSkill;
var transient int ImportedIntimidateSkill;
var transient int CurrentScarIndex;
var transient export BioMorphFaceFrontEnd m_oBioMorphFrontEnd;
var bool bLookAtLeftRightNulling;
var bool bLookAtUpDownNulling;
var bool bZoomedInOnFace;
var bool bOpenedFromMainMenu;
var bool m_bSpecialTriggerDeviceSelection;
var config bool bSkipCharacterCreation;
var transient bool bXboxStorageDeviceSelected;
var bool m_bMaleSelected;
var transient bool m_bStopScroll;
var transient bool AssumeUIBlocking;
var transient bool m_bCustomShepard;
var transient bool bValidateImportedHead;
var config bool bEnsureValidFaceCodeOnImport;
var transient bool ImportedCosmeticSurgery;
var EPlotChoice m_ePlotChoice;
var EDataOrigin m_nDataOrigin;
var BioNewCharacterTemplates m_nCurrentTemplate;
var BioNewCharacterTemplates m_nLastInitializedTemplate;
var NewCharacterLookAtTarget CurrentLookAtTarget;
var NewCharacterLookAtTarget NextLookAtTarget;

public native function ClearEffects();

public event function BioPawn GenderTemplatePawn(BioNewCharacterTemplates BNCT)
{
    return lstTemplates[int(BNCT)].Spawned;
}
public event function Class<Object> GetCharacterClassByName(Name nmClass)
{
    local Class<SFXCharacterClass> CharClass;
    local int nClassIdx;
    
    for (nClassIdx = 0; nClassIdx < lstCharacterClasses.Length; ++nClassIdx)
    {
        CharClass = lstCharacterClasses[nClassIdx];
        if (CharClass.default.className ~= string(nmClass))
        {
            return CharClass;
        }
    }
    return None;
}
public function HandleEvent(byte nCommand, const out array<string> lstArguments)
{
    local Name nmNewClass;
    local BioPawn CurrentPawn;
    
    if (bSkipCharacterCreation)
    {
        SetupIconicCharacter(lstArguments);
        if (Class'WorldInfo'.static.IsConsoleBuild(0))
        {
            nCommand = 24;
        }
        else
        {
            m_oBioMorphFrontEnd.Cleanup();
            FinalCommit();
            return;
        }
    }
    switch (nCommand)
    {
        case 2:
            HandleSliderChange(int(lstArguments[0]), int(lstArguments[1]), int(lstArguments[2]));
            UpdateCode();
            break;
        case 9:
            Update3DModelByClass(Name(lstArguments[0]), GenderTemplatePawn(m_nCurrentTemplate), m_nCurrentTemplate, FALSE);
            break;
        case 17:
            CurrentPawn = GenderTemplatePawn(m_nCurrentTemplate);
            m_bMaleSelected = int(lstArguments[1]) == 0;
            nmNewClass = lstTemplates[int(m_nCurrentTemplate)].BuildClass;
            if (bZoomedInOnFace)
            {
                oWorldInfo.m_UIWorld.TriggerEvent('CharCreateLookReset', oWorldInfo);
            }
            Update3DModelState(byte(int(lstArguments[0])), CurrentPawn);
            Update3DModelByClass(nmNewClass, GenderTemplatePawn(byte(int(lstArguments[0]))), byte(int(lstArguments[0])), TRUE, FALSE, !bZoomedInOnFace);
            break;
        case 1:
            SelectNextPregeneratedHead();
            UpdateCode();
            break;
        case 16:
            DoCategoryReset(int(lstArguments[0]));
            UpdateCode();
            break;
        case 3:
            SetupIconicCharacter(lstArguments);
            m_oBioMorphFrontEnd.Cleanup();
            FinalCommit();
            break;
        case 5:
            SetPlayerCharacter(lstArguments);
            m_oBioMorphFrontEnd.Cleanup();
            FinalCommit();
            break;
        case 8:
            ConfirmComplete();
            break;
        case 14:
            bZoomedInOnFace = TRUE;
            oWorldInfo.m_UIWorld.AddDeferredOperation(DisableSchematicAnim, GenderTemplatePawn(m_nCurrentTemplate));
            oWorldInfo.m_UIWorld.TriggerEvent('CharCreateZoomIn', oWorldInfo);
            break;
        case 15:
            Update3DModelByClass(lstTemplates[int(m_nCurrentTemplate)].BuildClass, GenderTemplatePawn(m_nCurrentTemplate), m_nCurrentTemplate, TRUE, TRUE);
            bZoomedInOnFace = FALSE;
            oWorldInfo.m_UIWorld.AddDeferredOperation(EnableSchematicAnim, GenderTemplatePawn(m_nCurrentTemplate));
            oWorldInfo.m_UIWorld.TriggerEvent('CharCreateZoomOut', oWorldInfo);
            ResetLookAt();
            break;
        case 11:
            oWorldInfo.m_UIWorld.HidePawn(GenderTemplatePawn(m_nCurrentTemplate));
            break;
        case 13:
            oWorldInfo.m_UIWorld.HidePawn(GenderTemplatePawn(m_nCurrentTemplate), FALSE);
            break;
            break;
        case 18:
            UpdateBonusTalentList();
            break;
        case 4:
            oWorldInfo.m_UIWorld.TriggerEvent('CharCreateInitCamera', oWorldInfo);
            ProcessExternalStates(oWorldInfo);
            SetCustomName(m_sMaleName, m_sFemaleName);
            SetUIPawnCasual(TRUE);
            oWorldInfo.m_UIWorld.SetObjectVariable('ZoomInCompleteEffect', CE_SchematicEffect);
            oWorldInfo.m_UIWorld.HidePawn(GenderTemplatePawn(m_nCurrentTemplate), FALSE);
            Update3DModelByClass('Soldier', GenderTemplatePawn(m_nCurrentTemplate), m_nCurrentTemplate, TRUE, TRUE);
            bZoomedInOnFace = TRUE;
            oWorldInfo.m_UIWorld.TriggerEvent('CharCreateForcedZoomIn', oWorldInfo);
            break;
        case 12:
            m_oBioMorphFrontEnd.SetPlayerName(m_bMaleSelected ? m_sMaleName : m_sFemaleName);
            SetCustomModel();
            PopulateCustomFaceList();
            SetSliderPositions();
            UpdateCode();
            break;
        case 6:
            Class'SFXEngine'.static.GetSFXEngine().LoadMovieManager.SetupNativeLoadingMovie('CharToEntryMenu');
            GetSFXUIController().HackReloadMainMenu();
            break;
        case 7:
            if (Class'WorldInfo'.static.IsConsoleBuild(0))
            {
                oKeyboard = new (Self) Class'SFXGUIHelper_ConsoleKeyboard';
                oKeyboard.__OnKeyboardEntryComplete__Delegate = KeyboardNameEntryComplete;
                oKeyboard.DisplayKeyboard(srNameTitle, srSetName, 0, nMaxNameLength, m_bMaleSelected ? m_sMaleName : m_sFemaleName);
            }
            PlayGuiVoice(m_nmAllianceComputerPleaseLogin);
            break;
        case 20:
            if (Class'WorldInfo'.static.IsConsoleBuild(0))
            {
                oKeyboard = new (Self) Class'SFXGUIHelper_ConsoleKeyboard';
                oKeyboard.__OnKeyboardEntryComplete__Delegate = KeyboardCodeEntryComplete;
                oKeyboard.DisplayKeyboard(srCodeTitle, srSetCode, 3, nMaxCodeLength, sCustomFaceCode);
            }
            break;
        case 21:
            if (lstArguments.Length > 0)
            {
                ApplyNewCode(lstArguments[0]);
                SetSliderPositions();
            }
            UpdateCode();
            break;
        case 24:
            if (GetPC() != None && Class'UIInteraction'.static.IsLoggedIn(LocalPlayer(GetPC().Player).ControllerId))
            {
                m_bSpecialTriggerDeviceSelection = TRUE;
                ChooseStorageDevice();
            }
            break;
        default:
    }
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            HandleLookAtUpDown(fValue);
            ScrollText(-fValue);
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_X:
            HandleLookAtLeftRight(fValue);
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public final function HandleSliderChange(int nCategory, int nSlider, int nValue)
{
    m_oBioMorphFrontEnd.HandleSliderChange(nCategory, nSlider, nValue);
    UpdateCurrentMorphAppearance();
}
public final native function bool IsDefaultME2Player(const out PlayerSaveRecord InRecord);

public delegate function OnCloseCallback();

public function OnDeviceSelectionComplete(bool bWasSuccessful, bool bWasBlocked)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local PlayerController PC;
    local int ControllerId;
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local SFXEngine Engine;
    local int DeviceID;
    local string DeviceName;
    local stringref SoldierStringRef;
    
    PC = GetPC();
    ControllerId = LocalPlayer(PC.Player).ControllerId;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    if (PlayerIntEx != None)
    {
        PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete);
    }
    if (bWasSuccessful)
    {
        if (PlayerIntEx != None)
        {
            DeviceID = PlayerIntEx.GetDeviceSelectionResults(byte(LocalPlayer(PC.Player).ControllerId), DeviceName);
            BioPlayerController(PC).SetDeviceID(DeviceID);
            bXboxStorageDeviceSelected = TRUE;
        }
        Engine = SFXEngine(PC.Player.Outer);
        if (Engine != None)
        {
            if (Class'WorldInfo'.static.IsConsoleBuild(1))
            {
                Engine.bCanWriteSaveToStorage = TRUE;
                SoldierStringRef = $93952;
                Engine.ClearSaveCache();
                Engine.CreateCareer(m_bMaleSelected ? m_sMaleName : m_sFemaleName, SoldierStringRef, 1, 1, OnCreatePlaceholderCareer);
            }
            else if (!m_bSpecialTriggerDeviceSelection)
            {
                oPanel.InvokeMethod("nameEntryComplete");
            }
        }
        if (bSkipCharacterCreation)
        {
            m_oBioMorphFrontEnd.Cleanup();
            FinalCommit();
            return;
        }
    }
    else if (bWasBlocked)
    {
        OnlineSub.SystemInterface.AddExternalUIChangeDelegate(OnUIUnblock);
    }
    else
    {
        messageBox = GetSFXUIController().CreateMessageBox(GetPC());
        messageBox.SetInputDelegate(Callback_NoDevice);
        Params.srAText = ConfirmSelectDevice;
        Params.srBText = CancelSelectDevice;
        Params.bNoFade = TRUE;
        messageBox.DisplayMessageBox(NoSaveDevice, Params);
        OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnUIUnblock);
    }
}
public function OnPanelAdded()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    Super.OnPanelAdded();
    PlayGuiMusic('CharacterCreation');
    oPanel.m_bApplyRightThumbstickDeadzone = TRUE;
    stParam.Type = ASParamTypes.ASParam_Float;
    stParam.fVar = float(ScreenLayout);
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("SetPlatformLayout", lstParams);
    SetMaleSelected(m_bMaleSelected);
    oPanel.SetExternalInterface(Self);
}
public function OnPanelRemoved()
{
    Super.OnPanelRemoved();
    ClearModels();
}
public event function OnStart()
{
    Super(SFXGUIMovie).OnStart();
    AS_InitializeScreen();
}
public event function ProcessExternalStates(BioWorldInfo BWI)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local PlayerSaveRecord PlayerRecord;
    local bool bIsFemale;
    local bool bIsImport;
    local BioGlobalVariableTable TempTable;
    local PlayerInfoEx PlayerData;
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    
    PC = BioPlayerController(GetPC());
    Engine = SFXEngine(PC.Player.Outer);
    TempTable = new Class'BioGlobalVariableTable';
    if (Engine != None && Engine.PlusImportSaveGame != None)
    {
        m_nDataOrigin = EDataOrigin.DataOrigin_ME3;
        Engine.PlusImportSaveGame.GetPlayerRecord(PlayerRecord);
        PlayerData.bIsFemale = PlayerRecord.bIsFemale;
        PlayerData.Origin = PlayerRecord.Origin;
        PlayerData.Notoriety = PlayerRecord.Notoriety;
        TempTable.SetNewGamePlotStates(Engine.LegacyImportSaveGame, Engine.PlusImportSaveGame, PlayerData, FALSE);
        ImportedCharmSkill = TempTable.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Paragon);
        ImportedIntimidateSkill = TempTable.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Renegade);
        bIsImport = TRUE;
    }
    else if (Engine != None && Engine.LegacyImportSaveGame != None)
    {
        m_nDataOrigin = EDataOrigin.DataOrigin_ME2;
        Engine.LegacyImportSaveGame.GetPlayerRecord(PlayerRecord);
        PlayerData.bIsFemale = PlayerRecord.bIsFemale;
        PlayerData.Origin = PlayerRecord.Origin;
        PlayerData.Notoriety = PlayerRecord.Notoriety;
        TempTable.SetNewGamePlotStates(Engine.LegacyImportSaveGame, Engine.PlusImportSaveGame, PlayerData, FALSE);
        Class'BioLevelUpSystem'.static.ME2ToME3_ParagonRenegade(TempTable.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_ME2Paragon), TempTable.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_ME2Renegade), ImportedCharmSkill, ImportedIntimidateSkill);
        if (bEnsureValidFaceCodeOnImport && bValidateImportedHead)
        {
            if (PlayerRecord.faceCode == "" && !IsDefaultME2Player(PlayerRecord))
            {
                messageBox = GetSFXUIController().CreateMessageBox(GetPC());
                Params.bNoFade = TRUE;
                Params.srAText = $152938;
                messageBox.DisplayMessageBox(srFailedToFindFaceCode, Params);
            }
            bValidateImportedHead = FALSE;
        }
        bIsImport = TRUE;
    }
    else
    {
        bIsImport = FALSE;
    }
    if (bIsImport)
    {
        SetMaleSelected(!PlayerRecord.bIsFemale);
        m_sMaleName = PlayerRecord.firstName;
        m_sFemaleName = m_sMaleName;
        m_nDefaultOrigin = int(PlayerRecord.Origin) - 1;
        m_nDefaultNotoriety = int(PlayerRecord.Notoriety) - 1;
        m_nDefaultClass = GetSpawnableClassIndexFromClass(PlayerRecord.PlayerClass);
        sImportedFaceCode = PlayerRecord.faceCode;
        if (m_nDataOrigin == EDataOrigin.DataOrigin_ME2 && sImportedFaceCode == "" && PlayerRecord.bIsFemale)
        {
            sImportedFaceCode = DefaultFemaleME2HeadCode;
        }
        ImportedCosmeticSurgery = TempTable.GetBool(Class'SFXPlayerCustomization'.default.CosmeticSurgeryPlotID);
    }
    else
    {
        m_nDataOrigin = EDataOrigin.DataOrigin_NewGame;
        bIsFemale = FALSE;
        if (Engine != None)
        {
            bIsFemale = Engine.ProgressPlayer.bIsFemale;
        }
        SetMaleSelected(bIsFemale == FALSE);
        m_sMaleName = string(srCustomMaleName);
        m_sFemaleName = string(srCustomFemaleName);
        m_nDefaultOrigin = 3 - 1;
        m_nDefaultNotoriety = 1 - 1;
        ImportedCosmeticSurgery = FALSE;
    }
    if (m_nDefaultClass < 0 || m_nDefaultClass >= lstCharacterClasses.Length)
    {
        m_nDefaultClass = 0;
    }
    if (m_nDataOrigin != EDataOrigin.DataOrigin_NewGame)
    {
        m_nCurrentTemplate = BioNewCharacterTemplates.BNCT_IMPORTED;
    }
    else
    {
        m_nCurrentTemplate = BioNewCharacterTemplates.BNCT_ICONIC;
    }
}
public native function Setup3DModel();

public final event function TriggerClassOverlay()
{
    oPanel.InvokeMethod("TriggerClassOverlay");
}
public function Update(float fDeltaT)
{
    UpdateLookAtTarget();
}
public native function Update3DModelByClass(Name nmClass, BioPawn pTemplate, BioNewCharacterTemplates nTemplate, bool bUpdate, optional bool bForce = FALSE, optional bool bAttachVFXandUpdatePose = TRUE);

public event function OnClose()
{
    __OnCloseCallback__Delegate = None;
    Super(SFXGUIMovie).OnClose();
}
public function AddKismetNamedObject(Name KismetVariableName, Object ObjectValue)
{
    local BioUIWorld oUIWorld;
    
    oUIWorld = oWorldInfo.m_UIWorld;
    if (oUIWorld != None)
    {
        oUIWorld.SetObjectVariable(KismetVariableName, ObjectValue);
    }
}
public function ApplyManualScar(Object InData)
{
    local SFXPawn_Player SourceTemplate;
    local Actor TargetActor;
    local SkeletalMeshComponent HeadMesh;
    
    SourceTemplate = SFXPawn_Player(InData);
    if (SourceTemplate != None)
    {
        TargetActor = oWorldInfo.m_UIWorld.GetSpawnedActor(SourceTemplate);
        if (TargetActor != None)
        {
            HeadMesh = TargetActor.GetHeadSkelMeshComponent();
            if (HeadMesh != None)
            {
                Class'SFXPlayerCustomization'.static.ApplyScarParameters(Class'SFXPlayerCustomization'.default.Scars[CurrentScarIndex], m_bMaleSelected, HeadMesh);
            }
        }
    }
}
public function ApplyNewCode(string sInputCode)
{
    m_oBioMorphFrontEnd.ApplyFaceCode(sInputCode);
    UpdateCurrentMorphAppearance();
}
public final function AS_ConfirmCharacterCreationEnd(bool bAPressed)
{
    oPanel.ActionScriptVoid("HandleConfirmInput");
}
public function AS_InitializeScreen()
{
    ActionScriptVoid("InitializeScreen");
}
public final function CalculateCurrentScar()
{
    local int idx;
    
    CurrentScarIndex = Class'SFXPawn_Player'.static.CalculateScarIndex(ImportedCosmeticSurgery, ImportedCharmSkill, ImportedIntimidateSkill, 0);
    for (idx = 0; idx < 3; ++idx)
    {
        oWorldInfo.m_UIWorld.AddDeferredOperation(ApplyManualScar, GenderTemplatePawn(byte(idx)));
    }
}
public function Callback_NoDevice(bool bAPressed, int Context)
{
    local PlayerController PC;
    local SFXEngine Engine;
    
    if (bAPressed)
    {
        ChooseStorageDevice();
    }
    else
    {
        PC = GetPC();
        if (PC != None)
        {
            Engine = SFXEngine(PC.Player.Outer);
            if (Engine != None)
            {
                Engine.ClearCurrentSaveDescriptor();
                BioPlayerController(PC).SetDeviceID(-1);
                Engine.bCanWriteSaveToStorage = FALSE;
                if (!m_bSpecialTriggerDeviceSelection)
                {
                    oPanel.InvokeMethod("nameEntryComplete");
                }
            }
        }
    }
}
public function ChooseStorageDevice()
{
    local PlayerController PC;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;
    
    PC = GetPC();
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (PC != None && OnlineSub != None)
    {
        ControllerId = LocalPlayer(PC.Player).ControllerId;
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        if (PlayerIntEx != None)
        {
            PlayerIntEx.AddDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete);
            if (PlayerIntEx.ShowDeviceSelectionUI(byte(ControllerId), 1048576, TRUE) == FALSE)
            {
                PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete);
            }
            else
            {
                OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnUIUnblock);
            }
        }
    }
}
public function ChooseStorageDevice_Fallback()
{
    local PlayerController PC;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;
    
    PC = GetPC();
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (PC != None && OnlineSub != None)
    {
        ControllerId = LocalPlayer(PC.Player).ControllerId;
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        if (PlayerIntEx != None)
        {
            PlayerIntEx.AddDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete_Fallback);
            if (PlayerIntEx.ShowDeviceSelectionUI(byte(ControllerId), 1048576, TRUE) == FALSE)
            {
                PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete_Fallback);
            }
            else
            {
                OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnUIUnblock);
            }
        }
    }
}
public final function ClearCurrentCareer()
{
    local SFXEngine Engine;
    
    if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        if (Engine != None)
        {
            Engine.ClearCurrentSaveDescriptor();
        }
    }
}
public final function ClearModels()
{
    local int i;
    
    oWorldInfo.m_UIWorld.HidePawn(GenderTemplatePawn(m_nCurrentTemplate));
    for (i = 0; i < 3; i++)
    {
        oWorldInfo.m_UIWorld.DestroyPawn(lstTemplates[i].Spawned);
        lstTemplates[i].Spawned = None;
    }
    oWorldInfo.m_UIWorld.CleanupUIWorld();
}
public final function ConfirmCharacterCreationEnd(bool bAPressed, int nContext)
{
    if (bAPressed && Class'WorldInfo'.static.IsConsoleBuild(0) && !bXboxStorageDeviceSelected && Class'UIInteraction'.static.IsLoggedIn(LocalPlayer(GetPC().Player).ControllerId))
    {
        ChooseStorageDevice_Fallback();
        return;
    }
    AS_ConfirmCharacterCreationEnd(bAPressed);
}
public final function ConfirmComplete()
{
    local BioMessageBoxOptionalParams stParams;
    
    stParams.srAText = srNewCharConfirm;
    stParams.srBText = srNewCharCancel;
    Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('ConfirmComplete', 4, srNewCharQuestion, stParams, ConfirmCharacterCreationEnd, 0, GetPC());
}
public final function ConfirmDeviceSelection_Fallback(bool bAPressed, int nContext)
{
    local PlayerController PC;
    local SFXEngine Engine;
    
    if (bAPressed)
    {
        ChooseStorageDevice_Fallback();
    }
    else
    {
        PC = GetPC();
        if (PC != None)
        {
            Engine = SFXEngine(PC.Player.Outer);
            if (Engine != None)
            {
                Engine.ClearCurrentSaveDescriptor();
                BioPlayerController(PC).SetDeviceID(-1);
                Engine.bCanWriteSaveToStorage = FALSE;
            }
        }
        AS_ConfirmCharacterCreationEnd(TRUE);
    }
}
public final function DisableSchematicAnim(Object InData)
{
    local SFXPawn_Player SourceTemplate;
    local Actor TargetActor;
    local SkeletalMeshComponent BaseMesh;
    local AnimNodeBlend BlendNode;
    
    SourceTemplate = SFXPawn_Player(InData);
    if (SourceTemplate != None)
    {
        TargetActor = oWorldInfo.m_UIWorld.GetSpawnedActor(SourceTemplate);
        if (TargetActor != None)
        {
            BaseMesh = TargetActor.GetPrimarySkelMeshComponent();
            if (BaseMesh != None)
            {
                BlendNode = AnimNodeBlend(BaseMesh.FindAnimNode('PoseBlender'));
                if (BlendNode != None)
                {
                    BlendNode.SetBlendTarget(0.0, 0.5);
                }
            }
        }
    }
}
public final function DoCategoryReset(int nCategory)
{
    if (nCategory == 0)
    {
        m_oBioMorphFrontEnd.ResetAll();
    }
    else
    {
        m_oBioMorphFrontEnd.ResetCategory(nCategory - 1);
    }
    SetSliderPositions();
    UpdateCurrentMorphAppearance();
}
public final function EnableSchematicAnim(Object InData)
{
    local SFXPawn_Player SourceTemplate;
    local Actor TargetActor;
    local SkeletalMeshComponent BaseMesh;
    local AnimNodeBlend BlendNode;
    
    SourceTemplate = SFXPawn_Player(InData);
    if (SourceTemplate != None)
    {
        TargetActor = oWorldInfo.m_UIWorld.GetSpawnedActor(SourceTemplate);
        if (TargetActor != None)
        {
            BaseMesh = TargetActor.GetPrimarySkelMeshComponent();
            if (BaseMesh != None)
            {
                BlendNode = AnimNodeBlend(BaseMesh.FindAnimNode('PoseBlender'));
                if (BlendNode != None)
                {
                    BlendNode.SetBlendTarget(1.0, 0.5);
                }
            }
        }
    }
}
public final function EnsureMICs(Actor InActor)
{
    local MeshComponent MeshComp;
    local int idx;
    
    foreach InActor.ComponentList(Class'MeshComponent', MeshComp)
    {
        for (idx = 0; idx < MeshComp.GetNumElements(); ++idx)
        {
            MeshComp.CreateAndSetMaterialInstanceConstant(idx);
        }
    }
}
public final function FinalCommit()
{
    local PlayerInfoEx NewPlayer;
    local PlayerController PC;
    local BioPlayerController BioPC;
    local SFXEngine Engine;
    local Class<SFXCharacterClass> CharacterClassEx;
    local SeqEvent_RemoteEvent reStartNewGame;
    local BioGlobalVariableTable VarTable;
    local int idx;
    
    VarTable = oWorldInfo.GetGlobalVariables();
    PC = GetPC();
    BioPC = BioPlayerController(PC);
    if (PC != None)
    {
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        NewPlayer = Engine.CurrentPlayerInfo();
        CharacterClassEx = Class<SFXCharacterClass>(Class'SFXEngine'.static.GetSeekFreeObject(NewPlayer.CharacterClass.default.PlayerClassName, Class'Class'));
        Engine.ClearSaveCache();
        Engine.bGameInProgress = FALSE;
        Engine.CreateCareer(NewPlayer.firstName, stringref(CharacterClassEx.default.srClassName), NewPlayer.Origin, NewPlayer.Notoriety);
        if (m_nDataOrigin == EDataOrigin.DataOrigin_ME2 || m_nDataOrigin == EDataOrigin.DataOrigin_ME3)
        {
            if (m_nDataOrigin == EDataOrigin.DataOrigin_ME3)
            {
                Class'SFXGame'.static.CopyAndUpdateNewGamePlusData(Engine.CurrentSaveGame, Engine.PlusImportSaveGame, NewPlayer);
                if (BioPC != None)
                {
                    Engine.SetPlayerVariable('NEWGAMEACCOMPLISHED', 1);
                }
            }
            if (m_nDataOrigin == EDataOrigin.DataOrigin_ME2)
            {
                Class'SFXGame'.static.CopyAndUpdateME2ImportData(Engine.CurrentSaveGame, Engine.LegacyImportSaveGame, NewPlayer);
            }
            Engine.bGameInProgress = TRUE;
            Engine.CurrentSaveGame.bIsValid = TRUE;
        }
        VarTable.SetNewGamePlotStates(Engine.LegacyImportSaveGame, Engine.PlusImportSaveGame, NewPlayer);
        if (m_nDataOrigin == EDataOrigin.DataOrigin_ME2)
        {
            Class'BioLevelUpSystem'.static.SetME2ImportStartingValues(Engine.CurrentSaveGame.PlayerRecord);
        }
        for (idx = 0; idx < NewGameStartingCodexEntries.Length; idx++)
        {
            VarTable.SetBool(NewGameStartingCodexEntries[idx], TRUE);
        }
        if (m_nDataOrigin == EDataOrigin.DataOrigin_NewGame)
        {
            SetPlotChoices();
        }
        Engine.CurrentSaveGame.UpdatePlayerSaveRecord(NewPlayer);
        Engine.UploadFaceCodeToBlaze(NewPlayer.firstName, NewPlayer.faceCode);
        Class'SFXTelemetryHooks'.static.SendNewGameData(int(m_nDataOrigin), NewPlayer.bIsFemale, NewPlayer.firstName, m_bCustomShepard, NewPlayer.faceCode, int(NewPlayer.Origin), int(NewPlayer.Notoriety), NewPlayer.BonusTalentClass, NewPlayer.CharacterClass, NewPlayer.CharacterGUID, VarTable.GetBool(VarTable.ME3_Plots_Bool_Is_ME1_Import), VarTable.GetBool(VarTable.ME3_Plots_Bool_Is_ME2_Import), int(m_ePlotChoice));
        if (BioPC != None && m_bCustomShepard)
        {
            Engine.SetPlayerVariable('CREATECHARACCOMPLISHED', 1);
        }
        Engine.PlusImportSaveGame = None;
        Engine.LegacyImportSaveGame = None;
    }
    m_oBioMorphFrontEnd = None;
    MaleDataSource = None;
    FemaleDataSource = None;
    oWorldInfo.bPlayersOnly = FALSE;
    reStartNewGame = Class'SeqEvent_RemoteEvent'.static.FindRemoteEvent(Name("re_StartNewGame"));
    if (reStartNewGame != None)
    {
        reStartNewGame.CheckActivate(oWorldInfo, oWorldInfo);
    }
    StopGuiMusic();
    if (__OnCloseCallback__Delegate != None)
    {
        __OnCloseCallback__Delegate();
    }
}
public final function GetAllUnlockedBonusTalentInfo(out array<BonusTalentData> aUnlockedBonusTalentInfo)
{
    local BonusTalentData UnlockableTalent;
    local SFXProfileSettings Profile;
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC == None)
    {
        return;
    }
    Profile = PC.ProfileSettings;
    if (Profile == None)
    {
        return;
    }
    aUnlockedBonusTalentInfo.Length = 0;
    foreach BonusTalents(UnlockableTalent, )
    {
        if (Profile.IsBonusPowerUnlocked(UnlockableTalent.BonusPowerID))
        {
            aUnlockedBonusTalentInfo.AddItem(UnlockableTalent);
        }
    }
}
public function int GetBestBonusTalentID(Name ClassLabel)
{
    return 0;
}
public function ECreateCharacterGUIGender GetGender()
{
    return m_bMaleSelected ? 0 : 1;
}
public function int GetSpawnableClassIndexFromClass(Class<Object> aClass)
{
    local int nIndex;
    local int nResultIndex;
    
    nResultIndex = -1;
    for (nIndex = 0; nIndex < lstSpawnableClasses.Length; ++nIndex)
    {
        if (lstSpawnableClasses[nIndex] == aClass)
        {
            nResultIndex = nIndex;
            break;
        }
    }
    return nResultIndex;
}
public function HandleLookAtLeftRight(float fValue)
{
    local float LookThreshold;
    
    if (!bZoomedInOnFace)
    {
        return;
    }
    LookThreshold = 0.5;
    if (fLookAtLeftRightValue > LookThreshold)
    {
        if (fValue < -LookThreshold)
        {
            ResetLookAt();
        }
    }
    else if (fLookAtLeftRightValue < -LookThreshold)
    {
        if (fValue > LookThreshold)
        {
            ResetLookAt();
        }
    }
    else if (fValue > LookThreshold)
    {
        if (!bLookAtLeftRightNulling)
        {
            NextLookAtTarget = NewCharacterLookAtTarget.NCLAT_Right;
            fLookAtLeftRightValue = fValue;
            fLookAtUpDownValue = 0.0;
            bLookAtUpDownNulling = FALSE;
        }
    }
    else if (fValue < -LookThreshold)
    {
        if (!bLookAtLeftRightNulling)
        {
            NextLookAtTarget = NewCharacterLookAtTarget.NCLAT_Left;
            fLookAtLeftRightValue = fValue;
            fLookAtUpDownValue = 0.0;
            bLookAtUpDownNulling = FALSE;
        }
    }
    else
    {
        bLookAtLeftRightNulling = FALSE;
    }
}
public function HandleLookAtUpDown(float fValue)
{
    local float LookThreshold;
    
    if (!bZoomedInOnFace)
    {
        return;
    }
    LookThreshold = 0.5;
    if (fLookAtUpDownValue > LookThreshold)
    {
        if (fValue < -LookThreshold)
        {
            ResetLookAt();
        }
    }
    else if (fLookAtUpDownValue < -LookThreshold)
    {
        if (fValue > LookThreshold)
        {
            ResetLookAt();
        }
    }
    else if (fValue > LookThreshold)
    {
        if (!bLookAtUpDownNulling)
        {
            NextLookAtTarget = NewCharacterLookAtTarget.NCLAT_Down;
            fLookAtUpDownValue = fValue;
            bLookAtLeftRightNulling = FALSE;
            fLookAtLeftRightValue = 0.0;
        }
    }
    else if (fValue < -LookThreshold)
    {
        if (!bLookAtUpDownNulling)
        {
            NextLookAtTarget = NewCharacterLookAtTarget.NCLAT_Up;
            fLookAtUpDownValue = fValue;
            bLookAtLeftRightNulling = FALSE;
            fLookAtLeftRightValue = 0.0;
        }
    }
    else
    {
        bLookAtUpDownNulling = FALSE;
    }
}
public function HandleRotate(float fValue)
{
    if (fValue > 0.5)
    {
        oWorldInfo.m_UIWorld.TriggerEvent('CharCreateInitRotation', oWorldInfo);
    }
    else if (fValue < -0.5)
    {
        oWorldInfo.m_UIWorld.TriggerEvent('CharCreateReverseRotation', oWorldInfo);
    }
    else
    {
        oWorldInfo.m_UIWorld.TriggerEvent('CharCreateStopRotation', oWorldInfo);
    }
}
public final function InsertDefaultPregeneratedHead(string InCode)
{
    local int ExistingEntry;
    
    ExistingEntry = -1;
    if (m_bMaleSelected)
    {
        ExistingEntry = MalePregeneratedHeadCodes.Find(InCode);
        if (ExistingEntry < 0)
        {
            MalePregeneratedHeadCodes.Insert(0, 1);
            MalePregeneratedHeadCodes[0] = InCode;
        }
    }
    else
    {
        ExistingEntry = FemalePregeneratedHeadCodes.Find(InCode);
        if (ExistingEntry < 0)
        {
            FemalePregeneratedHeadCodes.Insert(0, 1);
            FemalePregeneratedHeadCodes[0] = InCode;
        }
    }
    if (ExistingEntry >= 0)
    {
        CurrentPregeneratedHeadIndex = ExistingEntry - 1;
    }
}
public final function KeyboardCodeEntryComplete(bool bOK, const string sCode)
{
    if (bOK)
    {
        ApplyNewCode(sCode);
        SetSliderPositions();
        UpdateCode();
    }
    oKeyboard = None;
}
public final function KeyboardNameEntryComplete(bool bOK, const string sName)
{
    local PlayerController PC;
    local int ControllerId;
    local bool bCanWriteSave;
    
    if (bOK)
    {
        if (sName == "")
        {
            oKeyboard.DisplayKeyboard(srNameTitle, $0, 0, nMaxNameLength, m_bMaleSelected ? m_sMaleName : m_sFemaleName);
        }
        else
        {
            if (m_bMaleSelected)
            {
                m_sMaleName = Repl(sName, ",", "", TRUE);
                SetCustomName(m_sMaleName, "");
            }
            else
            {
                m_sFemaleName = Repl(sName, ",", "", TRUE);
                SetCustomName("", m_sFemaleName);
            }
            oKeyboard = None;
            bCanWriteSave = FALSE;
            PC = GetPC();
            if (PC != None)
            {
                ControllerId = LocalPlayer(PC.Player).ControllerId;
                if (Class'UIInteraction'.static.IsLoggedIn(ControllerId))
                {
                    bCanWriteSave = TRUE;
                }
            }
            if (Class'WorldInfo'.static.IsConsoleBuild(0) && bCanWriteSave)
            {
                m_bSpecialTriggerDeviceSelection = FALSE;
                ChooseStorageDevice();
            }
            else
            {
                oPanel.InvokeMethod("nameEntryComplete");
            }
        }
    }
    else
    {
        oKeyboard = None;
        oPanel.InvokeMethod("nameEntryCancelled");
        StopGuiVoice();
    }
}
public function OnCreatePlaceholderCareer(SFXSaveGameCommandEventArgs Args)
{
    if (!Args.bSuccess)
    {
        ChooseStorageDevice();
    }
    else if (!m_bSpecialTriggerDeviceSelection)
    {
        oPanel.InvokeMethod("nameEntryComplete");
    }
}
public function OnDeviceSelectionComplete_Fallback(bool bWasSuccessful, bool bWasBlocked)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local PlayerController PC;
    local int ControllerId;
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local int DeviceID;
    local string DeviceName;
    
    PC = GetPC();
    ControllerId = LocalPlayer(PC.Player).ControllerId;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    if (PlayerIntEx != None)
    {
        PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete_Fallback);
    }
    if (bWasSuccessful)
    {
        if (PlayerIntEx != None)
        {
            DeviceID = PlayerIntEx.GetDeviceSelectionResults(byte(LocalPlayer(PC.Player).ControllerId), DeviceName);
            BioPlayerController(PC).SetDeviceID(DeviceID);
            bXboxStorageDeviceSelected = TRUE;
        }
        ConfirmCharacterCreationEnd(TRUE, 0);
    }
    else
    {
        if (bWasBlocked)
        {
        }
        messageBox = GetSFXUIController().CreateMessageBox(GetPC());
        messageBox.SetInputDelegate(ConfirmDeviceSelection_Fallback);
        Params.srAText = ConfirmSelectDevice;
        Params.srBText = CancelSelectDevice;
        Params.bNoFade = TRUE;
        messageBox.DisplayMessageBox(NoSaveDevice, Params);
    }
}
public function OnUIUnblock(bool Unblocked)
{
    if (!Unblocked)
    {
        ChooseStorageDevice();
    }
}
public final function PopulateCustomFaceList()
{
    local int i;
    local int J;
    local int nNumCategories;
    local int nNumSliders;
    local ASParams stParam;
    local array<ASParams> lstCategoryParams;
    local array<ASParams> lstSliderParams;
    
    stParam.Type = ASParamTypes.ASParam_Integer;
    lstCategoryParams.AddItem(stParam);
    lstCategoryParams.AddItem(stParam);
    lstCategoryParams.AddItem(stParam);
    lstSliderParams.AddItem(stParam);
    lstSliderParams.AddItem(stParam);
    lstSliderParams.AddItem(stParam);
    lstSliderParams.AddItem(stParam);
    lstSliderParams.AddItem(stParam);
    lstSliderParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_Boolean;
    lstSliderParams.AddItem(stParam);
    nNumCategories = m_oBioMorphFrontEnd.GetNumberOfFeatureCategories();
    oPanel.InvokeMethod("clearSliderData");
    for (i = 0; i < nNumCategories; i++)
    {
        lstCategoryParams[0].nVar = i;
        lstCategoryParams[1].nVar = m_oBioMorphFrontEnd.GetCategoryString(i);
        lstCategoryParams[2].nVar = int(srFacialCategoryDescription);
        oPanel.InvokeMethodArgs("populateFaceTitleChoice", lstCategoryParams);
        nNumSliders = m_oBioMorphFrontEnd.GetNumSlidersInCategory(i);
        lstSliderParams[0].nVar = i;
        for (J = 0; J < nNumSliders; J++)
        {
            lstSliderParams[1].nVar = m_oBioMorphFrontEnd.GetSliderLabel(i, J);
            lstSliderParams[2].nVar = m_oBioMorphFrontEnd.GetSliderDesc(i, J);
            lstSliderParams[3].nVar = m_oBioMorphFrontEnd.GetSliderMin(i, J);
            lstSliderParams[4].nVar = m_oBioMorphFrontEnd.GetSliderMax(i, J);
            lstSliderParams[5].nVar = m_oBioMorphFrontEnd.GetSliderStep(i, J);
            lstSliderParams[6].bVar = m_oBioMorphFrontEnd.GetSliderNotched(i, J);
            oPanel.InvokeMethodArgs("AddCategorySlider", lstSliderParams);
        }
    }
}
public function RefitBonusTalent(Name BonusTalent)
{
    local int idx;
    local SFXPowerCustomActionBase Power;
    local PlayerController PC;
    local BioPawn ResultPawn;
    local bool bLastBonusHadRanks;
    local int Rank1Cost;
    local int Refund;
    local float Rank;
    local bool bHadBonusPower;
    
    PC = GetPC();
    ResultPawn = BioPawn(PC.Pawn);
    bHadBonusPower = FALSE;
    for (idx = ResultPawn.PowerManager.Powers.Length - 1; idx >= 0; idx--)
    {
        Power = ResultPawn.PowerManager.Powers[idx];
        if (Power != None)
        {
            if (Power.IsBonusPower)
            {
                bHadBonusPower = TRUE;
                if (Power.Rank > Rank)
                {
                    bHadBonusPower = TRUE;
                    bLastBonusHadRanks = TRUE;
                    Rank = Power.Rank;
                    Refund = Class'SFXPowerManager'.static.GetRefundAmount(Power.Class, int(Power.Rank));
                    if (Power.RankCosts.Length > 0)
                    {
                        Rank1Cost = Power.RankCosts[0];
                    }
                    else
                    {
                        Rank1Cost = 1;
                    }
                    Refund -= Rank1Cost;
                }
                ResultPawn.PowerManager.RemovePower(Power.Class);
            }
        }
    }
    Power = ResultPawn.PowerManager.AddPowerByClassName(BonusTalent);
    if (Power != None)
    {
        if (Refund > 0)
        {
            ResultPawn.AddTalentPoints(Refund);
        }
        if (bHadBonusPower)
        {
            if (bLastBonusHadRanks)
            {
                Power.Rank = 1.0;
            }
        }
        else
        {
            Power.Rank = 1.0;
        }
    }
}
public function ResetLookAt()
{
    NextLookAtTarget = NewCharacterLookAtTarget.NCLAT_Ahead;
    fLookAtUpDownValue = 0.0;
    bLookAtUpDownNulling = TRUE;
    fLookAtLeftRightValue = 0.0;
    bLookAtLeftRightNulling = TRUE;
}
public function ScrollText(float fValue)
{
    local array<ASParams> lstParams;
    local ASParams aParam;
    
    if (Abs(fValue) <= 0.0000999999975)
    {
        if (m_bStopScroll)
        {
            oPanel.InvokeMethod("StopInfoScroll");
            m_bStopScroll = FALSE;
        }
        return;
    }
    aParam.Type = ASParamTypes.ASParam_Float;
    aParam.fVar = fValue * float(m_nInfoScrollSpeed);
    lstParams.AddItem(aParam);
    oPanel.InvokeMethodArgs("ScrollInfoText", lstParams);
    m_bStopScroll = TRUE;
}
public final function SelectNextPregeneratedHead()
{
    local int NumPregeneratedHeads;
    
    NumPregeneratedHeads = m_bMaleSelected ? MalePregeneratedHeadCodes.Length : FemalePregeneratedHeadCodes.Length;
    ++CurrentPregeneratedHeadIndex;
    if (CurrentPregeneratedHeadIndex >= NumPregeneratedHeads)
    {
        CurrentPregeneratedHeadIndex = NumPregeneratedHeads != 0 ? 0 : -1;
    }
    if (CurrentPregeneratedHeadIndex >= 0)
    {
        ApplyNewCode(m_bMaleSelected ? MalePregeneratedHeadCodes[CurrentPregeneratedHeadIndex] : FemalePregeneratedHeadCodes[CurrentPregeneratedHeadIndex]);
        SetSliderPositions();
        UpdateCode();
    }
}
public final function SelectPreviousPregeneratedHead()
{
    local int NumPregeneratedHeads;
    
    NumPregeneratedHeads = m_bMaleSelected ? MalePregeneratedHeadCodes.Length : FemalePregeneratedHeadCodes.Length;
    --CurrentPregeneratedHeadIndex;
    if (CurrentPregeneratedHeadIndex < 0)
    {
        CurrentPregeneratedHeadIndex = NumPregeneratedHeads - 1;
    }
    if (CurrentPregeneratedHeadIndex >= 0)
    {
        ApplyNewCode(m_bMaleSelected ? MalePregeneratedHeadCodes[CurrentPregeneratedHeadIndex] : FemalePregeneratedHeadCodes[CurrentPregeneratedHeadIndex]);
        SetSliderPositions();
        UpdateCode();
    }
}
public function SetBackgroundMaterial(MaterialInterface Material)
{
    local BioUIWorld oUIWorld;
    
    oUIWorld = oWorldInfo.m_UIWorld;
    if (oUIWorld != None)
    {
        if (Material != None)
        {
            oUIWorld.SetObjectVariable('BackgroundMaterial', Material);
            oUIWorld.TriggerEvent('UpdateBackgroundMaterial', oWorldInfo);
        }
        else
        {
            oUIWorld.TriggerEvent('ClearBackgroundMaterial', oWorldInfo);
        }
    }
}
public function SetClassClientEffects(RvrClientEffectInterface CE_FullBiotic, RvrClientEffectInterface CE_HalfBiotic, RvrClientEffectInterface CE_OmniTool)
{
    local BioUIWorld oUIWorld;
    
    oUIWorld = oWorldInfo.m_UIWorld;
    if (oUIWorld != None)
    {
        oUIWorld.m_CE_FullBiotic = CE_FullBiotic;
        oUIWorld.m_CE_HalfBiotic = CE_HalfBiotic;
        oUIWorld.m_CE_OmniTool = CE_OmniTool;
    }
}
public final function SetCustomModel()
{
    oWorldInfo.m_UIWorld.UpdateAppearance(GenderTemplatePawn(m_nCurrentTemplate), SchematicAnimSet);
    oWorldInfo.m_UIWorld.AddDeferredOperation(ApplyManualScar, GenderTemplatePawn(m_nCurrentTemplate));
    m_nLastInitializedTemplate = m_nCurrentTemplate;
}
public final function SetCustomName(string sMaleName, string sFemaleName)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    local string sConfirmNameString;
    
    m_sMaleName = sMaleName;
    m_sFemaleName = sFemaleName;
    ClearCustomTokens();
    SetCustomToken(0, m_bMaleSelected ? sMaleName : sFemaleName);
    sConfirmNameString = GetUIString(srConfirm, TRUE);
    ClearCustomTokens();
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = sMaleName;
    lstParams.AddItem(stParam);
    stParam.sVar = sFemaleName;
    lstParams.AddItem(stParam);
    stParam.sVar = sConfirmNameString;
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("setCustomName", lstParams);
}
public final function SetDefaultFemaleME2SaveProperties(const out MorphHeadSaveRecord InProperties)
{
    DefaultFemaleME2SaveProperties = InProperties;
    bValidateImportedHead = TRUE;
}
public function SetGameTypeSettings(int GameType)
{
    local SFXProfileSettings Profile;
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        Profile = PC.ProfileSettings;
    }
    switch (GameType)
    {
        case 0:
            Profile.SetAutoReplyMode(2);
            Profile.SetDifficultyConfigOption(2);
            Profile.SetProfileSettingValueId(34, 2);
            break;
        case 1:
            Profile.SetAutoReplyMode(0);
            Profile.SetProfileSettingValueId(34, 0);
            break;
        default:
            Profile.SetAutoReplyMode(0);
            Profile.SetDifficultyConfigOption(0);
            Profile.SetProfileSettingValueId(34, 2);
            break;
    }
}
public function SetMaleSelected(bool bSelected)
{
    local BioUIWorld oUIWorld;
    
    oUIWorld = oWorldInfo.m_UIWorld;
    if (oUIWorld != None)
    {
        oUIWorld.SetBoolVariable('bIsMaleCharacterCreation', bSelected);
    }
    m_bMaleSelected = bSelected || bSkipCharacterCreation;
}
public function SetOnCloseCallback(delegate<OnCloseCallback> fn_OnCloseDelegate)
{
    __OnCloseCallback__Delegate = fn_OnCloseDelegate;
}
public final function SetPlayerCharacter(const out array<string> playerSettings)
{
    local BioPawn Pawn;
    local BioMorphFace MorphHead;
    local SFXEngine Engine;
    
    if (int(playerSettings[5]) == 0)
    {
        m_nCurrentTemplate = BioNewCharacterTemplates.BNCT_ICONIC;
        m_sMaleName = string(srCustomMaleName);
        m_sFemaleName = string(srCustomFemaleName);
    }
    if (m_nCurrentTemplate == BioNewCharacterTemplates.BNCT_CUSTOM)
    {
        Pawn = GenderTemplatePawn(1);
    }
    else if (m_nCurrentTemplate == BioNewCharacterTemplates.BNCT_IMPORTED)
    {
        Pawn = GenderTemplatePawn(2);
    }
    else
    {
        Pawn = GenderTemplatePawn(0);
    }
    MorphHead = Pawn.MorphHead;
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    Engine.bNewPlayer = TRUE;
    Engine.NewPlayer.CharacterClass = SFXGame(oWorldInfo.Game).GetCharacterClassByName(playerSettings[0]);
    Engine.NewPlayer.bIsFemale = !m_bMaleSelected && !bSkipCharacterCreation;
    Engine.NewPlayer.firstName = m_bMaleSelected ? m_sMaleName : m_sFemaleName;
    Engine.NewPlayer.Origin = byte(int(playerSettings[2]));
    Engine.NewPlayer.Notoriety = byte(int(playerSettings[3]));
    Engine.NewPlayer.MorphHead = MorphHead;
    if (int(playerSettings[4]) > -1 && int(playerSettings[4]) < UnlockedBonusTalents.Length)
    {
        Engine.NewPlayer.BonusTalentClass = UnlockedBonusTalents[int(playerSettings[4])].PowerClassName;
    }
    else
    {
        Engine.NewPlayer.BonusTalentClass = 'None';
    }
    if (m_nCurrentTemplate == BioNewCharacterTemplates.BNCT_CUSTOM)
    {
        Engine.NewPlayer.faceCode = sCustomFaceCode;
    }
    else if (m_nCurrentTemplate == BioNewCharacterTemplates.BNCT_IMPORTED)
    {
        Engine.NewPlayer.faceCode = sImportedFaceCode;
    }
    else
    {
        Engine.NewPlayer.faceCode = "";
    }
    Engine.NewPlayer.CharacterGUID = Class'SFXEngine'.static.CreateGUID();
    SetGameTypeSettings(int(playerSettings[5]));
    SetSquadMemberPlotChoice(int(playerSettings[6]));
    m_bCustomShepard = Engine.NewPlayer.faceCode != "";
}
public final function SetPlotChoices()
{
    local BioGlobalVariableTable VarTable;
    
    VarTable = oWorldInfo.GetGlobalVariables();
    switch (m_ePlotChoice)
    {
        case EPlotChoice.EPlotChoice_AshleyDies:
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Ash, FALSE);
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Kaidan, TRUE);
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanFemale, FALSE);
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanMale, TRUE);
            break;
        case EPlotChoice.EPlotChoice_KaidenDies:
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Ash, TRUE);
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__CH2_Virmire__The_Choice__Rescued_Kaidan, FALSE);
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanFemale, TRUE);
            VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3__ME1_Plots_for_ME3__Utility__Henchman__InParty__HumanMale, FALSE);
            break;
        case EPlotChoice.EPlotChoice_None:
        default:
            break;
    }
}
public function SetSchematicResources(RvrClientEffectInterface CE_NewSchematicEffect, AnimSet NewSchematicAnimSet)
{
    local BioUIWorld oUIWorld;
    
    oUIWorld = oWorldInfo.m_UIWorld;
    if (oUIWorld != None)
    {
        CE_SchematicEffect = CE_NewSchematicEffect;
        SchematicAnimSet = NewSchematicAnimSet;
    }
}
public final function SetSliderPositions()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    local int nNumCategories;
    local int nNumSliders;
    local int i;
    local int J;
    
    stParam.Type = ASParamTypes.ASParam_Integer;
    lstParams.AddItem(stParam);
    lstParams.AddItem(stParam);
    lstParams.AddItem(stParam);
    nNumCategories = m_oBioMorphFrontEnd.GetNumberOfFeatureCategories();
    for (i = 0; i < nNumCategories; ++i)
    {
        nNumSliders = m_oBioMorphFrontEnd.GetNumSlidersInCategory(i);
        for (J = 0; J < nNumSliders; ++J)
        {
            lstParams[0].nVar = i + 1;
            lstParams[1].nVar = J;
            lstParams[2].nVar = m_oBioMorphFrontEnd.GetSliderValue(i, J);
            oPanel.InvokeMethodArgs("SetSliderValue", lstParams);
        }
    }
}
public function SetSquadMemberPlotChoice(int nChoice)
{
    local BioWorldInfo WorldInfo;
    
    WorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (WorldInfo != None)
    {
        switch (nChoice)
        {
            case 1:
                m_ePlotChoice = EPlotChoice.EPlotChoice_KaidenDies;
                break;
            case 2:
                m_ePlotChoice = EPlotChoice.EPlotChoice_AshleyDies;
                break;
            default:
                m_ePlotChoice = EPlotChoice.EPlotChoice_None;
                break;
        }
    }
    else
    {
        m_ePlotChoice = EPlotChoice.EPlotChoice_None;
    }
}
public function SetUIPawnCasual(bool bCasual)
{
    local BioWorldInfo oWI;
    local BioPlayerController PC;
    local SFXPawn_Player oPlayerPawn;
    
    if (oWorldInfo != None)
    {
        oWI = oWorldInfo;
        if (oWI != None)
        {
            PC = oWI.GetLocalPlayerController();
            if (PC != None)
            {
                oPlayerPawn = SFXPawn_Player(PC.Pawn);
                if (oPlayerPawn != None)
                {
                    oPlayerPawn = SFXPawn_Player(oWI.m_UIWorld.GetSpawnedActor(oPlayerPawn));
                    if (oPlayerPawn != None)
                    {
                        oPlayerPawn.bUseCasualAppearance = bCasual;
                    }
                }
            }
        }
    }
}
public final function SetupIconicCharacter(const out array<string> lstSettings)
{
    local PlayerInfoEx PlayerInfo;
    local SFXEngine Engine;
    
    PlayerInfo.bIsFemale = !m_bMaleSelected && !bSkipCharacterCreation;
    PlayerInfo.firstName = m_bMaleSelected ? m_sMaleName : m_sFemaleName;
    PlayerInfo.CharacterClass = lstSpawnableClasses[m_nDefaultClass];
    PlayerInfo.Origin = byte(m_nDefaultOrigin + 1);
    PlayerInfo.Notoriety = byte(m_nDefaultNotoriety + 1);
    PlayerInfo.BonusTalentClass = UnlockedBonusTalents[int(lstSettings[1])].PowerClassName;
    PlayerInfo.faceCode = "";
    PlayerInfo.CharacterGUID = Class'SFXEngine'.static.CreateGUID();
    SetGameTypeSettings(int(lstSettings[2]));
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    Engine.bNewPlayer = FALSE;
    Engine.ProgressPlayer = PlayerInfo;
    m_bCustomShepard = FALSE;
}
public final function SetupSummary()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = int(m_nDataOrigin);
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_Boolean;
    stParam.bVar = m_bMaleSelected == FALSE;
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = m_nDefaultOrigin;
    lstParams.AddItem(stParam);
    stParam.nVar = m_nDefaultNotoriety;
    lstParams.AddItem(stParam);
    stParam.nVar = m_nDefaultClass;
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("initializeSequenceDetails", lstParams);
}
public function SpawnPawns()
{
    local int idx;
    local Pawn PawnArchetype;
    local SFXGUIInteraction oManager;
    
    oManager = GetSFXUIController();
    if (m_bMaleSelected)
    {
        PawnArchetype = Pawn(Class'SFXEngine'.static.GetSeekFreeObject(SFXGame(oWorldInfo.Game).MCharCreationArchName, Class'SFXPawn_Player'));
    }
    else
    {
        PawnArchetype = Pawn(Class'SFXEngine'.static.GetSeekFreeObject(SFXGame(oWorldInfo.Game).FCharCreationArchName, Class'SFXPawn_Player'));
    }
    if (oManager.ImportedTemplatePawn != None)
    {
        lstTemplates[2].Spawned = oManager.ImportedTemplatePawn;
    }
    oManager.ImportedTemplatePawn = None;
    for (idx = 0; idx < 3; idx++)
    {
        lstTemplates[idx].Spawned = oWorldInfo.Game.Spawn(Class'SFXPawn_PlayerSoldierNonCombat', None, , , , PawnArchetype, TRUE);
        EnsureMICs(lstTemplates[idx].Spawned);
        lstTemplates[idx].Spawned.SetCollision(TRUE, FALSE, TRUE);
        lstTemplates[idx].Spawned.SetHidden(TRUE);
    }
    CurrentMorphFace = m_oBioMorphFrontEnd.Initialize(m_bMaleSelected ? MaleDataSource : FemaleDataSource, TRUE);
    if ((m_nDataOrigin == EDataOrigin.DataOrigin_ME2 || m_nDataOrigin == EDataOrigin.DataOrigin_ME3) && sImportedFaceCode != "")
    {
        m_oBioMorphFrontEnd.ApplyFaceCode(sImportedFaceCode);
        CurrentMorphFace.ApplyToActor(GenderTemplatePawn(2));
        InsertDefaultPregeneratedHead(sImportedFaceCode);
    }
    SelectNextPregeneratedHead();
    CurrentMorphFace.ApplyToActor(GenderTemplatePawn(1));
}
public final function Update3DModel(BioNewCharacterTemplates nTemplate, BioPawn SwapoutPawn)
{
    local BioWorldInfo oBWI;
    
    oBWI = oWorldInfo;
    oBWI.m_UIWorld.SwapPawn(SwapoutPawn, 'CharCreatePawn', GenderTemplatePawn(nTemplate), lstTemplates[int(nTemplate)].UIWorldVar);
    lstTemplates[int(m_nCurrentTemplate)].UIWorldVar = lstTemplates[int(nTemplate)].UIWorldVar;
    m_nCurrentTemplate = nTemplate;
    oWorldInfo.m_UIWorld.SetAnimSet(GenderTemplatePawn(m_nCurrentTemplate), SchematicAnimSet);
}
public final function Update3DModelState(BioNewCharacterTemplates nTemplate, BioPawn PrevPawn)
{
    oWorldInfo.SetGlobalTlk(m_bMaleSelected, FALSE);
    Update3DModel(nTemplate, PrevPawn);
    if (nTemplate == BioNewCharacterTemplates.BNCT_CUSTOM)
    {
        ApplyNewCode(sCustomFaceCode);
    }
    else if (nTemplate == BioNewCharacterTemplates.BNCT_IMPORTED && sImportedFaceCode != "")
    {
        ApplyNewCode(sImportedFaceCode);
    }
}
public final function UpdateBonusTalentList()
{
    local int i;
    local ASParams currentParameter;
    local array<ASParams> Parameters;
    
    GetAllUnlockedBonusTalentInfo(UnlockedBonusTalents);
    currentParameter.Type = ASParamTypes.ASParam_Integer;
    currentParameter.nVar = UnlockedBonusTalents.Length;
    Parameters.AddItem(currentParameter);
    oPanel.InvokeMethodArgs("createTalentList", Parameters);
    Parameters.Length = 0;
    currentParameter.Type = ASParamTypes.ASParam_Integer;
    Parameters.AddItem(currentParameter);
    Parameters.AddItem(currentParameter);
    Parameters.AddItem(currentParameter);
    Parameters.AddItem(currentParameter);
    for (i = 0; i < UnlockedBonusTalents.Length; ++i)
    {
        Parameters[0].nVar = i;
        Parameters[1].nVar = i;
        Parameters[2].nVar = int(UnlockedBonusTalents[i].srChoiceTitle);
        Parameters[3].nVar = int(UnlockedBonusTalents[i].srChoiceDescription);
        oPanel.InvokeMethodArgs("populateTalentChoice", Parameters);
    }
}
public function UpdateCode()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    sCustomFaceCode = m_oBioMorphFrontEnd.GenerateFaceCode();
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = sCustomFaceCode;
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("setFaceCode", lstParams);
}
public final function UpdateCurrentMorphAppearance()
{
    oWorldInfo.m_UIWorld.AddDeferredOperation(UpdateUIWorldMorphFace, GenderTemplatePawn(m_nCurrentTemplate));
}
public final function UpdateCustomClassChoice(Class<SFXCharacterClass> PlayerClass, int Row)
{
    local ASParams currentParameter;
    local array<ASParams> Parameters;
    
    currentParameter.Type = ASParamTypes.ASParam_Integer;
    currentParameter.nVar = Row;
    Parameters.AddItem(currentParameter);
    currentParameter.Type = ASParamTypes.ASParam_String;
    currentParameter.sVar = PlayerClass.default.className;
    Parameters.AddItem(currentParameter);
    currentParameter.Type = ASParamTypes.ASParam_Integer;
    currentParameter.nVar = PlayerClass.default.srClassName;
    Parameters.AddItem(currentParameter);
    currentParameter.nVar = PlayerClass.default.srClassDesc;
    Parameters.AddItem(currentParameter);
    currentParameter.nVar = PlayerClass.default.srClassPrimaryDesc;
    Parameters.AddItem(currentParameter);
    currentParameter.nVar = PlayerClass.default.srClassSecondaryDesc;
    Parameters.AddItem(currentParameter);
    oPanel.InvokeMethodArgs("populateClassChoice", Parameters);
}
public function UpdateCustomClassList()
{
    local ASParams currentParameter;
    local array<ASParams> Parameters;
    local int nClassIdx;
    
    currentParameter.Type = ASParamTypes.ASParam_Integer;
    currentParameter.nVar = 6;
    Parameters.AddItem(currentParameter);
    oPanel.InvokeMethodArgs("createClassList", Parameters);
    for (nClassIdx = 0; nClassIdx < lstCharacterClasses.Length; ++nClassIdx)
    {
        UpdateCustomClassChoice(lstCharacterClasses[nClassIdx], nClassIdx);
    }
}
public function UpdateLookAtTarget()
{
    local Name LookAtTarget;
    
    if (int(CurrentLookAtTarget) != int(NextLookAtTarget))
    {
        fLookAtUpDownValue = 0.0;
        fLookAtLeftRightValue = 0.0;
        LookAtTarget = 'None';
        switch (NextLookAtTarget)
        {
            case NewCharacterLookAtTarget.NCLAT_Ahead:
                LookAtTarget = 'CharCreateLookNull';
                break;
            case NewCharacterLookAtTarget.NCLAT_Left:
                LookAtTarget = 'CharCreateLookLeft';
                break;
            case NewCharacterLookAtTarget.NCLAT_Right:
                LookAtTarget = 'CharCreateLookRight';
                break;
            case NewCharacterLookAtTarget.NCLAT_Up:
                LookAtTarget = 'CharCreateLookUp';
                break;
            case NewCharacterLookAtTarget.NCLAT_Down:
                LookAtTarget = 'CharCreateLookDown';
                break;
            default:
        }
        if (LookAtTarget != 'None')
        {
            oWorldInfo.m_UIWorld.TriggerEvent(LookAtTarget, oWorldInfo);
        }
        CurrentLookAtTarget = NextLookAtTarget;
    }
}
public function UpdateUIWorldMorphFace(Object InData)
{
    local SFXPawn_Player SourceTemplate;
    local Actor TargetActor;
    
    SourceTemplate = SFXPawn_Player(InData);
    if (SourceTemplate != None)
    {
        TargetActor = oWorldInfo.m_UIWorld.GetSpawnedActor(SourceTemplate);
        if (TargetActor != None && SourceTemplate.MorphHead == CurrentMorphFace)
        {
            CurrentMorphFace.ApplyToActor(TargetActor);
        }
    }
    ApplyManualScar(InData);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioMorphFaceFrontEnd Name=MorphEditor0
    End Object
    lstSpawnableClasses = (Class'SFXPawn_PlayerSoldier', Class'SFXPawn_PlayerInfiltrator', Class'SFXPawn_PlayerVanguard', Class'SFXPawn_PlayerSentinel', Class'SFXPawn_PlayerAdept', Class'SFXPawn_PlayerEngineer')
    BonusTalents = ({
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Carnage', 
                     BonusPowerID = 1, 
                     srChoiceName = $668831, 
                     srChoiceTitle = $668831, 
                     oChoiceImage = None, 
                     srChoiceDescription = $690808
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Marksman', 
                     BonusPowerID = 2, 
                     srChoiceName = $572088, 
                     srChoiceTitle = $572088, 
                     oChoiceImage = None, 
                     srChoiceDescription = $572089
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_ProximityMine', 
                     BonusPowerID = 4, 
                     srChoiceName = $572665, 
                     srChoiceTitle = $572665, 
                     oChoiceImage = None, 
                     srChoiceDescription = $658547
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Decoy', 
                     BonusPowerID = 8, 
                     srChoiceName = $674631, 
                     srChoiceTitle = $674631, 
                     oChoiceImage = None, 
                     srChoiceDescription = $690836
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_ProtectorDrone', 
                     BonusPowerID = 16, 
                     srChoiceName = $663224, 
                     srChoiceTitle = $663224, 
                     oChoiceImage = None, 
                     srChoiceDescription = $690854
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_EnergyDrain', 
                     BonusPowerID = 32, 
                     srChoiceName = $205894, 
                     srChoiceTitle = $205894, 
                     oChoiceImage = None, 
                     srChoiceDescription = $205895
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_InfernoGrenade', 
                     BonusPowerID = 64, 
                     srChoiceName = $349055, 
                     srChoiceTitle = $349055, 
                     oChoiceImage = None, 
                     srChoiceDescription = $349060
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Reave', 
                     BonusPowerID = 128, 
                     srChoiceName = $314878, 
                     srChoiceTitle = $314878, 
                     oChoiceImage = None, 
                     srChoiceDescription = $314879
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Stasis', 
                     BonusPowerID = 256, 
                     srChoiceName = $127059, 
                     srChoiceTitle = $127059, 
                     oChoiceImage = None, 
                     srChoiceDescription = $365834
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_WarpAmmo', 
                     BonusPowerID = 512, 
                     srChoiceName = $326671, 
                     srChoiceTitle = $326671, 
                     oChoiceImage = None, 
                     srChoiceDescription = $326672
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Barrier', 
                     BonusPowerID = 1024, 
                     srChoiceName = $93973, 
                     srChoiceTitle = $93973, 
                     oChoiceImage = None, 
                     srChoiceDescription = $155065
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_GethShieldBoost', 
                     BonusPowerID = 2048, 
                     srChoiceName = $314066, 
                     srChoiceTitle = $314066, 
                     oChoiceImage = None, 
                     srChoiceDescription = $314067
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Fortification', 
                     BonusPowerID = 4096, 
                     srChoiceName = $314036, 
                     srChoiceTitle = $314036, 
                     oChoiceImage = None, 
                     srChoiceDescription = $314037
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_ArmorPiercingAmmo', 
                     BonusPowerID = 8192, 
                     srChoiceName = $93965, 
                     srChoiceTitle = $93965, 
                     oChoiceImage = None, 
                     srChoiceDescription = $155053
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Slam', 
                     BonusPowerID = 16384, 
                     srChoiceName = $542178, 
                     srChoiceTitle = $542178, 
                     oChoiceImage = None, 
                     srChoiceDescription = $716449
                    }, 
                    {
                     PowerClassName = 'SFXGameContent.SFXPowerCustomAction_DarkChannel', 
                     BonusPowerID = 32768, 
                     srChoiceName = $716448, 
                     srChoiceTitle = $716448, 
                     oChoiceImage = None, 
                     srChoiceDescription = $716450
                    }
                   )
    NewGameStartingCodexEntries = (22035, 
                                   22036, 
                                   22037, 
                                   22001, 
                                   22002, 
                                   22003, 
                                   22004, 
                                   22005, 
                                   22006, 
                                   22007, 
                                   22009, 
                                   22010, 
                                   22258, 
                                   22024, 
                                   22025, 
                                   22026, 
                                   22029, 
                                   22030, 
                                   22040, 
                                   22038, 
                                   22063, 
                                   22064, 
                                   22065, 
                                   22228, 
                                   22297, 
                                   22042, 
                                   22043, 
                                   22044, 
                                   22045, 
                                   22046, 
                                   22048, 
                                   22049, 
                                   22051, 
                                   22052, 
                                   22053, 
                                   22054, 
                                   22056, 
                                   22057, 
                                   22058, 
                                   22059, 
                                   21708, 
                                   22284, 
                                   22283, 
                                   22298, 
                                   21742, 
                                   22295, 
                                   22296, 
                                   22066, 
                                   22067, 
                                   21747, 
                                   22285, 
                                   22294
                                  )
    MalePregeneratedHeadCodes = ("541DJDLTFA3GAAVJBDMDJ6PGG72AG96455", "122WK5RGIS3RMANEDBSLG39WWK6CR28345", "532ISMG8MP3EFHQW5DGLC48L9NCEBG8465", "121AIKGMWW1AJCWGDEM8669EWF6AJAB435", "5511IABM1M46JG1FBBED733F1G13995365", "313WNMRB8H3IGMPMBBN7P2RNJ84AU3A356", "453WE1A71171H1T175S8932D1J2C84E356")
    FemalePregeneratedHeadCodes = ("743Q9GM17F8AJDQ65Q1DA8119664126G5177", "233LPIK9E485QCJ79J1DH419C719I52G6316", "722W89Q9E417FMAA9LCFD4C1C7CHW2AG5315", "9413IIIR1M9HFPK25Q6R91D1G179B43B4317", "13116BII179JJL66BM9MG71BD66412D35176", "552ELIHAE425CLHE26PDH2G1L426L6426573", "411A8JII1791ILF7DT9AK9ADLC92A6B66616")
    DefaultFemaleME2HeadCode = "743.Q9G.M17.F8A.JDQ.62Q.1DA.711.966.414.6G6.177"
    m_nmAllianceComputerPleaseLogin = 'AllianceComputerPleaseLogin'
    srCustomMaleName = $158528
    srCustomFemaleName = $158529
    srNewCharConfirm = $168235
    srNewCharCancel = $168236
    srNewCharQuestion = $168237
    srFacialCategoryDescription = $168957
    srConfirm = $144879
    srSetName = $341392
    srSetCode = $344612
    srFailedToFindFaceCode = $727416
    m_nDefaultClass = 4
    srNameTitle = $341392
    nMaxNameLength = 11
    srCodeTitle = $344612
    nMaxCodeLength = 47
    m_nInfoScrollSpeed = 1
    NoSaveDevice = $343733
    ConfirmSelectDevice = $346042
    CancelSelectDevice = $346043
    CurrentPregeneratedHeadIndex = -1
    m_oBioMorphFrontEnd = MorphEditor0
    m_bMaleSelected = TRUE
    bEnsureValidFaceCodeOnImport = TRUE
    m_nCurrentTemplate = None
    m_nLastInitializedTemplate = None
    CurrentLookAtTarget = None
    nHandlerID = 9
}