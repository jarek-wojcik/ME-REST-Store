Class BioCameraBehaviorGalaxy extends BioCameraBehavior
    native
    config(Game);

struct native SFXSystemScanData 
{
    var Vector vScanOrigin;
    var float fElapsedTime;
};
struct native SFXGalaxyMapSelector 
{
    var array<stringref> m_PlotNames;
    var SFXGalaxyMapObject m_GalaxyMapObject;
    var Actor m_actor;
    var stringref m_Name;
    var int m_nPctExplored;
    var int m_State;
    var bool m_Visible;
    var bool m_Visited;
    var bool m_HasCritPath;
};
struct native BioMassRelayLine 
{
    var(BioMassRelayLine) string m_sStartClusterLabel;
    var(BioMassRelayLine) string m_sEndClusterLabel;
    var(BioMassRelayLine) Vector m_vLeftEndPosition;
    var(BioMassRelayLine) Vector m_vRightEndPosition;
    var(BioMassRelayLine) Vector m_vMiddlePosition;
    var(BioMassRelayLine) Vector m_vDrawScale;
    var(BioMassRelayLine) Rotator m_rOrientation;
    var(BioMassRelayLine) int m_nStartClusterIdx;
    var(BioMassRelayLine) int m_nEndClusterIdx;
    var(BioMassRelayLine) Actor m_pLeftEndActor;
    var(BioMassRelayLine) Actor m_pRighEndActor;
    var(BioMassRelayLine) Actor m_pMiddleActor;
    var(BioMassRelayLine) bool m_bIsGlowing;
};
enum EBioGalaxyMapState
{
    GalaxyMapState_None,
    GalaxyMapState_Galaxy,
    GalaxyMapState_Cluster,
    GalaxyMapState_System,
    GalaxyMapState_Planet,
    GalaxyMapState_PlanetScan,
};
enum EBioGalaxyMap_PlanetType
{
    eBioGM_PlanetType_None,
    eBioGM_PlanetType_Planet,
    eBioGM_PlanetType_Anomaly,
    eBioGM_PlanetType_PlanetAndAnomaly,
    eBioGM_PlanetType_Citadel,
    eBioGM_PlanetType_Prefab,
    eBioGM_PlanetType_PlanetAndRing,
    eBioGM_PlanetType_2DImage,
};

