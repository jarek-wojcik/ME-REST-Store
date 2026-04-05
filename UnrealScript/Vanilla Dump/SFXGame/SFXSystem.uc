Class SFXSystem extends SFXGalaxyMapObject
    native
    config(Game);

enum EBioReaperControlConditionAutoSet
{
    BioReaperControlCondition_Unset,
};
enum EBioReaperControlConditionPlotAutoSet
{
    BioReaperControlConditionPlot_Unset,
};

var array<BioPlanet> Planets;
var transient array<SFXGalaxyMapObject> aReapersTouchingPlayer;
var(Appearance) LinearColor SunColor;
var(Appearance) LinearColor StarColor;
var(Appearance) LinearColor FlareTint;
var transient int ActiveWorld;
var transient float m_fReaperAlertLevel;
var int ReaperControlCondition;
var float m_fReaperGraceTime;
var float m_fGameOverFadeTime;
var transient int m_nScannedPlanets;
var bool m_bHasMassRelay;
var(Appearance) bool m_bShowNebula;
var transient bool m_bReapersChasePlayer;
var transient bool m_bSystemReapersActive;
var transient bool m_bReapersHaveBeenDetected;
var(Conditions) EBioRegionAutoSet ReaperControlConditionRegion;
var(Conditions) EBioReaperControlConditionPlotAutoSet ReaperControlConditionPlot;
var(Conditions) EBioReaperControlConditionAutoSet ReaperControlConditionName;

public event function AddChild(SFXGalaxyMapObject oChild)
{
    Super.AddChild(oChild);
    if (BioPlanet(oChild) != None && Planets.Find(oChild) == -1)
    {
        Planets.AddItem(oChild);
    }
}
public event function bool BuildPlotLabelList(out array<stringref> aPlotNames, optional EBioGalaxyMapState eMapLevel = 0)
{
    if (IsVisible() && IsUsable())
    {
        if (GetMassRelay() != None && eMapLevel == EBioGalaxyMapState.GalaxyMapState_Cluster)
        {
            aPlotNames.AddItem(Class'BioSFHandler_GalaxyMap'.default.TextMassRelay);
        }
        return Super.BuildPlotLabelList(aPlotNames, eMapLevel);
    }
    return FALSE;
}
public event function CleanTransientData()
{
    m_fReaperAlertLevel = 0.0;
    m_bReapersChasePlayer = FALSE;
    m_bSystemReapersActive = FALSE;
    m_bReapersHaveBeenDetected = FALSE;
    Super.CleanTransientData();
}
public final event function SFXGalaxyMapObject GetMassRelay()
{
    local SFXGalaxyMapObject oChild;
    
    foreach Children(oChild, )
    {
        if (IsMassRelay(oChild))
        {
            return oChild;
        }
    }
    return None;
}
public final event function bool IsMassRelay(SFXGalaxyMapObject o)
{
    return o.Tag == "Mass Relay";
}
public final event function bool IsReaper(SFXGalaxyMapObject o)
{
    return o.Tag == "Reaper";
}
public final event function bool IsReaperControlled()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (oBWI != None)
    {
        return oBWI.CheckConditional(ReaperControlCondition);
    }
    return FALSE;
}
public event function bool IsVisitedInMap()
{
    return TRUE;
}
public final native function LoadSaveData();

public event function bool MapTagIsVisible()
{
    return TRUE;
}
public event function ObjectLeft()
{
    SetSaveData();
    ReaperChaseEnd();
    Super.ObjectLeft();
}
public event function ObjectVisited()
{
    local SFXGalaxyMapObject oChild;
    local SFXSystemLevelObject oSystemObject;
    
    m_nScannedPlanets = 0;
    foreach Children(oChild, )
    {
        oSystemObject = SFXSystemLevelObject(oChild);
        if (oSystemObject != None)
        {
            if (oSystemObject.HasBeenSystemScanned())
            {
                ++m_nScannedPlanets;
                if (oSystemObject.CanBeSystemScanned())
                {
                    oSystemObject.SpawnSystemScanMarker(FALSE);
                }
            }
        }
    }
    m_bSystemReapersActive = FALSE;
    Super.ObjectVisited();
}
public final event function PlayerEscapedReapers()
{
    local BioSFHandler_GalaxyMap oGUI;
    local BioPlayerController PC;
    local WwiseAudioComponent oAudioComponent;
    
    if (!m_bReapersChasePlayer)
    {
        return;
    }
    GetGalaxyBehavior().TriggerEvent('ReaperChaseEscape');
    ReaperChaseEnd();
    oGUI = GetGalaxyBehavior().GetGUI();
    if (oGUI != None)
    {
        oGUI.PlayGuiSound('GalaxyMap-ReaperChaseEscape');
    }
    PC = BioPlayerController(Class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());
    if (PC != None)
    {
        PC.UnlockAccomplishment('ESCAPEREAPER');
    }
    oAudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Class'Engine'.static.GetCurrentWorldInfo(), "", 'Scene_Kismet');
    if (oAudioComponent != None)
    {
        oAudioComponent.SetWwiseRTPC("Music_Galaxy_Map_Type", 1.0);
    }
}
public final event function PushReapersToEdgeOfSystem(const Vector vCenter, const float fSystemRadius)
{
    local Vector vToReaper;
    local SFXGalaxyMapObject oChild;
    
    foreach Children(oChild, )
    {
        if (IsReaper(oChild) && oChild.ObjectActor != None)
        {
            vToReaper = Normal(oChild.ObjectActor.location - vCenter);
            oChild.ObjectActor.SetLocation(vCenter + vToReaper * fSystemRadius * (Class'BioCameraBehaviorGalaxy'.default.m_fSystemEnterMaxDistanceScalar + 0.0500000007), );
            oChild.ObjectActor.SetRotation(Rotator(vToReaper * float(-1)));
        }
    }
}
public event function RemoveChild(SFXGalaxyMapObject Child)
{
    local int i;
    
    i = Planets.Find(Child);
    if (i != -1)
    {
        Planets[i] = None;
    }
    Super.RemoveChild(Child);
}
public static final native function ResetGlobalReaperAlertLevels();

