Class BioPlanet extends SFXSystemLevelObject
    native
    config(Game);

enum EBioPlanetPlotLabelConditionAutoSet
{
    BioPlanetPlotLabelCondition_Unset,
};
enum EBioPlanetPlotLabelConditionPlotAutoSet
{
    BioPlanetPlotLabelConditionPlot_Unset,
};
enum EBioPlanetLandConditionAutoSet
{
    BioPlanetLandCondition_Unset,
};
enum EBioPlanetLandConditionPlotAutoSet
{
    BioPlanetLandConditionPlot_Unset,
};
enum EBioPlanetEventTransitionAutoSet
{
    BioPlanetEventTransition_Unset,
};
enum EBioPlanetEventTransitionPlotAutoSet
{
    BioPlanetEventTransitionPlot_Unset,
};
enum EBioPlanetEventConditionAutoSet
{
    BioPlanetEventCondition_Unset,
};
enum EBioPlanetEventConditionPlotAutoSet
{
    BioPlanetEventConditionPlot_Unset,
};
struct native PlanetSun 
{
    var(PlanetSun) LinearColor SunColor;
    var(PlanetSun) float Brightness;
};
enum EPlanetType
{
    NOSCAN_PLANET,
    ROCK_PLANET,
    DESERT_PLANET,
    OCEAN_PLANET,
    GARDEN_PLANET,
    GIANT_ICE_PLANET,
    GIANT_JOVIAN_PLANET,
    GIANT_PEGASID_PLANET,
    POST_GARDEN,
    BROWN_DWARF,
    TIDAL_LOCK,
};
enum EOrbitRingType
{
    OR_NONE,
    OR_ORBIT,
    OR_ASTEROID,
};
enum ESystemLevelType
{
    SL_PLANET,
    SL_ANOMALY,
    SL_RINGPLANET,
    SL_MASSRELAY,
    SL_DEPOT,
    SL_SUN,
};

var(Appearance) array<PlanetSun> Suns;
var array<SFXPlanetFeature> Features;
var(Planet) array<SFXPlanetFeature> AutoGrantedFeatures;
var(Map) string MapName;
var(Appearance) string ImageBackground;
var(Conditions) string PlanetEvent;
var(Appearance) LinearColor RingColor;
var(Appearance) LinearColor CloudColor;
var(Appearance) LinearColor CoronaColor;
var(Label) stringref Description;
var(Label) stringref ButtonLabel;
var(Label) Texture2D PreviewImage;
var(Label) stringref MissionBriefing;
var float ResourceRichness;
var(Appearance) float PlanetRotation;
var(Appearance) float Opacity;
var(Appearance) float FringeBloom;
var(Appearance) MaterialInstanceConstant PlanetMaterial;
var(Appearance) MaterialInstanceConstant CloudMaterial;
var(Appearance) Prefab ScenePrefab;
var(Appearance) Texture2D TextureParam;
var float RelativeSize;
var float DefaultDisplaySize;
var float TerrainDepthFactor;
var float m_fPlanetScale;
var transient float UnscaledMineralsSum;
var config float PlacedMineralsPool;
var config float RandomMineralsBase;
var config float EezoMineralsBase;
var config float ScanBarMaxMineralSize;
var int PlanetLandCondition;
var int PlanetEventCondition;
var(Conditions) int PlanetEventParameter;
var int PlanetEventTransition;
var(Conditions) int PlanetEventTransitionParameter;
var(Conditions) stringref PlanetEventMessage;
var(PlotLabel) stringref PlanetPlotLabel;
var int PlanetPlotLabelCondition;
var transient Actor SystemActorStorage;
var(Label) bool AlreadyExplored;
var(Label) bool LabelAlwaysVisible;
var(Label) bool AlwaysShowMapTag;
var transient bool bInitialized;
var(PlotLabel) bool CritPathPlot;
var(Planet) EPlanetType PlanetType;
var(Appearance) EOrbitRingType OrbitRing;
var(Appearance) ESystemLevelType SystemLevelType;
var(Appearance) EBioGalaxyMap_PlanetType PlanetLevelType;
var(Conditions) EBioRegionAutoSet PlanetLandConditionRegion;
var(Conditions) EBioPlanetLandConditionPlotAutoSet PlanetLandConditionPlot;
var(Conditions) EBioPlanetLandConditionAutoSet PlanetLandConditionName;
var(Conditions) EBioRegionAutoSet PlanetEventConditionRegion;
var(Conditions) EBioPlanetEventConditionPlotAutoSet PlanetEventConditionPlot;
var(Conditions) EBioPlanetEventConditionAutoSet PlanetEventConditionName;
var(Conditions) EBioRegionAutoSet PlanetEventTransitionRegion;
var(Conditions) EBioPlanetEventTransitionPlotAutoSet PlanetEventTransitionPlot;
var(Conditions) EBioPlanetEventTransitionAutoSet PlanetEventTransitionName;
var(PlotLabel) EBioRegionAutoSet PlanetPlotLabelConditionRegion;
var(PlotLabel) EBioPlanetPlotLabelConditionPlotAutoSet PlanetPlotLabelConditionPlot;
var(PlotLabel) EBioPlanetPlotLabelConditionAutoSet PlanetPlotLabelConditionName;