var native Map_Mirror m_mapObjectLookup;
var native Map_Mirror m_mapActorLookup;
var native Map_Mirror m_mapActorPool;
var transient string m_sSelectableObject;
var transient string m_sPlanetEvent;
var transient array<SFXGalaxyMapSelector> m_SystemSelectors;
var transient array<SFXGalaxyMapSelector> m_ClusterSelectors;
var transient array<SFXGalaxyMapSelector> m_GalaxySelectors;
var transient array<Actor> m_pDynamicClusterPath;
var transient array<Actor> m_aGalaxyActors;
var transient array<Actor> m_aClusterActors;
var transient array<Actor> m_aSystemActors;
var transient array<Actor> m_aPlanetActors;
var transient array<Actor> m_aSelectableActors;
var transient array<BioMassRelayLine> m_ClusterRelayLines;
var transient array<int> m_DistanceRelayPath;
var transient array<int> m_ActiveRelayPath;
var array<SFXSystemScanData> m_aSystemScans;
var array<Actor> m_aSystemScanCandidates;
var transient native Pointer m_pCurrentMapActors;
var transient ScreenShakeStruct ClusterTravelShake;
var transient Vector m_vShipDesiredDirection;
var transient Vector m_vZoomLocation;
var transient Vector m_vZoomDelta;
var transient Rotator m_rZoomRotation;
var transient Vector m_vLastCameraLocation;
var transient SFXGalaxy m_pGalaxyMap;
var transient SFXCluster m_pCurrentCluster;
var transient SFXSystem m_pCurrentSystem;
var transient BioPlanet m_pCurrentPlanet;
var transient float m_fMovementScalar;
var transient float m_fMovementScalarGalaxy;
var transient float m_fMovementScalarCluster;
var transient float m_fMovementScalarSystem;
var transient float m_fRotationScalar;
var transient float m_fShipCurrentRotationSpeed;
var transient float m_fShipCurrentMovementSpeed;
var config float m_fShipMinRotationSpeed;
var config float m_fShipMaxRotationSpeed;
var config float m_fShipControlDeadzone;
var config float m_fShipSystemAccel;
var config float m_fShipSystemDeccel;
var config float m_fShipClusterAccel;
var config float m_fShipClusterDeccel;
var transient int m_nCurrentState;
var transient Actor m_pCenterObject;
var transient Actor m_pCrossHairObject;
var transient Actor m_pCameraObject;
var transient float m_fMaxOrbitDistance;
var transient float m_fPlanarPitch;
var transient Actor m_pLastSelectedObject;
var transient Actor m_pMapCurrentObject;
var transient Actor m_pSelectedObject;
var transient Actor m_pSelectedCluster;
var transient Actor m_pSelectedSystem;
var transient Actor m_pSelectedPlanet;
var transient Actor m_pMassRelaySystem;
var transient Actor m_pFuelEllipseObject;
var transient Actor m_pMassRelayObject;
var transient Actor m_pRedMassRelayObject;
var transient Actor m_pDepotObject;
var transient float m_fZoomTime;
var transient int m_nPlanetImageIndex;
var transient int m_nPlanetMap;
var transient int m_nButtonLabel;
var transient int m_nExitMap;
var transient int m_nActiveWorld;
var transient int m_nScanRange;
var transient int m_nHighlightWorld;
var transient DynamicSMActor m_pTemplatePlanet;
var transient float m_fPlanetRotation;
var transient float m_fMaxGalaxyDistance;
var transient float m_fMaxClusterDistance;
var transient float m_fMaxSystemDistance;
var transient int m_nPlanetEventConditional;
var transient int m_nPlanetEventParameter;
var transient int m_nPlanetEventTransition;
var transient int m_nPlanetEventTransParameter;
var transient stringref m_srPlanetEventMessage;
var transient ForceFeedbackWaveform ClusterTravelFF;
var transient float ClusterTravelShakeTime;
var transient float ClusterTravelFFTime;
var editinline transient export WwiseAudioComponent m_pAudioComponent;
var transient SFXGalaxyMapGameData Data;
var transient float m_fLastNoFuelMessageTime;
var config transient float m_fSystemExitRingScalar;
var config transient float m_fSystemEnterMaxDistanceScalar;
var config transient int MaxPlotLabelsInTag;
var transient float m_fSystemScanCooldown;
var float m_fSystemScanCooldownTime;
var float m_fSystemScanRange;
var float m_fSystemScanPropagationSpeed;
var config stringref srReaperTutorialMessage;
var config stringref srScanningTutorialMessage;
var transient bool m_bInitialized;
var transient bool m_bTransitionDown;
var transient bool m_bFirstStage;
var transient bool m_bPlanetUsable;
var transient bool m_bPlanetScanable;
var transient bool m_bPlanetInteractive;
var transient bool m_bPaused;
var transient bool m_bRefreshPlanetUsable;
var transient bool m_bRebuildPlanetRingCache;
var transient bool m_bSelectedPlanetLastFrame;
var transient bool m_bUseInternalPlanetEvent;
var transient bool m_bCanExploreCluster;
var transient bool m_bSystemSunVisible;
var transient bool m_bCanDoSystemScan;

public final native function BuildSelectors();

public final native function int BuildWorldID(Actor pCluster, Actor PSystem, Actor pPlanet);