public final native function SetSaveData();

public final function AddReaperAlertValue(float fReaperValue)
{
    if (m_fReaperAlertLevel <= 0.0)
    {
        GetGalaxyBehavior().TriggerEvent('ReapersAlerted');
    }
    if (m_fReaperAlertLevel < 100.0 && m_fReaperAlertLevel + fReaperValue >= 100.0)
    {
        ReaperChaseStart();
    }
    SetReaperAlertLevel(m_fReaperAlertLevel + fReaperValue);
}
public final function BeginReaperGracePeriod()
{
    local BioWorldInfo oBWI;
    local BioPlayerController oPC;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oPC = oBWI != None ? oBWI.GetLocalPlayerController() : None;
    if (oPC != None && !oPC.IsTimerActive('ReaperCaughtPlayer', Self))
    {
        oPC.SetTimer(m_fReaperGraceTime, FALSE, 'ReaperCaughtPlayer', Self);
    }
}
public function CountObjectsForExploration(out int nObjectCount, out int nExploredCount, EBioGalaxyMapState eMapLevel)
{
    if (eMapLevel == EBioGalaxyMapState.GalaxyMapState_Galaxy || ShouldCountSystemObjectsForExploration())
    {
        Super.CountObjectsForExploration(nObjectCount, nExploredCount, eMapLevel);
    }
}
public final function EndReaperGracePeriod()
{
    local BioWorldInfo oBWI;
    local BioPlayerController oPC;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oPC = oBWI != None ? oBWI.GetLocalPlayerController() : None;
    if (oPC != None)
    {
        oPC.ClearTimer('ReaperCaughtPlayer', Self);
    }
}
public final function EnumeratePlanets(SFXCluster Cluster)
{
    local BioPlanet P;
    local int i;
    
    foreach Planets(P, i)
    {
        if (P != None)
        {
            P.TableID = i;
            P.Tag $= Right("0" $ i, 2);
            P.ActiveWorld = EncodeWorldID(Cluster.TableID, Self.TableID, i);
        }
    }
}
public function float GetLevelSize()
{
    return 320.0;
}
public final function ReaperCaughtPlayer()
{
    local BioWorldInfo oBWI;
    local SFXGUIInteraction oGUI;
    local BioSFHandler_GalaxyMap oGalaxyGUI;
    local BioPlayerController oPC;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    m_bReapersChasePlayer = FALSE;
    ReaperChaseEnd();
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oPC = oBWI.GetLocalPlayerController();
    if (oGUI != None && oPC != None)
    {
        oGUI.PlayGuiSound('GalaxyMap-ReaperCaughtPlayer');
        oBWI.GetLocalPlayerController().GameModeManager2.DisableMode(11);
        oGalaxyGUI = BioSFHandler_GalaxyMap(oGUI.GetMovie(oPC, oGUI.MovieTag_GalaxyMap));
        if (oGalaxyGUI != None)
        {
            oGalaxyGUI.SetInputEnabled(FALSE);
        }
        oGUI.ShowBlackScreen(oPC, TRUE, m_fGameOverFadeTime);
        oPC.SetTimer(m_fGameOverFadeTime, FALSE, 'ReaperGameOver', Self);
    }
}
public final function ReaperChaseEnd()
{
    local BioSFHandler_GalaxyMap oGUI;
    local BioPlayerController PC;
    
    aReapersTouchingPlayer.Length = 0;
    if (!m_bReapersChasePlayer)
    {
        return;
    }
    PC = BioPlayerController(Class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());
    if (PC != None)
    {
        PC.ClearTimer('ReaperCaughtPlayer', Self);
    }
    GetGalaxyBehavior().TriggerEvent('ReaperChaseEnd');
    oGUI = GetGalaxyBehavior().GetGUI();
    if (oGUI != None)
    {
        oGUI.StopGuiMusic();
    }
}
public final function ReaperChaseStart()
{
    local BioSFHandler_GalaxyMap oGUI;
    local WwiseAudioComponent oAudioComponent;
    
    if (!m_bSystemReapersActive)
    {
        m_bSystemReapersActive = TRUE;
    }
    else
    {
        return;
    }
    GetGalaxyBehavior().TriggerEvent('ReaperChase');
    m_bReapersChasePlayer = TRUE;
    oGUI = GetGalaxyBehavior().GetGUI();
    if (oGUI != None)
    {
        oGUI.PlayGuiMusic('GalaxyMap-ReaperChaseStartMusic');
        oGUI.PlayGuiSound('GalaxyMap-ReaperChaseStart');
        oAudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Class'Engine'.static.GetCurrentWorldInfo(), "", 'Scene_Kismet');
        if (oAudioComponent != None)
        {
            oAudioComponent.SetWwiseRTPC("Music_Galaxy_Map_Type", 3.0);
        }
    }
}
public final function ReaperGameOver()
{
    local BioWorldInfo oBWI;
    local BioSFHandler_GalaxyMap oGalaxyUI;
    local SFXGUIInteraction oGUI;
    local BioPlayerController oPC;
    local WwiseAudioComponent oAudioComponent;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oPC = oBWI.GetLocalPlayerController();
    if (oGUI != None && oPC != None)
    {
        oGalaxyUI = oGUI.CastGetMovie(Class'BioSFHandler_GalaxyMap', oPC, oGUI.MovieTag_GalaxyMap);
        if (oGalaxyUI != None)
        {
            oGalaxyUI.m_bFullCleanupOnClose = FALSE;
            oGalaxyUI.Close();
        }
    }
    oAudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Class'Engine'.static.GetCurrentWorldInfo(), "", 'Scene_Kismet');
    if (oAudioComponent != None)
    {
        oAudioComponent.SetWwiseRTPC("Music_Galaxy_Map_Type", 1.0);
    }
    if (oBWI != None)
    {
        oGUI.PlayGuiSound('GalaxyMapCriticalMissionFailEnter');
        SFXGame(oBWI.Game).SpawnGameOverGUI();
    }
}
public final function ReaperTouched(SFXGalaxyMapObject oReaper)
{
    if (oReaper != None)
    {
        if (aReapersTouchingPlayer.Length == 0)
        {
            BeginReaperGracePeriod();
        }
        aReapersTouchingPlayer.AddItem(oReaper);
    }
}
public final function ReaperUnTouched(SFXGalaxyMapObject oReaper)
{
    if (aReapersTouchingPlayer.Length == 0)
    {
        return;
    }
    aReapersTouchingPlayer.RemoveItem(oReaper);
    if (aReapersTouchingPlayer.Length == 0)
    {
        EndReaperGracePeriod();
    }
}
public final function SetReaperAlertLevel(float fLevel)
{
    local BioCameraBehaviorGalaxy oGalaxy;
    local BioSFHandler_GalaxyMap oGUI;
    
    m_fReaperAlertLevel = fLevel;
    if (fLevel > 0.0)
    {
        m_bReapersHaveBeenDetected = TRUE;
    }
    oGalaxy = GetGalaxyBehavior();
    if (oGalaxy != None && oGalaxy.m_nCurrentState == 3)
    {
        oGUI = oGalaxy.GetGUI();
        if (oGUI != None)
        {
            oGUI.AS_SetReaperAlert(m_fReaperAlertLevel);
        }
    }
    SetSaveData();
}
public final function bool ShouldCountSystemObjectsForExploration()
{
    local SFXGalaxyMapObject oChild;
    local BioPlanet oPlanet;
    
    if (!IsVisible() || !IsUsable())
    {
        return FALSE;
    }
    foreach Children(oChild, )
    {
        oPlanet = BioPlanet(oChild);
        if (oPlanet != None)
        {
            if (oPlanet.HasBeenSystemScanned() && oPlanet.HasFeaturesToCountForExploration())
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public final function SystemObjectScanned(SFXSystemLevelObject oSrc)
{
    if (oSrc != None)
    {
        oSrc.SpawnSystemScanMarker(TRUE);
    }
    if (m_nScannedPlanets == 0)
    {
        GetGalaxyBehavior().TriggerEvent('SystemHasSearchItems');
    }
    m_nScannedPlanets++;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SunColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    StarColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    FlareTint = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    m_fReaperGraceTime = 1.0
    m_fGameOverFadeTime = 2.0
    Tag = "System"
    MapObjectLevel = ESFXGalaxyMapObjectLevel.GalaxyMapObjType_ClusterLevel
}