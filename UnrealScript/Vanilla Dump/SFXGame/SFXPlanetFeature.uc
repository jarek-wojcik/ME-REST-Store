Class SFXPlanetFeature extends SFXGalaxyMapObject
    native
    editinlinenew
    config(Game);

enum ESFXPlanetFeatureEventTransitionAutoSet
{
    SFXPlanetFeatureEventTransition_Unset,
};
enum ESFXPlanetFeatureEventTransitionPlotAutoSet
{
    SFXPlanetFeatureEventTransitionPlot_Unset,
};
enum EMineralType
{
    MINERAL_RED,
    MINERAL_BLUE,
    MINERAL_GREEN,
    MINERAL_ALPHA,
};
enum EFeatureType
{
    FEATURE_INVALID,
    FEATURE_MINERAL,
    FEATURE_LABEL,
    FEATURE_PROBES,
    FEATURE_ARTIFACT,
    FEATURE_LANDINGSITE,
    FEATURE_ANOMOLY,
};

var(RTPC) string RTPCName;
var(Map) string LandingSiteMapName;
var transient Vector Position;
var int FeatureTransition;
var(Conditions) int FeatureTransitionParameter;
var(RTPC) WwiseBaseSoundObject StartEvent;
var(RTPC) WwiseBaseSoundObject StopEvent;
var(Label) stringref LandingSiteText;
var(Appearance) ParticleSystem FeatureMarker;
var(Appearance) float MarkerScale;
var editinline transient export ParticleSystemComponent ParticleComponent;
var transient int ScaledAmount;
var(Label) bool CritPathFeature;
var(Appearance) bool Hidden;
var(SFXPlanetFeature) EFeatureType FeatureType;
var(Conditions) EBioRegionAutoSet FeatureTransitionRegion;
var(Conditions) ESFXPlanetFeatureEventTransitionPlotAutoSet FeatureTransitionPlot;
var(Conditions) ESFXPlanetFeatureEventTransitionAutoSet FeatureTransitionName;

public event function bool BuildPlotLabelList(out array<stringref> aPlotNames, optional EBioGalaxyMapState eMapLevel = 0)
{
    local BioWorldInfo oBWI;
    local BioPlanet oPlanet;
    local bool bHasCritPath;
    
    if (FeatureType == EFeatureType.FEATURE_LABEL && IsVisible())
    {
        bHasCritPath = CritPathFeature;
        aPlotNames.AddItem(GetFeatureText());
    }
    else if (FeatureType == EFeatureType.FEATURE_LANDINGSITE)
    {
        oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
        oPlanet = BioPlanet(Outer);
        if (oBWI != None && oPlanet != None)
        {
            if (oPlanet.IsVisited() && Self.IsVisible() && (oPlanet.PlanetPlotLabelCondition <= 0 || oBWI.CheckConditional(oPlanet.PlanetPlotLabelCondition) == FALSE) && oPlanet.IsVisible() && oPlanet.IsUsable())
            {
                bHasCritPath = CritPathFeature;
                aPlotNames.AddItem(GetFeatureText());
            }
        }
    }
    return bHasCritPath;
}
public event function CleanTransientData()
{
    if (ParticleComponent != None)
    {
        ParticleComponent.DeactivateSystem();
        BioPlanet(Outer).DetachTemporaryComponent(ParticleComponent);
        ParticleComponent = None;
    }
    Super.CleanTransientData();
}
public final event function stringref GetFeatureText()
{
    return LandingSiteText;
}
public event function PerformTransition()
{
    local BioWorldInfo oBWI;
    
    if (FeatureTransition >= 0)
    {
        oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
        if (oBWI != None)
        {
            oBWI.ExecuteStateTransition(FeatureTransition, FeatureTransitionParameter);
        }
    }
}
public final function EnableFeatureMarker()
{
    if (Hidden)
    {
        return;
    }
    if (ParticleComponent == None)
    {
        ParticleComponent = new Class'ParticleSystemComponent';
        if (ParticleComponent != None)
        {
            ParticleComponent.SetAbsolute(FALSE, FALSE, FALSE);
            ParticleComponent.bAutoActivate = FALSE;
        }
    }
    if (ParticleComponent != None && FeatureMarker != None)
    {
        BioPlanet(Outer).AttachTemporaryComponent(ParticleComponent);
        ParticleComponent.SetTemplate(FeatureMarker);
        ParticleComponent.SetTranslation(Position);
        ParticleComponent.SetRotation(Rotator(Position));
        ParticleComponent.SetScale(MarkerScale);
        ParticleComponent.ActivateSystem();
    }
}
public function EnteredScanMode()
{
    if (IsUsable() && IsVisible() && ShouldShowFeatureMarker())
    {
        EnableFeatureMarker();
    }
}
public function FeatureProbed()
{
    local BioPlayerController oPC;
    
    oPC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (FeatureType == EFeatureType.FEATURE_ANOMOLY)
    {
        oPC.HintSystem.HintEvent('PlanetRevealAnomaly');
    }
    EnableFeatureMarker();
    PerformTransition();
}
public function bool IsProbeable()
{
    return FALSE;
}
public function LeftScanMode()
{
    if (ParticleComponent != None)
    {
        ParticleComponent.DeactivateSystem();
        BioPlanet(Outer).DetachTemporaryComponent(ParticleComponent);
    }
}
public function bool ShouldShowFeatureMarker()
{
    return IsUsable() && IsVisible() && !Hidden;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FeatureTransition = -1
    Tag = "Feature"
    MapObjectLevel = ESFXGalaxyMapObjectLevel.GalaxyMapObjType_PlanetLevel
}