public event function bool BuildPlotLabelList(out array<stringref> aPlotNames, optional EBioGalaxyMapState eMapLevel = 0)
{
    local BioWorldInfo oBWI;
    local bool bHasCritPath;
    local bool bLandingSiteCritPath;
    
    if (IsVisible() && IsUsable())
    {
        oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
        if (oBWI != None)
        {
            if (oBWI.CheckConditional(PlanetPlotLabelCondition))
            {
                bHasCritPath = bHasCritPath || CritPathPlot;
                if (PlanetPlotLabel != 0)
                {
                    aPlotNames.AddItem(PlanetPlotLabel);
                }
                else
                {
                    aPlotNames.AddItem(GetMapTag());
                }
            }
        }
        bLandingSiteCritPath = Super(SFXGalaxyMapObject).BuildPlotLabelList(aPlotNames, eMapLevel);
        bHasCritPath = bHasCritPath || bLandingSiteCritPath;
    }
    return bHasCritPath;
}
public event function bool CanBeInteractedWith()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (oBWI != None)
    {
        return oBWI.CheckConditional(PlanetLandCondition);
    }
    return FALSE;
}
public event function bool CanBeScanned()
{
    if (CanBeSystemScanned())
    {
        return HasBeenSystemScanned();
    }
    return FALSE;
}
public event function bool CanBeSystemScanned()
{
    local bool bCanBeScanned;
    
    if (!IsVisible() || !IsUsable())
    {
        return FALSE;
    }
    bCanBeScanned = PlanetLevelType != EBioGalaxyMap_PlanetType.eBioGM_PlanetType_None;
    bCanBeScanned = bCanBeScanned && PlanetType != EPlanetType.NOSCAN_PLANET;
    bCanBeScanned = bCanBeScanned && CountFeatures(6, FALSE, TRUE, TRUE) > 0;
    return bCanBeScanned;
}
public event function CleanTransientData()
{
    if (SystemActorStorage != None)
    {
        ObjectActor = SystemActorStorage;
        SystemActorStorage = None;
    }
    Super.CleanTransientData();
}
public final event function int CountFeatures(EFeatureType eFeature, bool bCheckUsable, bool bCheckVisible, bool bCheckProbeable)
{
    local int nCount;
    local SFXGalaxyMapObject oChild;
    local SFXPlanetFeature F;
    
    foreach Children(oChild, )
    {
        if (ShouldCountFeature(SFXPlanetFeature(oChild), eFeature, bCheckUsable, bCheckVisible, bCheckProbeable))
        {
            ++nCount;
        }
    }
    foreach AutoGrantedFeatures(F, )
    {
        if (ShouldCountFeature(F, eFeature, bCheckUsable, bCheckVisible, bCheckProbeable))
        {
            ++nCount;
        }
    }
    return nCount;
}
public final event function EnterPlanetDetailView(Actor DetailActor)
{
    SystemActorStorage = ObjectActor;
    ObjectActor = DetailActor;
}
public final event function EnterScan()
{
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    
    foreach Children(o, )
    {
        F = SFXPlanetFeature(o);
        if (F != None)
        {
            F.EnteredScanMode();
        }
    }
}
public event function bool IsSelectable()
{
    return TRUE;
}
public native function bool IsVisited();

