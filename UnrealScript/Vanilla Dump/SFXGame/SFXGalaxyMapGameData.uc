Class SFXGalaxyMapGameData
    native;

struct native SFXGalaxyTemplates_SystemScanning 
{
    var(SFXGalaxyTemplates_SystemScanning) SFXGalaxyTemplatePair ScanPulse;
    var(SFXGalaxyTemplates_SystemScanning) SFXGalaxyTemplatePair ScanResult;
    var(SFXGalaxyTemplates_SystemScanning) SFXGalaxyTemplatePair Reaper;
    var(SFXGalaxyTemplates_SystemScanning) SFXGalaxyTemplatePair ReaperPing;
};
struct native SFXGalaxyTemplates_Planet 
{
    var(SFXGalaxyTemplates_Planet) array<SFXGalaxyTemplatePair> Nebulae;
    var(SFXGalaxyTemplates_Planet) array<SFXGalaxyTemplatePair> Sunlight;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Planet;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair PlanetSphere;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Corona;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Object;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Clouds;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Card;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair PlanetRing;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair BackgroundCloud;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Citadel;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Camera;
    var(SFXGalaxyTemplates_Planet) SFXGalaxyTemplatePair Scanner;
};
struct native SFXGalaxyTemplates_System 
{
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Planet;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair PlanetCircle;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair PlanetRing;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Object;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Arrow;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair AsteroidBelt;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair SystemSphere;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair SystemCard1;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair SystemCard2;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Emitter;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Sunlight;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Sun;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair LensFlare;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair MassRelay;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair MassRelayRed;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair MassRelayVFX;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair FuelDepot;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Crosshair;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair Camera;
    var(SFXGalaxyTemplates_System) SFXGalaxyTemplatePair ReaperArrow;
    
    structdefaultproperties
    {
        ReaperArrow = {Tag = 'TemplateRedArrow', pActor = None}
    }
};
struct native SFXGalaxyTemplates_Cluster 
{
    var(SFXGalaxyTemplates_Cluster) array<SFXGalaxyTemplatePair> ClusterPlanes;
    var(SFXGalaxyTemplates_Cluster) array<SFXGalaxyTemplatePair> ClusterBackgrounds;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair System;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair SystemCircle;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair ClusterSphere;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair ClusterStars;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair FuelElipse;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair Emitter;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair Crosshair;
    var(SFXGalaxyTemplates_Cluster) SFXGalaxyTemplatePair Camera;
};
struct native SFXGalaxyTemplates_Galaxy 
{
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair Cluster;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair ClusterCircle;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair GalaxySphere;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair Twinkle;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair Crosshair;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair Camera;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair ClusterPath;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair DisabledClusterCircle;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair ReaperIcon;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair ReaperClusterCircle;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair CurrentLocationIcon;
    var(SFXGalaxyTemplates_Galaxy) SFXGalaxyTemplatePair PulsingCircleHighlight;
    
    structdefaultproperties
    {
        DisabledClusterCircle = {Tag = 'DisabledClusterCircleTemplate', pActor = None}
        ReaperIcon = {Tag = 'GalaxyReaperIconTemplate', pActor = None}
        ReaperClusterCircle = {Tag = 'ReaperClusterCircleTemplate', pActor = None}
        CurrentLocationIcon = {Tag = 'CurrentGalaxyLocationIcon', pActor = None}
        PulsingCircleHighlight = {Tag = 'Mission_Pulse', pActor = None}
    }
};
struct native SFXGalaxyTemplatePair 
{
    var(SFXGalaxyTemplatePair) Name Tag;
    var Actor pActor;
};
struct native SFXGalaxyAudioData 
{
    var(Fuel) string BuyFuelSound_PctFullRTPCName;
    var(Fuel) array<WwiseBaseSoundObject> ShipHalfFuelVO;
    var(Fuel) array<WwiseBaseSoundObject> ShipNoFuelClusterVO;
    var(Fuel) array<WwiseBaseSoundObject> ShipNoFuelClusterReturnVO;
    var(Fuel) array<WwiseBaseSoundObject> ShipNoFuelSystemVO;
    var(SHIP) string ShipTravelSound_SpeedRTPCName;
    var(SHIP) string ShipTravelSound_ThrustRTPCName;
    var(SHIP) string ShipTravelSound_FuelQtyRTPCName;
    var(SHIP) string ShipTravelSound_SystemClusterRTPCName;
    var(SFXGalaxyAudioData) WwiseBaseSoundObject ErrorSound;
    var(Fuel) WwiseBaseSoundObject BuyFuelSound;
    var(Fuel) WwiseBaseSoundObject BuyFuelSoundStop;
    var(Fuel) WwiseBaseSoundObject BuyFuelSound_Full;
    var(Fuel) WwiseBaseSoundObject ShipOutOfFuel_Start;
    var(Fuel) WwiseBaseSoundObject ShipOutOfFuel_Stop;
    var(Probe) WwiseBaseSoundObject BuyProbeSound;
    var(SHIP) WwiseBaseSoundObject ShipTravelSound_Start;
    var(SHIP) WwiseBaseSoundObject ShipTravelSound_Stop;
};

