Class SFXSFHandler_Personalization extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

struct TintSwatchData 
{
    var int SwatchID;
    var LinearColor SwatchColor;
};
enum ESFXPersonalizationOption
{
    SFXPersOpt_Casual,
    SFXPersOpt_Type,
    SFXPersOpt_Helmet,
    SFXPersOpt_Torso,
    SFXPersOpt_Shoulder,
    SFXPersOpt_Arm,
    SFXPersOpt_Leg,
    SFXPersOpt_Spec,
    SFXPersOpt_Pattern,
    SFXPersOpt_PatternColor,
    SFXPersOpt_Tint1,
    SFXPersOpt_Tint2,
    SFXPersOpt_Emissive,
};

var transient array<Class<SFXGameEffect>> CachedBonusGameEffectClasses;
var array<Object> m_ApperanceAssetCache;
var config array<stringref> srBonus;
var config array<string> ArmorBonusClassName;
var config string srRotate;
var config string srButtonRevertChanges;
var config string srButtonShowInfo;
var config string srButtonHideInfo;
var config string srButtonBack;
var config string srButtonSelect;
var config string srButtonExpand;
var delegate<ExternalCallback_OnComplete> __ExternalCallback_OnComplete__Delegate;
var transient BioWorldInfo m_WorldInfo;
var transient SFXPawn_Player m_oUIWorldPawn;
var transient SFXPawn_Player m_oPlayerPawn;
var int m_nRotating;
var config float RotationDegreesPerSecond;
var config float AssetReleaseMemoryThreshold;
var config float ForceGCMemoryThreshold;
var config stringref CasualOptionTitle;
var config stringref TypeOptionTitle;
var config stringref HelmetOptionTitle;
var config stringref TorsoOptionTitle;
var config stringref ShoulderOptionTitle;
var config stringref ArmOptionTitle;
var config stringref LegOptionTitle;
var config stringref SpecOptionTitle;
var config stringref Tint1OptionTitle;
var config stringref Tint2OptionTitle;
var config stringref PatternOptionTitle;
var config stringref PatternColorOptionTitle;
var config stringref EmissiveOptionTitle;
var int CasualID;
var int FullBodyID;
var int HelmetID;
var int TorsoID;
var int ShoulderID;
var int ArmID;
var int LegID;
var int SpecID;
var int Tint1ID;
var int Tint2ID;
var int PatternID;
var int PatternColorID;
var int EmissiveID;
var stringref ArmorEffectDescriptionFormatter;
var bool m_bStopScroll;
var transient bool m_bLoadingWidgetVisible;
var transient bool m_bGameEffectLoadingComplete;
var EPlayerAppearanceType CombatAppearance;

public final simulated native function ConditionalReleaseAssetCacheAndGC();

public delegate function ExternalCallback_OnComplete();

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            if (Abs(fValue) <= 0.300000012)
            {
                if (m_bStopScroll)
                {
                    ASStopScroll();
                    m_bStopScroll = FALSE;
                }
                return TRUE;
            }
            ASScrollInfoText(fValue);
            m_bStopScroll = TRUE;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_X:
            if (fValue < -0.300000012)
            {
                m_nRotating = 1;
            }
            else if (fValue > 0.300000012)
            {
                m_nRotating = -1;
            }
            else
            {
                m_nRotating = 0;
            }
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public event function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetExternalInterface(Self);
    PlayGuiSound('PersonalizeOpen');
    LoadGameEffects();
}
public function OnPanelRemoved()
{
    local string ArmorBonusClassIter;
    
    PlayGuiSound('PersonalizeExit');
    Super.OnPanelRemoved();
    if (m_oUIWorldPawn != None && m_oUIWorldPawn.IsUpdatingAppearanceAsync())
    {
        m_oUIWorldPawn.AbortAsyncUpdateAppearance();
    }
    m_oUIWorldPawn = None;
    if (m_bLoadingWidgetVisible)
    {
        GetSFXUIController().GetSaveLoadWidget().HideLoadingMessage(TRUE);
    }
    if (m_WorldInfo != None)
    {
        if (m_WorldInfo.m_UIWorld != None)
        {
            if (m_oPlayerPawn != None)
            {
                m_WorldInfo.m_UIWorld.DestroyPawn(m_oPlayerPawn);
            }
            m_WorldInfo.m_UIWorld.ResetActors();
            m_WorldInfo.m_UIWorld.TriggerEvent('LightsOff', m_WorldInfo);
            m_WorldInfo.m_UIWorld.FlushPendingCommands();
        }
    }
    foreach ArmorBonusClassName(ArmorBonusClassIter, )
    {
        Class'SFXEngine'.static.ReleaseSeekFreeObject(ArmorBonusClassIter);
    }
    ReleaseGameEffects(Class'SFXPlayerCustomization'.default.FullBodyAppearances);
    ReleaseGameEffects(Class'SFXPlayerCustomization'.default.HelmetAppearances);
    ReleaseGameEffects(Class'SFXPlayerCustomization'.default.TorsoAppearances);
    ReleaseGameEffects(Class'SFXPlayerCustomization'.default.ShoulderAppearances);
    ReleaseGameEffects(Class'SFXPlayerCustomization'.default.ArmAppearances);
    ReleaseGameEffects(Class'SFXPlayerCustomization'.default.LegAppearances);
    ClearDelegates();
}
public final native function SendAppearanceChangedTelemetry(int nCasualID, int nFullBodyID, int nHelmetID, int nTorsoID, int nShoulderID, int nArmID, int nLegID, int nSpecID, int nTint1ID, int nTint2ID, int nPatternID, int nPatternColorID, int nEmissiveID);