public event function bool IsVisitedInMap()
{
    return AlreadyExplored || IsVisited();
}
public final event function LeavePlanetDetailView()
{
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    local bool bHasRemainingProbeableFeatures;
    
    foreach Children(o, )
    {
        F = SFXPlanetFeature(o);
        if (F != None)
        {
            F.LeftScanMode();
            if (F.IsProbeable())
            {
                bHasRemainingProbeableFeatures = TRUE;
                break;
            }
        }
    }
    if (!bHasRemainingProbeableFeatures)
    {
        foreach AutoGrantedFeatures(F, )
        {
            if (F != None)
            {
                F.LeftScanMode();
                if (F.IsProbeable())
                {
                    bHasRemainingProbeableFeatures = TRUE;
                    break;
                }
            }
        }
    }
    if (!bHasRemainingProbeableFeatures)
    {
        RemoveSystemScanMarker();
    }
    ObjectActor = SystemActorStorage;
    SystemActorStorage = None;
}
public final event function LeaveScan();

public native function LoadProbeImpacts(out array<Vector> vImpacts);

public event function bool MapTagIsVisible()
{
    if (AlwaysShowMapTag || Super(SFXGalaxyMapObject).MapTagIsVisible())
    {
        return TRUE;
    }
    return FALSE;
}
public event function ObjectVisited()
{
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    local SFXSystem oSystem;
    
    Super.ObjectVisited();
    if (HasBeenSystemScanned())
    {
        foreach AutoGrantedFeatures(F, )
        {
            if (F != None && F.IsProbeable())
            {
                F.FeatureProbed();
            }
        }
    }
    SetVisited(TRUE);
    foreach Children(o, )
    {
        F = SFXPlanetFeature(o);
        if (F != None)
        {
            F.Position.X = float(F.PosX) / 1024.0;
            F.Position.Y = float(F.PosY) / 512.0;
            F.Position = PlanePosToSphere(F.Position, 100.0);
        }
        if (o != None)
        {
            o.ObjectVisited();
        }
    }
    oSystem = SFXSystem(Outer);
    if (oSystem != None)
    {
        oSystem.aReapersTouchingPlayer.Length = 0;
        oSystem.EndReaperGracePeriod();
    }
}
public event function OnSystemScan(Object oScanInstigator, Vector vScanOrigin)
{
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    
    OnScanned(oScanInstigator, vScanOrigin);
    SetSystemScannedState(TRUE);
    foreach Children(o, )
    {
        o.OnScanned(oScanInstigator, vScanOrigin);
    }
    foreach AutoGrantedFeatures(F, )
    {
        F.OnScanned(oScanInstigator, vScanOrigin);
    }
}
public native function SaveProbeImpact(Vector vImpact);

public native function SetSystemScannedState(bool bScanned);

public native function SetVisited(bool bVisited);