public final event function BurnFuel(float fFuel)
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    
    oController = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    oInventory.CurrentFuel = FMax(oInventory.CurrentFuel - fFuel, 0.0);
    m_pAudioComponent.SetWwiseRTPC(Data.AudioData.ShipTravelSound_FuelQtyRTPCName, oInventory.CurrentFuel / oInventory.GetMaxFuel());
}
public final native function Cleanup();

public final event function EnableSystemScanning(bool bCanScan)
{
    local BioSFHandler_GalaxyMap oGUI;
    
    oGUI = GetGUI();
    if (oGUI != None && m_bCanDoSystemScan != bCanScan)
    {
        if (bCanScan)
        {
            oGUI.AS_ShowSystemScan(oGUI.UIStrRef(Class'BioSFHandler_GalaxyMap'.default.TextScan));
        }
        else
        {
            oGUI.AS_HideSystemScan();
        }
        m_bCanDoSystemScan = bCanScan;
    }
}
public final native function bool ExecuteTravel();

public final native function Actor FindActorByTagName(const string sName, int nSuffixLen);

public final native function Actor FindActorFromGalaxyMapObject(SFXGalaxyMapObject oObject);

public final native function Actor FindGalaxyMapActor(Name TagName, optional bool bSearchLevel = FALSE);

public final native function SFXGalaxyMapObject FindGalaxyMapObjectFromActor(Actor oActor);

public final native function BioPlanet GetActivePlanet();

public function Vector GetCameraLocation()
{
    return m_vLastCameraLocation;
}
public final native function BioPlanet GetCurrentPlanet();

public final event function float GetFuelEfficiency()
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    
    oController = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    return oInventory.FuelEfficiency;
}
public final native function BioSFHandler_GalaxyMap GetGUI();

public final event function float GetMaxFuel()
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    
    oController = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    return oInventory.GetMaxFuel();
}
public final event function int GetNumCredits()
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    
    oController = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    return oInventory.GetResource(0);
}
public final native function BioPlanet GetPlanet(int nWorldID);

public final event function float GetRemainingFuel()
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    
    oController = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    return oInventory.CurrentFuel;
}
public native function HandleRevealLandingSite();

public native function bool HandleSelectPlanet();

public final event function OutOfFuelPenalty(float fDistToDepot)
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    local EInventoryResourceTypes eLostMineral;
    local EInventoryResourceTypes eTestMineral;
    local int nPenalty;
    local int nCount;
    local int nLargestAmt;
    local int nTestAmt;
    
    oController = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    eLostMineral = byte(Rand(7 - 5) + 5);
    nPenalty = Rand(int(fDistToDepot * float(10))) + 500;
    nLargestAmt = oInventory.GetResource(eLostMineral);
    if (nPenalty >= nLargestAmt)
    {
        eTestMineral = eLostMineral;
        for (nCount = 0; nCount < 3; nCount++)
        {
            eTestMineral = byte((int(eTestMineral) - 5 + 1) %  3 + 5);
            nTestAmt = oInventory.GetResource(eTestMineral);
            if (nTestAmt > nLargestAmt)
            {
                nLargestAmt = nTestAmt;
                eLostMineral = eTestMineral;
                if (nTestAmt > nPenalty)
                {
                    break;
                }
            }
        }
        nPenalty = Min(nPenalty, nLargestAmt);
    }
    oInventory.AdjustResource(eLostMineral, -nPenalty, TRUE);
}
public final native function ScanSystem();

public final event function SetExplorationAchievementCompleted();

public final native function SetMapLevel(bool bTransitionDown, optional bool bFirstOpen = FALSE);