var(Templates) SFXGalaxyTemplates_Planet PlanetTemplates;
var(Audio) SFXGalaxyAudioData AudioData;
var(Templates) SFXGalaxyTemplates_Cluster ClusterTemplates;
var(Templates) SFXGalaxyTemplates_System SystemTemplates;
var(Templates) SFXGalaxyTemplates_Galaxy GalaxyTemplates;
var(Templates) SFXGalaxyTemplates_SystemScanning ScanningTemplates;

public final native function CachePersistentLevelReferences();

public final native function ClearPersistentLevelReferences();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SystemTemplates = {
                       Planet = {Tag = 'None', pActor = None}, 
                       PlanetCircle = {Tag = 'None', pActor = None}, 
                       PlanetRing = {Tag = 'None', pActor = None}, 
                       Object = {Tag = 'None', pActor = None}, 
                       Arrow = {Tag = 'None', pActor = None}, 
                       AsteroidBelt = {Tag = 'None', pActor = None}, 
                       SystemSphere = {Tag = 'None', pActor = None}, 
                       SystemCard1 = {Tag = 'None', pActor = None}, 
                       SystemCard2 = {Tag = 'None', pActor = None}, 
                       Emitter = {Tag = 'None', pActor = None}, 
                       Sunlight = {Tag = 'None', pActor = None}, 
                       Sun = {Tag = 'None', pActor = None}, 
                       LensFlare = {Tag = 'None', pActor = None}, 
                       MassRelay = {Tag = 'None', pActor = None}, 
                       MassRelayRed = {Tag = 'None', pActor = None}, 
                       MassRelayVFX = {Tag = 'None', pActor = None}, 
                       FuelDepot = {Tag = 'None', pActor = None}, 
                       Crosshair = {Tag = 'None', pActor = None}, 
                       Camera = {Tag = 'None', pActor = None}, 
                       ReaperArrow = {Tag = 'TemplateRedArrow', pActor = None}
                      }
    GalaxyTemplates = {
                       Cluster = {Tag = 'None', pActor = None}, 
                       ClusterCircle = {Tag = 'None', pActor = None}, 
                       GalaxySphere = {Tag = 'None', pActor = None}, 
                       Twinkle = {Tag = 'None', pActor = None}, 
                       Crosshair = {Tag = 'None', pActor = None}, 
                       Camera = {Tag = 'None', pActor = None}, 
                       ClusterPath = {Tag = 'None', pActor = None}, 
                       DisabledClusterCircle = {Tag = 'DisabledClusterCircleTemplate', pActor = None}, 
                       ReaperIcon = {Tag = 'GalaxyReaperIconTemplate', pActor = None}, 
                       ReaperClusterCircle = {Tag = 'ReaperClusterCircleTemplate', pActor = None}, 
                       CurrentLocationIcon = {Tag = 'CurrentGalaxyLocationIcon', pActor = None}, 
                       PulsingCircleHighlight = {Tag = 'Mission_Pulse', pActor = None}
                      }
}