public event function bool ShouldDisplayUnknownTag()
{
    local array<stringref> aPlotNames;
    
    if (!LabelAlwaysVisible && (SystemLevelType == ESystemLevelType.SL_PLANET || SystemLevelType == ESystemLevelType.SL_RINGPLANET) && !IsVisited())
    {
        BuildPlotLabelList(aPlotNames);
        if (aPlotNames.Length == 0)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function CountObjectsForExploration(out int nObjectCount, out int nExploredCount, EBioGalaxyMapState eMapLevel)
{
    local SFXPlanetFeature F;
    
    Super(SFXGalaxyMapObject).CountObjectsForExploration(nObjectCount, nExploredCount, eMapLevel);
    foreach AutoGrantedFeatures(F, )
    {
        if (F != None)
        {
            F.CountObjectsForExploration(nObjectCount, nExploredCount, eMapLevel);
        }
    }
}
public function string GetPlanetDescriptionText()
{
    return Class'SFXGUIMovie'.static.UIStrRef(Description);
}
public function string GetPlanetMissionText()
{
    return Class'SFXGUIMovie'.static.UIStrRef(MissionBriefing);
}
public function float GetPlanetSize()
{
    return DefaultDisplaySize * RelativeSize;
}
public function string GetPlanetTitleText()
{
    return Class'SFXGUIMovie'.static.UIStrRef(GetMapTag());
}
public function Texture2D GetPlanetViewImage()
{
    return PreviewImage;
}
public native function bool HasBeenSystemScanned();

public function bool HasFeaturesToCountForExploration()
{
    return CountFeatures(6, TRUE, TRUE, FALSE) > 0;
}
public final function bool IsMultiLand()
{
    return CountFeatures(5, TRUE, TRUE, FALSE) > 0;
}
public function LoadMultiLandPlanetData(InterpActor Planet, out array<ParticleSystemComponent> TempComponents)
{
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    local Vector V;
    local SFXGameModeMultiLand GameMode;
    local BioPlayerController PC;
    
    if (PlanetMaterial != None)
    {
        Planet.StaticMeshComponent.SetMaterial(0, PlanetMaterial);
    }
    PC = BioWorldInfo(Planet.WorldInfo).GetLocalPlayerController();
    if (PC != None)
    {
        GameMode = SFXGameModeMultiLand(PC.GameModeManager2.HACK_GetMultiLandMode());
    }
    foreach Children(o, )
    {
        F = SFXPlanetFeature(o);
        if (!bInitialized)
        {
            V.X = float(F.PosX) / 1024.0;
            V.Y = float(F.PosY) / 512.0;
            F.Position = PlanePosToSphere(V, 100.0);
        }
        if (F.FeatureType == EFeatureType.FEATURE_LABEL || F.FeatureType == EFeatureType.FEATURE_LANDINGSITE)
        {
            if (F.IsUsable() && F.IsVisible())
            {
                F.ParticleComponent = new Class'ParticleSystemComponent';
                if (F.ParticleComponent != None)
                {
                    F.ParticleComponent.SetTemplate(GameMode.GetGameData().LandingSiteMarker);
                    F.ParticleComponent.SetAbsolute(FALSE, FALSE, FALSE);
                    F.ParticleComponent.SetScale(GameMode.GetGameData().LandingSiteScale);
                    F.ParticleComponent.SetTranslation(F.Position);
                    F.ParticleComponent.SetRotation(Rotator(F.Position));
                    F.ParticleComponent.bAutoActivate = TRUE;
                    Planet.AttachComponent(F.ParticleComponent);
                    TempComponents.AddItem(F.ParticleComponent);
                }
            }
        }
    }
    bInitialized = TRUE;
}
public function LoadPlanetData(InterpActor Planet, out array<ParticleSystemComponent> TempComponents)
{
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    local Vector V;
    local Vector vPos;
    local array<Vector> vProbeImpacts;
    local ParticleSystemComponent Particle;
    local SFXGameModeOrbital GameMode;
    local BioPlayerController PC;
    
    if (PlanetMaterial != None)
    {
        Planet.StaticMeshComponent.SetMaterial(0, PlanetMaterial);
    }
    PC = BioWorldInfo(Planet.WorldInfo).GetLocalPlayerController();
    if (PC != None)
    {
        GameMode = SFXGameModeOrbital(PC.GameModeManager2.HACK_GetOrbitalMode());
    }
    LoadProbeImpacts(vProbeImpacts);
    if (GameMode.GetGameData().ProbeLocationMarker != None)
    {
        foreach vProbeImpacts(V, )
        {
            vPos = PlanePosToSphere(V, 100.0);
            Particle = new Class'ParticleSystemComponent';
            Particle.SetTemplate(GameMode.GetGameData().ProbeLocationMarker);
            Particle.SetAbsolute(FALSE, FALSE, FALSE);
            Particle.SetTranslation(vPos);
            Particle.SetRotation(Rotator(vPos));
            Particle.bAutoActivate = TRUE;
            Planet.AttachComponent(Particle);
            TempComponents.AddItem(Particle);
        }
    }
    foreach Children(o, )
    {
        F = SFXPlanetFeature(o);
        if (!bInitialized)
        {
            V.X = float(F.PosX) / 1024.0;
            V.Y = float(F.PosY) / 512.0;
            F.Position = PlanePosToSphere(V, 100.0);
        }
        if (F.FeatureType == EFeatureType.FEATURE_ANOMOLY)
        {
            F.ParticleComponent = new Class'ParticleSystemComponent';
            if (F.ParticleComponent != None)
            {
                F.ParticleComponent.SetAbsolute(FALSE, FALSE, FALSE);
                F.ParticleComponent.SetTranslation(F.Position);
                F.ParticleComponent.bAutoActivate = FALSE;
                Planet.AttachComponent(F.ParticleComponent);
                TempComponents.AddItem(F.ParticleComponent);
            }
        }
    }
    bInitialized = TRUE;
}
public function OnDisplayPlanetDetails(BioSFHandler_GalaxyMap oGUI);

public function Vector PlanePosToSphere(Vector vPosition2D, float SphereRadius)
{
    local Vector vSphere;
    local float XP;
    local float yp;
    
    XP = (-vPosition2D.X - 0.5) * 2.0 * 3.14159274;
    yp = (0.5 - vPosition2D.Y) * 3.14159274;
    vSphere.X = Cos(XP) * Cos(yp);
    vSphere.Y = Sin(XP) * Cos(yp);
    vSphere.Z = Sin(yp);
    vSphere *= SphereRadius;
    return vSphere;
}
private final function bool ShouldCountFeature(SFXPlanetFeature oFeatureObj, EFeatureType eFeature, bool bCheckUsable, bool bCheckVisible, bool bCheckProbeable)
{
    if (oFeatureObj != None && int(oFeatureObj.FeatureType) == int(eFeature))
    {
        if (bCheckUsable)
        {
            if (!oFeatureObj.IsUsable())
            {
                return FALSE;
            }
        }
        if (bCheckVisible)
        {
            if (!oFeatureObj.IsVisible())
            {
                return FALSE;
            }
        }
        if (bCheckProbeable)
        {
            if (!oFeatureObj.IsProbeable())
            {
                return FALSE;
            }
        }
        return TRUE;
    }
    return FALSE;
}
public function Vector SphereToPlanePos(Vector vSphere, float SphereRadius)
{
    local Vector vPosition2D;
    local float angularPos;
    
    vSphere /= SphereRadius;
    angularPos = Atan2(vSphere.Y, vSphere.X) - 3.14159274 * 2.0;
    vPosition2D.X = -(angularPos / (3.14159274 * 2.0) + 0.5);
    vPosition2D.Y = 0.5 - Asin(vSphere.Z) / 3.14159274;
    return vPosition2D;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlanetEvent = "Land"
    RingColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    CloudColor = {R = 0.0, G = 0.0149999997, B = 0.0125000002, A = 1.0}
    CoronaColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    ResourceRichness = 1.0
    PlanetRotation = 1.0
    Opacity = 1.0
    RelativeSize = 1.0
    DefaultDisplaySize = 550.0
    TerrainDepthFactor = 1.0
    m_fPlanetScale = 5.5
    PlacedMineralsPool = 25000.0
    RandomMineralsBase = 350.0
    EezoMineralsBase = 1500.0
    ScanBarMaxMineralSize = 1500.0
    PlanetLandCondition = 14
    PlanetPlotLabelCondition = 14
    LabelAlwaysVisible = TRUE
    OrbitRing = EOrbitRingType.OR_ORBIT
    PlanetLevelType = EBioGalaxyMap_PlanetType.eBioGM_PlanetType_Planet
    IsActualPlanet = TRUE
    Tag = "Planet"
    Scale = 3.0
    m_fScanDetectionRange = 60.0
}