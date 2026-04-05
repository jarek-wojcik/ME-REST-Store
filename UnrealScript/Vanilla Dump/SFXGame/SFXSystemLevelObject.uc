Class SFXSystemLevelObject extends SFXGalaxyMapObject
    native
    abstract
    config(Game);

struct native WwiseAudioPair 
{
    var(WwiseAudioPair) WwiseEvent Play;
    var(WwiseAudioPair) WwiseEvent Stop;
};

var(Sound) WwiseAudioPair ScanAudio;
var(Appearance) ParticleSystem ScanParticleSystem;
var(SFXSystemLevelObject) stringref SystemActionButtonText;
var transient int ActiveWorld;
var transient EmitterSpawnable ScanEmitter;
var editinline transient export WwiseAudioComponent AudioComponent;
var(Appearance) bool ShowOrbitRing;
var bool IsActualPlanet;
var transient bool m_bShowAsScanned;

public event function bool CanBeSystemScanned()
{
    return FALSE;
}
public event function CleanTransientData()
{
    RemoveSystemScanMarker();
    if (AudioComponent != None)
    {
        DetachTemporaryComponent(AudioComponent);
        AudioComponent = None;
    }
    Super.CleanTransientData();
}
public event function stringref GetSystemActionButtonText()
{
    return SystemActionButtonText;
}
public event function ObjectVisited();

public event function OnSystemScan(Object oScanInstigator, Vector vScanOrigin);

public function bool HasBeenScanned()
{
    return m_bShowAsScanned;
}
public function bool HasBeenSystemScanned()
{
    return FALSE;
}
public final function PlayAudio(WwiseAudioPair soundPair)
{
    local WwiseEventPair eventPair;
    
    if (ObjectActor != None && AudioComponent == None)
    {
        AudioComponent = new Class'WwiseAudioComponent';
        AudioComponent.Set3D();
        AttachTemporaryComponent(AudioComponent);
    }
    if (AudioComponent != None)
    {
        eventPair.Play = soundPair.Play;
        eventPair.Stop = soundPair.Stop;
        AudioComponent.PlayWwiseEvent(eventPair);
    }
}
public final function RemoveSystemScanMarker()
{
    CleanActor(ScanEmitter);
    ScanEmitter = None;
}
public function SetScannedState(bool bScanned)
{
    m_bShowAsScanned = bScanned;
}
public final function SpawnSystemScanMarker(optional bool bPlaySound = TRUE)
{
    if (ScanEmitter == None && ScanParticleSystem != None)
    {
        ScanEmitter = EmitterSpawnable(SpawnGalaxyActor(Class'EmitterSpawnable', ObjectActor.location));
        ScanEmitter.SetTemplate(ScanParticleSystem);
        ScanEmitter.ParticleSystemComponent.SetActive(TRUE);
    }
    SetScannedState(TRUE);
    if (bPlaySound)
    {
        PlayAudio(ScanAudio);
    }
    GetGalaxyBehavior().UpdateUITitle();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SystemActionButtonText = $260735
    ShowOrbitRing = TRUE
    MapObjectLevel = ESFXGalaxyMapObjectLevel.GalaxyMapObjType_SystemLevel
}