public event function Update(float fDeltaT)
{
    local Rotator rotCurrentPreviewRotation;
    local SFXPawn_Player oUIWorldPawn;
    
    Super.Update(fDeltaT);
    oUIWorldPawn = GetUIWorldPlayerPawn();
    if (oUIWorldPawn == None || oUIWorldPawn == m_oPlayerPawn)
    {
        return;
    }
    if (oUIWorldPawn.IsUpdatingAppearanceAsync())
    {
        if (!m_bLoadingWidgetVisible)
        {
            GetSFXUIController().GetSaveLoadWidget().ShowLoadingMessage(TRUE);
        }
        m_bLoadingWidgetVisible = TRUE;
    }
    else
    {
        if (m_bLoadingWidgetVisible)
        {
            GetSFXUIController().GetSaveLoadWidget().HideLoadingMessage(TRUE);
        }
        m_bLoadingWidgetVisible = FALSE;
    }
    if (m_nRotating != 0)
    {
        rotCurrentPreviewRotation = GetUIWorldPlayerPawn().Rotation;
        rotCurrentPreviewRotation.Yaw += int(float(m_nRotating) * (fDeltaT * 182.044449 * RotationDegreesPerSecond));
        rotCurrentPreviewRotation = Normalize(rotCurrentPreviewRotation);
        m_WorldInfo.m_UIWorld.RotatePawn(m_oPlayerPawn, rotCurrentPreviewRotation);
    }
    if (!m_bGameEffectLoadingComplete)
    {
        m_bGameEffectLoadingComplete = LoadGameEffects();
        if (m_bGameEffectLoadingComplete)
        {
            ASDeferredInitialization();
        }
    }
    ConditionalReleaseAssetCacheAndGC();
}
public function ClearDelegates()
{
    __ExternalCallback_OnComplete__Delegate = None;
}
public function AddDetailEntry(ESFXPersonalizationOption nEntryIndex, out array<CustomizableElement> Elements, int nIndex)
{
    local int nOpt;
    local string sTemp;
    local bool bFirstElement;
    
    bFirstElement = TRUE;
    nIndex = GetIdxByAppearanceID(nIndex, TRUE, Elements);
    sTemp = "";
    for (nOpt = 0; nOpt < Elements.Length; ++nOpt)
    {
        if (IsAvailable(Elements[nOpt]))
        {
            if (!bFirstElement)
            {
                sTemp $= ",";
            }
            sTemp $= GetUIString(Elements[nOpt].Name);
            bFirstElement = FALSE;
        }
    }
    ASSetDetailOptions(int(nEntryIndex), GetUIString(GetPersonalizationTitle(int(nEntryIndex))), sTemp, nIndex);
}
public function AddSwatchEntry(ESFXPersonalizationOption nEntryIndex, array<CustomizableElement> Elements, int nIndex)
{
    local array<TintSwatchData> Swatches;
    local CustomizableElement ElementIter;
    local TintSwatchData NewSwatch;
    
    nIndex = GetIdxByAppearanceID(nIndex, FALSE, Elements);
    foreach Elements(ElementIter, )
    {
        NewSwatch.SwatchID = ElementIter.Id;
        switch (nEntryIndex)
        {
            case ESFXPersonalizationOption.SFXPersOpt_Tint1:
            case ESFXPersonalizationOption.SFXPersOpt_Tint2:
            case ESFXPersonalizationOption.SFXPersOpt_Emissive:
                NewSwatch.SwatchColor = ElementIter.Tint.TintParam.ParameterValue;
                break;
            case ESFXPersonalizationOption.SFXPersOpt_PatternColor:
                NewSwatch.SwatchColor = ElementIter.Pattern.Stripe1Param.ParameterValue;
                break;
            default:
        }
        Swatches.AddItem(NewSwatch);
    }
    ASSetSwatchOptions(int(nEntryIndex), GetUIString(GetPersonalizationTitle(int(nEntryIndex))), Swatches, nIndex);
}
public function ApplyChanges()
{
    local SFXPawn_Player oUIPawn;
    local BioPlayerController oPC;
    local SFXSaveDescriptor SaveDescriptor;
    local int nCasualIDCng;
    local int nFullBodyIDCng;
    local int nHelmetIDCng;
    local int nTorsoIDCng;
    local int nShoulderIDCng;
    local int nArmIDCng;
    local int nLegIDCng;
    local int nSpecIDCng;
    local int nTint1IDCng;
    local int nTint2IDCng;
    local int nPatternIDCng;
    local int nPatternColorIDCng;
    local int nEmissiveIDCng;
    
    oUIPawn = GetUIWorldPlayerPawn();
    if (oUIPawn == m_oPlayerPawn)
    {
        return;
    }
    m_oPlayerPawn.CopyPawnAppearance(oUIPawn);
    oPC = BioPlayerController(GetPC());
    nCasualIDCng = -1;
    nFullBodyIDCng = -1;
    nHelmetIDCng = -1;
    nTorsoIDCng = -1;
    nShoulderIDCng = -1;
    nArmIDCng = -1;
    nLegIDCng = -1;
    nSpecIDCng = -1;
    nTint1IDCng = -1;
    nTint2IDCng = -1;
    nPatternIDCng = -1;
    nPatternColorIDCng = -1;
    nEmissiveIDCng = -1;
    if (CasualID != m_oPlayerPawn.CasualID)
    {
        nCasualIDCng = m_oPlayerPawn.CasualID;
    }
    if (FullBodyID != m_oPlayerPawn.FullBodyID)
    {
        nFullBodyIDCng = m_oPlayerPawn.FullBodyID;
    }
    if (HelmetID != m_oPlayerPawn.HelmetID)
    {
        nHelmetIDCng = m_oPlayerPawn.HelmetID;
    }
    if (TorsoID != m_oPlayerPawn.TorsoID)
    {
        nTorsoIDCng = m_oPlayerPawn.TorsoID;
    }
    if (ShoulderID != m_oPlayerPawn.ShoulderID)
    {
        nShoulderIDCng = m_oPlayerPawn.ShoulderID;
    }
    if (ArmID != m_oPlayerPawn.ArmID)
    {
        nArmIDCng = m_oPlayerPawn.ArmID;
    }
    if (LegID != m_oPlayerPawn.LegID)
    {
        nLegIDCng = m_oPlayerPawn.LegID;
    }
    if (SpecID != m_oPlayerPawn.SpecID)
    {
        nSpecIDCng = m_oPlayerPawn.SpecID;
    }
    if (Tint1ID != m_oPlayerPawn.Tint1ID)
    {
        nTint1IDCng = m_oPlayerPawn.Tint1ID;
    }
    if (Tint2ID != m_oPlayerPawn.Tint2ID)
    {
        nTint2IDCng = m_oPlayerPawn.Tint2ID;
    }
    if (PatternID != m_oPlayerPawn.PatternID)
    {
        nPatternIDCng = m_oPlayerPawn.PatternID;
    }
    if (PatternColorID != m_oPlayerPawn.PatternColorID)
    {
        nPatternColorIDCng = m_oPlayerPawn.PatternColorID;
    }
    if (EmissiveID != m_oPlayerPawn.EmissiveID)
    {
        nEmissiveIDCng = m_oPlayerPawn.EmissiveID;
    }
    SendAppearanceChangedTelemetry(nCasualIDCng, nFullBodyIDCng, nHelmetIDCng, nTorsoIDCng, nShoulderIDCng, nArmIDCng, nLegIDCng, nSpecIDCng, nTint1IDCng, nTint2IDCng, nPatternIDCng, nPatternColorIDCng, nEmissiveIDCng);
    CombatAppearance = m_oPlayerPawn.CombatAppearance;
    CasualID = m_oPlayerPawn.CasualID;
    FullBodyID = m_oPlayerPawn.FullBodyID;
    HelmetID = m_oPlayerPawn.HelmetID;
    TorsoID = m_oPlayerPawn.TorsoID;
    ShoulderID = m_oPlayerPawn.ShoulderID;
    ArmID = m_oPlayerPawn.ArmID;
    LegID = m_oPlayerPawn.LegID;
    SpecID = m_oPlayerPawn.SpecID;
    Tint1ID = m_oPlayerPawn.Tint1ID;
    Tint2ID = m_oPlayerPawn.Tint2ID;
    PatternID = m_oPlayerPawn.PatternID;
    PatternColorID = m_oPlayerPawn.PatternColorID;
    EmissiveID = m_oPlayerPawn.EmissiveID;
    if (oPC != None)
    {
        SaveDescriptor.Type = ESFXSaveGameType.SaveGameType_Auto;
        oPC.SaveGameEx(SaveDescriptor);
    }
}
public final function ASDeferredInitialization()
{
    ActionScriptVoid("DeferredInitialization");
}
public final function ASScrollInfoText(float nScroll)
{
    ActionScriptVoid("ScrollInfoText");
}
public final function ASSetDetailedCustomizationVisible(bool bVisible)
{
    ActionScriptVoid("SetDetailedCustomizationVisible");
}
public final function ASSetDetailOptions(int nOptionNumber, string sTitle, string sOptions, int nActiveIndex)
{
    ActionScriptVoid("SetDetailOptions");
}
public final function ASSetInfoText(string sDetailText)
{
    ActionScriptVoid("SetInfoText");
}
public final function ASSetSwatchOptions(int nOptionNumber, string sTitle, array<TintSwatchData> oSwatches, int nActiveIndex)
{
    ActionScriptVoid("SetSwatchOptions");
}
public final function ASStopScroll()
{
    ActionScriptVoid("StopScroll");
}
public final function ASUpdateStatsInfo(string sTitle, string sInfo)
{
    ActionScriptVoid("UpdateStatsInfo");
}
public function CancelChanges()
{
    local SFXPawn_Player oUIPawn;
    
    oUIPawn = GetUIWorldPlayerPawn();
    if (oUIPawn == m_oPlayerPawn)
    {
        return;
    }
    PlayGuiSound('PersonalizeCancel');
    oUIPawn.CombatAppearance = CombatAppearance;
    oUIPawn.CasualID = CasualID;
    oUIPawn.FullBodyID = FullBodyID;
    oUIPawn.HelmetID = HelmetID;
    oUIPawn.TorsoID = TorsoID;
    oUIPawn.ShoulderID = ShoulderID;
    oUIPawn.ArmID = ArmID;
    oUIPawn.LegID = LegID;
    oUIPawn.SpecID = SpecID;
    oUIPawn.Tint1ID = Tint1ID;
    oUIPawn.Tint2ID = Tint2ID;
    oUIPawn.PatternID = PatternID;
    oUIPawn.PatternColorID = PatternColorID;
    oUIPawn.EmissiveID = EmissiveID;
    ResetOptions();
}
public function bool CanUndoChanges()
{
    local SFXPawn_Player pPawn;
    
    pPawn = GetUIWorldPlayerPawn();
    if (pPawn == m_oPlayerPawn)
    {
        return FALSE;
    }
    if (pPawn.CasualID != CasualID)
    {
        return TRUE;
    }
    if (pPawn.FullBodyID != FullBodyID)
    {
        return TRUE;
    }
    if (pPawn.HelmetID != HelmetID)
    {
        return TRUE;
    }
    if (pPawn.TorsoID != TorsoID)
    {
        return TRUE;
    }
    if (pPawn.ShoulderID != ShoulderID)
    {
        return TRUE;
    }
    if (pPawn.ArmID != ArmID)
    {
        return TRUE;
    }
    if (pPawn.LegID != LegID)
    {
        return TRUE;
    }
    if (pPawn.SpecID != SpecID)
    {
        return TRUE;
    }
    if (pPawn.Tint1ID != Tint1ID)
    {
        return TRUE;
    }
    if (pPawn.Tint2ID != Tint2ID)
    {
        return TRUE;
    }
    if (pPawn.PatternID != PatternID)
    {
        return TRUE;
    }
    if (pPawn.PatternColorID != PatternColorID)
    {
        return TRUE;
    }
    if (pPawn.EmissiveID != EmissiveID)
    {
        return TRUE;
    }
    return FALSE;
}
public final function int GetAppearanceIDByIdx(int Index, out array<CustomizableElement> AppearanceData)
{
    local int i;
    
    if (Index >= 0 && Index < AppearanceData.Length)
    {
        for (i = 0; i <= Index; ++i)
        {
            if (!IsAvailable(AppearanceData[i]))
            {
                Index++;
            }
        }
        return AppearanceData[Index].Id;
    }
    return 0;
}
public final function int GetIdxByAppearanceID(int Id, bool CheckAvailability, out array<CustomizableElement> AppearanceData)
{
    local int idx;
    local int i;
    local int J;
    
    J = AppearanceData.Find('Id', Id);
    idx = 0;
    if (J != -1)
    {
        if (CheckAvailability)
        {
            for (i = 0; i < J; ++i)
            {
                if (IsAvailable(AppearanceData[i]))
                {
                    idx++;
                }
            }
            return idx;
        }
        else
        {
            return J;
        }
    }
    return 0;
}
public function stringref GetPersonalizationTitle(int PersOpt)
{
    switch (PersOpt)
    {
        case 0:
            return CasualOptionTitle;
            break;
        case 1:
            return TypeOptionTitle;
            break;
        case 2:
            return HelmetOptionTitle;
            break;
        case 3:
            return TorsoOptionTitle;
            break;
        case 4:
            return ShoulderOptionTitle;
            break;
        case 5:
            return ArmOptionTitle;
            break;
        case 6:
            return LegOptionTitle;
            break;
        case 7:
            return SpecOptionTitle;
            break;
        case 10:
            return Tint1OptionTitle;
            break;
        case 11:
            return Tint2OptionTitle;
            break;
        case 8:
            return PatternOptionTitle;
            break;
        case 9:
            return PatternColorOptionTitle;
            break;
        case 12:
            return EmissiveOptionTitle;
            break;
        default:
    }
    return $0;
}
public function SFXPawn_Player GetUIWorldPlayerPawn()
{
    if (m_WorldInfo == None)
    {
        return None;
    }
    if (m_oUIWorldPawn == None)
    {
        m_oUIWorldPawn = SFXPawn_Player(m_WorldInfo.m_UIWorld.GetSpawnedActor(m_oPlayerPawn));
        if (m_oUIWorldPawn != None)
        {
            m_oUIWorldPawn.bInPersonalization = TRUE;
        }
    }
    if (m_oUIWorldPawn == None)
    {
        return m_oPlayerPawn;
    }
    return m_oUIWorldPawn;
}
public function InitializeUIWorld()
{
    local BioPlayerController PC;
    
    if (oWorldInfo != None)
    {
        m_WorldInfo = oWorldInfo;
        PC = m_WorldInfo.GetLocalPlayerController();
        if (PC != None)
        {
            m_oPlayerPawn = SFXPawn_Player(PC.Pawn);
        }
    }
    CombatAppearance = m_oPlayerPawn.CombatAppearance;
    CasualID = m_oPlayerPawn.CasualID;
    FullBodyID = m_oPlayerPawn.FullBodyID;
    HelmetID = m_oPlayerPawn.HelmetID;
    TorsoID = m_oPlayerPawn.TorsoID;
    ShoulderID = m_oPlayerPawn.ShoulderID;
    ArmID = m_oPlayerPawn.ArmID;
    LegID = m_oPlayerPawn.LegID;
    SpecID = m_oPlayerPawn.SpecID;
    Tint1ID = m_oPlayerPawn.Tint1ID;
    Tint2ID = m_oPlayerPawn.Tint2ID;
    PatternID = m_oPlayerPawn.PatternID;
    PatternColorID = m_oPlayerPawn.PatternColorID;
    EmissiveID = m_oPlayerPawn.EmissiveID;
    m_WorldInfo.m_UIWorld.TriggerEvent('SetupPersonalization', m_WorldInfo);
    m_WorldInfo.m_UIWorld.SpawnPawn(m_oPlayerPawn, 'PersonalizationSpawnPoint', 'PersonalizationPawn', , , 32);
}
public final function bool IsAvailable(CustomizableElement Element)
{
    if (Element.PlotFlag <= 0)
    {
        return TRUE;
    }
    return m_WorldInfo.GetGlobalVariables().GetBool(Element.PlotFlag);
}
public function bool LoadGameEffects()
{
    local string ArmorBonusClassIter;
    local EAsyncLoadStatus AsyncStatusDummy;
    local EAsyncLoadStatus WorstAsyncStatus;
    local bool LoadingComplete;
    local int Index;
    
    WorstAsyncStatus = EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
    foreach ArmorBonusClassName(ArmorBonusClassIter, )
    {
        Class'SFXEngine'.static.LoadSeekFreeObjectAsync(ArmorBonusClassIter, Class'Class', AsyncStatusDummy);
        if (int(AsyncStatusDummy) < int(WorstAsyncStatus))
        {
            WorstAsyncStatus = AsyncStatusDummy;
        }
        if (AsyncStatusDummy == EAsyncLoadStatus.ASYNC_LOAD_ERROR)
        {
            WorstAsyncStatus = EAsyncLoadStatus.ASYNC_LOAD_ERROR;
            break;
        }
    }
    LoadingComplete = WorstAsyncStatus == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
    LoadingComplete = LoadGameEffectsFromElements(Class'SFXPlayerCustomization'.default.FullBodyAppearances) && LoadingComplete;
    LoadingComplete = LoadGameEffectsFromElements(Class'SFXPlayerCustomization'.default.HelmetAppearances) && LoadingComplete;
    LoadingComplete = LoadGameEffectsFromElements(Class'SFXPlayerCustomization'.default.TorsoAppearances) && LoadingComplete;
    LoadingComplete = LoadGameEffectsFromElements(Class'SFXPlayerCustomization'.default.ShoulderAppearances) && LoadingComplete;
    LoadingComplete = LoadGameEffectsFromElements(Class'SFXPlayerCustomization'.default.ArmAppearances) && LoadingComplete;
    LoadingComplete = LoadGameEffectsFromElements(Class'SFXPlayerCustomization'.default.LegAppearances) && LoadingComplete;
    if (LoadingComplete)
    {
        CachedBonusGameEffectClasses.Length = ArmorBonusClassName.Length;
        for (Index = 0; Index < ArmorBonusClassName.Length; Index++)
        {
            CachedBonusGameEffectClasses[Index] = Class<SFXGameEffect>(Class'SFXEngine'.static.GetSeekFreeObject(ArmorBonusClassName[Index], Class'Class'));
        }
    }
    return LoadingComplete;
}
public function bool LoadGameEffectsFromElements(array<CustomizableElement> Elements)
{
    local CustomizableElement ElementIter;
    local string GameEffectIter;
    local EAsyncLoadStatus AsyncStatusDummy;
    local EAsyncLoadStatus WorstAsyncStatus;
    
    WorstAsyncStatus = EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
    foreach Elements(ElementIter, )
    {
        foreach ElementIter.GameEffects(GameEffectIter, )
        {
            Class'SFXEngine'.static.LoadSeekFreeObjectAsync(GameEffectIter, Class'Class', AsyncStatusDummy);
            if (int(AsyncStatusDummy) < int(WorstAsyncStatus))
            {
                WorstAsyncStatus = AsyncStatusDummy;
            }
            if (AsyncStatusDummy == EAsyncLoadStatus.ASYNC_LOAD_ERROR)
            {
                return FALSE;
            }
        }
    }
    return AsyncStatusDummy == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
}
public function onExIntDetailItemChange(int nOptIndex, int nOptionIndex)
{
    local string sDescription;
    local string sElementName;
    local array<CustomizableElement> aChangedElement;
    local SFXPawn_Player pPawn;
    local SFXShield_Base oShields;
    local int nSelectionID;
    local int i;
    
    nSelectionID = -1;
    pPawn = GetUIWorldPlayerPawn();
    if (pPawn == None || pPawn == m_oPlayerPawn)
    {
        return;
    }
    pPawn.bUseCasualAppearance = nOptIndex == 0;
    switch (nOptIndex)
    {
        case 0:
            aChangedElement = Class'SFXPlayerCustomization'.default.CasualAppearances;
            pPawn.CasualID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.CasualAppearances);
            nSelectionID = pPawn.CasualID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 1:
            if (nOptionIndex == 0)
            {
                pPawn.CombatAppearance = EPlayerAppearanceType.PlayerAppearanceType_Parts;
            }
            else
            {
                nOptionIndex--;
                pPawn.CombatAppearance = EPlayerAppearanceType.PlayerAppearanceType_Full;
                pPawn.FullBodyID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.FullBodyAppearances);
                aChangedElement = Class'SFXPlayerCustomization'.default.FullBodyAppearances;
                nSelectionID = pPawn.FullBodyID;
            }
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 2:
            aChangedElement = Class'SFXPlayerCustomization'.default.HelmetAppearances;
            pPawn.HelmetID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.HelmetAppearances);
            nSelectionID = pPawn.HelmetID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 3:
            aChangedElement = Class'SFXPlayerCustomization'.default.TorsoAppearances;
            pPawn.TorsoID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.TorsoAppearances);
            nSelectionID = pPawn.TorsoID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 4:
            aChangedElement = Class'SFXPlayerCustomization'.default.ShoulderAppearances;
            pPawn.ShoulderID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.ShoulderAppearances);
            nSelectionID = pPawn.ShoulderID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 5:
            aChangedElement = Class'SFXPlayerCustomization'.default.ArmAppearances;
            pPawn.ArmID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.ArmAppearances);
            nSelectionID = pPawn.ArmID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 6:
            aChangedElement = Class'SFXPlayerCustomization'.default.LegAppearances;
            pPawn.LegID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.LegAppearances);
            nSelectionID = pPawn.LegID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 7:
            aChangedElement = Class'SFXPlayerCustomization'.default.SpecAppearances;
            pPawn.SpecID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.SpecAppearances);
            nSelectionID = pPawn.SpecID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 10:
            aChangedElement = Class'SFXPlayerCustomization'.default.Tint1Appearances;
            pPawn.Tint1ID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.Tint1Appearances);
            nSelectionID = pPawn.Tint1ID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 11:
            aChangedElement = Class'SFXPlayerCustomization'.default.Tint2Appearances;
            pPawn.Tint2ID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.Tint2Appearances);
            nSelectionID = pPawn.Tint2ID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 8:
            aChangedElement = Class'SFXPlayerCustomization'.default.PatternAppearances;
            pPawn.PatternID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.PatternAppearances);
            nSelectionID = pPawn.PatternID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 9:
            aChangedElement = Class'SFXPlayerCustomization'.default.PatternColorAppearances;
            pPawn.PatternColorID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.PatternColorAppearances);
            nSelectionID = pPawn.PatternColorID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        case 12:
            aChangedElement = Class'SFXPlayerCustomization'.default.EmissiveAppearances;
            pPawn.EmissiveID = GetAppearanceIDByIdx(nOptionIndex, Class'SFXPlayerCustomization'.default.EmissiveAppearances);
            nSelectionID = pPawn.EmissiveID;
            UpdateAppearanceOnPawn(pPawn);
            break;
        default:
    }
    if (nOptIndex == 1)
    {
        ASSetDetailedCustomizationVisible(pPawn.CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Parts);
    }
    if (nSelectionID >= 0)
    {
        for (i = 0; i < aChangedElement.Length; ++i)
        {
            if (aChangedElement[i].Id == nSelectionID)
            {
                sDescription = pPawn.GetArmorEffectDescription(aChangedElement[i].GameEffects);
                ClearCustomTokens();
                if (sDescription != "" || aChangedElement[i].Description != 0)
                {
                    SetCustomToken(0, sDescription);
                    SetCustomToken(1, string(aChangedElement[i].Description));
                    sDescription = GetUIString(ArmorEffectDescriptionFormatter, TRUE);
                    ClearCustomTokens();
                }
                sElementName = GetUIString(aChangedElement[i].Name);
            }
        }
    }
    if (sElementName == "")
    {
        sElementName = GetUIString(GetPersonalizationTitle(nOptIndex));
    }
    ASUpdateStatsInfo(sElementName, sDescription);
    pPawn.RecoverFromBleedout();
    oShields = pPawn.GetShields();
    if (oShields != None)
    {
        oShields.SetCurrentShields(pPawn.GetMaxShields());
    }
}
public function onExIntDoInitialize()
{
    InitializeUIWorld();
    ASUpdateStatsInfo("", "");
    ResetOptions();
}
public function onExIntExit()
{
    m_WorldInfo.m_UIWorld.CleanupPawn(m_oPlayerPawn);
    if (__ExternalCallback_OnComplete__Delegate == None)
    {
        GetSFXUIController().HidePersonalizationGUI(GetPC());
    }
    else
    {
        __ExternalCallback_OnComplete__Delegate();
    }
}
public function string onExIntGetBonusString(int BonusIndex)
{
    if (BonusIndex < srBonus.Length)
    {
        return GetUIString(srBonus[BonusIndex]);
    }
    else
    {
        return "";
    }
}
public function array<float> onExIntGetBonusValues()
{
    local SFXPawn_Player pPawn;
    local array<float> BonusValues;
    local float BonusValue;
    local int BonusIndex;
    local array<Class<SFXGameEffect>> GameEffectClasses;
    local array<float> GameEffectBonusOverrides;
    local Class<SFXGameEffect> GameEffectClassIter;
    local Class<SFXGameEffect> BonusGameEffectClassIter;
    local int GameEffectIndex;
    local array<CustomizableElement> Elements;
    local CustomizableElement ElementIter;
    local string GameEffectClassNameIter;
    local Class<SFXGameEffect_UniqueArmor_Base> ArmorEffectClass;
    local UniqueArmorEffects ArmorChildIter;
    local string ArmorEffectIter;
    local int AppearanceIndex;
    
    pPawn = GetUIWorldPlayerPawn();
    if (pPawn == None || !m_bGameEffectLoadingComplete)
    {
        return BonusValues;
    }
    if (pPawn.CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        AppearanceIndex = GetIdxByAppearanceID(pPawn.FullBodyID, FALSE, Class'SFXPlayerCustomization'.default.FullBodyAppearances);
        if (Class'SFXPlayerCustomization'.default.FullBodyAppearances[AppearanceIndex].GameEffects.Length > 0)
        {
            foreach Class'SFXPlayerCustomization'.default.FullBodyAppearances[AppearanceIndex].GameEffects(ArmorEffectIter, )
            {
                ArmorEffectClass = Class<SFXGameEffect_UniqueArmor_Base>(Class'SFXEngine'.static.GetSeekFreeObject(ArmorEffectIter, Class'Class'));
                foreach ArmorEffectClass.default.Children(ArmorChildIter, )
                {
                    GameEffectClasses.AddItem(ArmorChildIter.childClass);
                    GameEffectBonusOverrides.AddItem(ArmorChildIter.Value);
                }
            }
        }
    }
    else if (pPawn.CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Parts)
    {
        AppearanceIndex = GetIdxByAppearanceID(pPawn.HelmetID, FALSE, Class'SFXPlayerCustomization'.default.HelmetAppearances);
        Elements.AddItem(Class'SFXPlayerCustomization'.default.HelmetAppearances[AppearanceIndex]);
        AppearanceIndex = GetIdxByAppearanceID(pPawn.TorsoID, FALSE, Class'SFXPlayerCustomization'.default.TorsoAppearances);
        Elements.AddItem(Class'SFXPlayerCustomization'.default.TorsoAppearances[AppearanceIndex]);
        AppearanceIndex = GetIdxByAppearanceID(pPawn.ShoulderID, FALSE, Class'SFXPlayerCustomization'.default.ShoulderAppearances);
        Elements.AddItem(Class'SFXPlayerCustomization'.default.ShoulderAppearances[AppearanceIndex]);
        AppearanceIndex = GetIdxByAppearanceID(pPawn.ArmID, FALSE, Class'SFXPlayerCustomization'.default.ArmAppearances);
        Elements.AddItem(Class'SFXPlayerCustomization'.default.ArmAppearances[AppearanceIndex]);
        AppearanceIndex = GetIdxByAppearanceID(pPawn.LegID, FALSE, Class'SFXPlayerCustomization'.default.LegAppearances);
        Elements.AddItem(Class'SFXPlayerCustomization'.default.LegAppearances[AppearanceIndex]);
        foreach Elements(ElementIter, )
        {
            foreach ElementIter.GameEffects(GameEffectClassNameIter, )
            {
                GameEffectClasses.AddItem(Class<SFXGameEffect>(Class'SFXEngine'.static.GetSeekFreeObject(GameEffectClassNameIter, Class'Class')));
                GameEffectBonusOverrides.AddItem(0.0);
            }
        }
    }
    foreach CachedBonusGameEffectClasses(BonusGameEffectClassIter, BonusIndex)
    {
        BonusValue = 0.0;
        foreach GameEffectClasses(GameEffectClassIter, GameEffectIndex)
        {
            if (ClassIsChildOf(GameEffectClassIter, BonusGameEffectClassIter))
            {
                if (GameEffectBonusOverrides[GameEffectIndex] == 0.0)
                {
                    BonusValue += Abs(GameEffectClassIter.default.EffectValue);
                }
                else
                {
                    BonusValue += Abs(GameEffectBonusOverrides[GameEffectIndex]);
                }
            }
        }
        BonusValue *= 2.0;
        BonusValues.AddItem(BonusValue);
    }
    return BonusValues;
}
public simulated function OnPawnApperanceChanged(out array<Object> LoadedAssets)
{
    local Object oAsset;
    
    foreach LoadedAssets(oAsset, )
    {
        if (m_ApperanceAssetCache.Find(oAsset) == -1)
        {
            m_ApperanceAssetCache.AddItem(oAsset);
        }
    }
}
public function ReleaseGameEffects(array<CustomizableElement> Elements)
{
    local CustomizableElement ElementIter;
    local string GameEffectIter;
    
    foreach Elements(ElementIter, )
    {
        foreach ElementIter.GameEffects(GameEffectIter, )
        {
            Class'SFXEngine'.static.ReleaseSeekFreeObject(GameEffectIter);
        }
    }
}
public function ResetOptions()
{
    local SFXPawn_Player pPawn;
    local array<CustomizableElement> BodyTypes;
    local int idx;
    local CustomizableElement N7Armor;
    local int AppearanceId;
    
    pPawn = GetUIWorldPlayerPawn();
    if (pPawn == None)
    {
        return;
    }
    BodyTypes.Length = Class'SFXPlayerCustomization'.default.FullBodyAppearances.Length;
    for (idx = 0; idx < BodyTypes.Length; idx++)
    {
        BodyTypes[idx] = Class'SFXPlayerCustomization'.default.FullBodyAppearances[idx];
    }
    N7Armor.bCustomizable = TRUE;
    N7Armor.Name = Class'SFXPlayerCustomization'.default.N7ArmourName;
    N7Armor.Description = Class'SFXPlayerCustomization'.default.N7ArmourDescription;
    N7Armor.Id = -1;
    BodyTypes.InsertItem(0, N7Armor);
    if (pPawn.CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        AppearanceId = pPawn.FullBodyID;
    }
    else
    {
        AppearanceId = -1;
    }
    ASSetDetailedCustomizationVisible(pPawn.CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Parts);
    AddDetailEntry(0, Class'SFXPlayerCustomization'.default.CasualAppearances, pPawn.CasualID);
    AddDetailEntry(1, BodyTypes, AppearanceId);
    AddDetailEntry(2, Class'SFXPlayerCustomization'.default.HelmetAppearances, pPawn.HelmetID);
    AddDetailEntry(3, Class'SFXPlayerCustomization'.default.TorsoAppearances, pPawn.TorsoID);
    AddDetailEntry(4, Class'SFXPlayerCustomization'.default.ShoulderAppearances, pPawn.ShoulderID);
    AddDetailEntry(5, Class'SFXPlayerCustomization'.default.ArmAppearances, pPawn.ArmID);
    AddDetailEntry(6, Class'SFXPlayerCustomization'.default.LegAppearances, pPawn.LegID);
    AddDetailEntry(7, Class'SFXPlayerCustomization'.default.SpecAppearances, pPawn.SpecID);
    AddSwatchEntry(10, Class'SFXPlayerCustomization'.default.Tint1Appearances, pPawn.Tint1ID);
    AddSwatchEntry(11, Class'SFXPlayerCustomization'.default.Tint2Appearances, pPawn.Tint2ID);
    AddDetailEntry(8, Class'SFXPlayerCustomization'.default.PatternAppearances, pPawn.PatternID);
    AddSwatchEntry(9, Class'SFXPlayerCustomization'.default.PatternColorAppearances, pPawn.PatternColorID);
    AddSwatchEntry(12, Class'SFXPlayerCustomization'.default.EmissiveAppearances, pPawn.EmissiveID);
    UpdateAppearanceOnPawn(pPawn);
}
public function SetExternalCallback_OnComplete(delegate<ExternalCallback_OnComplete> pDelegate)
{
    __ExternalCallback_OnComplete__Delegate = pDelegate;
}
public simulated function UpdateAppearanceOnPawn(SFXPawn_Player oPawn)
{
    if (oPawn.IsUpdatingAppearanceAsync())
    {
        oPawn.AbortAsyncUpdateAppearance();
    }
    oPawn.UpdateAppearanceAsync(OnPawnApperanceChanged);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srBonus = ($722384, 
               $722385, 
               $722386, 
               $722387, 
               $722389, 
               $722390, 
               $722391, 
               $722392, 
               $722393
              )
    ArmorBonusClassName = ("SFXGameContent.SFXGameEffect_HealthPercentBonus", 
                           "SFXGameContent.SFXGameEffect_ShieldPercentBonus", 
                           "SFXGame.SFXGameEffect_ShieldRegenBonus", 
                           "SFXGameContent.SFXGameEffect_PassiveMaxAmmoBonus", 
                           "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                           "SFXGameContent.SFXGameEffect_PowerBonus_Cooldown", 
                           "SFXGame.SFXGameEffect_WeaponDamageBonus", 
                           "SFXGameContent.SFXGameEffect_PartBasedDamageBonus", 
                           "SFXGameContent.SFXGameEffect_MeleeDamageBonus"
                          )
    srRotate = "349311"
    srButtonRevertChanges = "722582"
    srButtonShowInfo = "722581"
    srButtonHideInfo = "724835"
    srButtonBack = "163277"
    srButtonSelect = "163280"
    srButtonExpand = "710306"
    RotationDegreesPerSecond = 180.0
    AssetReleaseMemoryThreshold = 10485760.0
    ForceGCMemoryThreshold = 15728640.0
    CasualOptionTitle = $253995
    TypeOptionTitle = $253994
    HelmetOptionTitle = $253996
    TorsoOptionTitle = $312098
    ShoulderOptionTitle = $253997
    ArmOptionTitle = $253998
    LegOptionTitle = $253999
    SpecOptionTitle = $313497
    Tint1OptionTitle = $254002
    Tint2OptionTitle = $254003
    PatternOptionTitle = $312099
    PatternColorOptionTitle = $312100
    EmissiveOptionTitle = $706887
    ArmorEffectDescriptionFormatter = $347273
}