public final event function ShowReaperTutorial()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local SFXEngine Engine;
    local int Cnt;
    local bool bReaperVisible;
    
    if (srReaperTutorialMessage == 0)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine.GetPlayerVariable('ReaperTutorialDisplayed') != 0)
    {
        return;
    }
    for (Cnt = 0; Cnt < m_pGalaxyMap.Children.Length; Cnt++)
    {
        if (SFXCluster(m_pGalaxyMap.Children[Cnt]) != None && SFXCluster(m_pGalaxyMap.Children[Cnt]).IsReaperControlled())
        {
            bReaperVisible = TRUE;
            break;
        }
    }
    if (!bReaperVisible)
    {
        return;
    }
    Engine.SetPlayerVariable('ReaperTutorialDisplayed', 1);
    messageBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(Engine.GetCurrentWorldInfo().GetALocalPlayerController());
    Params.srAText = Class'SFXGUI_MainMenu_RTT'.default.srOK;
    messageBox.DisplayMessageBox(srReaperTutorialMessage, Params);
}
public final event function ShowScanningTutorial()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local SFXEngine Engine;
    
    if (srScanningTutorialMessage == 0)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine.GetPlayerVariable('SystemScanTutorialDisplayed') != 0)
    {
        return;
    }
    Engine.SetPlayerVariable('SystemScanTutorialDisplayed', 1);
    messageBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(Engine.GetCurrentWorldInfo().GetALocalPlayerController());
    Params.srAText = Class'SFXGUI_MainMenu_RTT'.default.srOK;
    messageBox.DisplayMessageBox(srScanningTutorialMessage, Params);
}
public native function Tick(float TimeDelta);

public final event function TickGameMode(float fDeltaT)
{
    local BioPlayerController oPC;
    
    oPC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oPC == None)
    {
        return;
    }
    if (oPC.GameModeManager2.IsActive(12))
    {
        SFXGameModeOrbital(oPC.GameModeManager2.HACK_GetOrbitalMode()).Update(fDeltaT);
    }
    else if (oPC.GameModeManager2.IsActive(13))
    {
        SFXGameModeMultiLand(oPC.GameModeManager2.HACK_GetMultiLandMode()).Update(fDeltaT);
    }
}
public native function bool TriggerEvent(Name sEvent, optional Name nParameter);

public final event function UpdateClusterTravelEffects(float TimeDelta)
{
    local PlayerController PC;
    
    PC = PlayerController(GetViewTargetAsController());
    if (ClusterTravelFFTime > 0.0)
    {
        ClusterTravelFFTime -= TimeDelta;
    }
    if (ClusterTravelFFTime <= 0.0)
    {
        ClusterTravelFFTime = ClusterTravelFF.Samples[0].Duration;
        PC.ClientPlayForceFeedbackWaveform(ClusterTravelFF);
    }
}
public final event function UpdateFuelAndCashDisplay()
{
    local float fCurrentFuel;
    local float fMaxFuel;
    local int nCredits;
    local bool bDisplayCredits;
    
    if (m_nCurrentState == 2 || m_nCurrentState == 3 && m_pSelectedObject == m_pDepotObject)
    {
        fCurrentFuel = GetRemainingFuel();
        fMaxFuel = GetMaxFuel();
        if (m_pSelectedObject == m_pDepotObject)
        {
            nCredits = GetNumCredits();
            bDisplayCredits = TRUE;
        }
        GetGUI().UpdateFuelAndCashDisplay(fCurrentFuel, fMaxFuel, nCredits, bDisplayCredits);
    }
    else
    {
        GetGUI().SetFuelAndCashDisplay("", "");
    }
}
public final native function UpdateSelectorPositions();

public final event function UpdateUITitle()
{
    local stringref srTitle;
    local int nPercentVisited;
    local BioSFHandler_GalaxyMap oGUI;
    
    oGUI = GetGUI();
    if (oGUI == None)
    {
        return;
    }
    srTitle = $0;
    nPercentVisited = -1;
    switch (m_nCurrentState)
    {
        case 1:
            srTitle = oGUI.TextGalaxyTitle;
            break;
        case 2:
            if (m_pCurrentCluster != None)
            {
                srTitle = m_pCurrentCluster.GetMapTag();
                nPercentVisited = int(m_pCurrentCluster.GetExploredPercent(1) * 100.0);
            }
            break;
        case 3:
            if (m_pCurrentSystem != None)
            {
                srTitle = m_pCurrentSystem.GetMapTag();
                nPercentVisited = int(m_pCurrentSystem.GetExploredPercent(byte(m_nCurrentState)) * 100.0);
            }
            break;
        case 4:
        case 5:
            break;
        default:
    }
    oGUI.SetTitleStrings(srTitle, nPercentVisited);
}
public final native function bool ValidLevelTransition(bool bTransitionDown);

