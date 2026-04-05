Class SFXModule_Marker extends SFXModule
    native
    editinlinenew
    abstract;

var(SFXModule_Marker) string MarkerType;
var Class<SFXGUIValue_Marker> GUIMarkerClass;
var(SFXModule_Marker) Vector MarkerOffset;
var(SFXModule_Marker) Name BoneToAttachTo;
var(SFXModule_Marker) stringref MarkerLabel;
var repnotify Pawn PawnWithExclusiveVisibility;
var repnotify Pawn PawnWithExclusiveInvisibility;
var privatewrite repnotify bool bActive;

public simulated function Activate()
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(ModuleOwner.WorldInfo.GRI);
    if (GRI == None || GRI.MarkerModuleManager == None)
    {
        ModuleOwner.SetTimer(0.100000001, FALSE, 'Activate', Self);
        return;
    }
    bActive = TRUE;
    GRI.MarkerModuleManager.SetMarkerActorAsActive(ModuleOwner);
}
public final simulated native function bool CanPawnSeeMarker(Pawn P);

public event simulated function HandlePostAdd()
{
    Super.HandlePostAdd();
    DeferredHandlePostAdd();
    if (bActive)
    {
        Activate();
    }
}
public event simulated function HandlePreRemove()
{
    Super.HandlePreRemove();
    if (SFXGRI(ModuleOwner.WorldInfo.GRI).MarkerModuleManager != None)
    {
        SFXGRI(ModuleOwner.WorldInfo.GRI).MarkerModuleManager.SetMarkerActorAsInactive(ModuleOwner);
        SFXGRI(ModuleOwner.WorldInfo.GRI).MarkerModuleManager.RemoveMarkerActor(ModuleOwner);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'bActive':
            ActiveStateChanged();
            break;
        default:
    }
    Super.ReplicatedEvent(VarName);
}
public simulated function ActiveStateChanged()
{
    if (bActive)
    {
        Activate();
    }
    else
    {
        Deactivate();
    }
}
public simulated function Deactivate()
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(ModuleOwner.WorldInfo.GRI);
    if (GRI == None || GRI.MarkerModuleManager == None)
    {
        ModuleOwner.SetTimer(0.100000001, FALSE, 'Deactivate', Self);
        return;
    }
    bActive = FALSE;
    GRI.MarkerModuleManager.SetMarkerActorAsInactive(ModuleOwner);
}
public final simulated function DeferredHandlePostAdd()
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(ModuleOwner.WorldInfo.GRI);
    if (GRI == None || GRI.MarkerModuleManager == None)
    {
        ModuleOwner.SetTimer(0.100000001, FALSE, 'DeferredHandlePostAdd', Self);
        return;
    }
    GRI.MarkerModuleManager.AddMarkerActor(ModuleOwner);
}

replication
{
    if (bNetDirty && int(GetActorRole()) == 3)
        MarkerType, MarkerOffset, MarkerLabel, PawnWithExclusiveVisibility, PawnWithExclusiveInvisibility, bActive;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bNetVisible = TRUE
}