public final native function ZoomCamera(bool bTransitionDown, bool bStartAtCamera, bool bFirstStage);

public final function bool ReapersCanChasePlayer()
{
    local BioPlayerController oPC;
    
    oPC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oPC == None)
    {
        return FALSE;
    }
    if (m_nCurrentState != 3 || m_pCrossHairObject == None)
    {
        return FALSE;
    }
    if (oPC.GameModeManager2.IsActive(8))
    {
        return FALSE;
    }
    return TRUE;
}
public final function SetLTriggerLabelVisible(bool bShow, stringref srText)
{
    local BioSFHandler_GalaxyMap oGUI;
    
    oGUI = GetGUI();
    if (oGUI != None)
    {
        oGUI.SetLTriggerLabel(bShow, srText);
    }
}
public final function SetRTriggerLabelVisible(bool bShow, stringref srText)
{
    local BioSFHandler_GalaxyMap oGUI;
    
    oGUI = GetGUI();
    if (oGUI != None)
    {
        oGUI.SetRTriggerLabel(bShow, srText);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=ResourceFFWave
        Samples = ({Duration = 0.25, LeftAmplitude = 18, RightAmplitude = 18, LeftFunction = EWaveformFunction.WF_Noise, RightFunction = EWaveformFunction.WF_Noise}
                  )
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    ClusterTravelShake = {
                          RotAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                          RotFrequency = {X = 80.0, Y = 150.0, Z = 150.0}, 
                          RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                          LocAmplitude = {X = 0.300000012, Y = 0.300000012, Z = 0.300000012}, 
                          LocFrequency = {X = 120.0, Y = 120.0, Z = 120.0}, 
                          LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                          ShakeName = 'None', 
                          TimeToGo = 0.0, 
                          TimeDuration = 0.5, 
                          RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                          LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                          FOVAmplitude = 0.0, 
                          FOVFrequency = 0.0, 
                          FOVSinOffset = 0.0, 
                          TargetingDampening = 0.0, 
                          bOverrideTargetingDampening = FALSE, 
                          FOVParam = EShakeParam.ESP_OffsetRandom
                         }
    m_vShipDesiredDirection = {X = 1.0, Y = 0.0, Z = 0.0}
    m_fMovementScalarGalaxy = 100.0
    m_fMovementScalarCluster = 30.0
    m_fMovementScalarSystem = 45.0
    m_fRotationScalar = 20.0
    m_fShipMinRotationSpeed = 540.0
    m_fShipMaxRotationSpeed = 720.0
    m_fShipControlDeadzone = 0.400000006
    m_fShipSystemAccel = 2.5
    m_fShipSystemDeccel = 1.5
    m_fShipClusterAccel = 0.219999999
    m_fShipClusterDeccel = 0.379999995
    m_nScanRange = 120
    ClusterTravelFF = ResourceFFWave
    m_fSystemExitRingScalar = 1.14999998
    m_fSystemEnterMaxDistanceScalar = 1.10000002
    MaxPlotLabelsInTag = 3
    m_fSystemScanCooldownTime = 2.0
    m_fSystemScanRange = 75.0
    m_fSystemScanPropagationSpeed = 60.0
    srReaperTutorialMessage = $727393
    srScanningTutorialMessage = $727392
    m_bRebuildPlanetRingCache = TRUE
    Input = s_Input
    bIsCameraShakeEnabled = FALSE
    bCollisionEnabled = FALSE
}