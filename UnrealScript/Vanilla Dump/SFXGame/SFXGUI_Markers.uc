Class SFXGUI_Markers extends SFXGUIMovie
    native
    transient
    config(UI);

var array<SFXGUIValue_Marker> Markers;
var privatewrite stringref ObjectiveText;
var privatewrite Actor ObjectiveTextActor;
var config float TextStayUpDuration;

public event function OnStart()
{
    Super.OnStart();
    DeferredConnectToMarkerManager();
}
public event function OnClose()
{
    local SFXMarkerModuleManager MarkerModuleManager;
    local SFXGRI GRI;
    
    GRI = SFXGRI(oWorldInfo.GRI);
    Super.OnClose();
    Markers.Remove(0, Markers.Length);
    if (GRI != None)
    {
        MarkerModuleManager = GRI.MarkerModuleManager;
        MarkerModuleManager.ClearMarkerActivatedDelegate(AddMarker);
        MarkerModuleManager.ClearMarkerDeactivatedDelegate(RemoveMarker);
        MarkerModuleManager.ClearManagerDestroyedDelegate(MarkerManagerDestroyed);
    }
}
public final function AddMarker(Actor NewMarkerActor)
{
    local SFXGUIValue_Marker NewMarker;
    local SFXGUIValue_Marker MarkerIter;
    local SFXModule ModuleIter;
    local SFXModule_Marker ModuleMarkerIter;
    
    foreach Markers(MarkerIter, )
    {
        if (MarkerIter.Actor == NewMarkerActor)
        {
            return;
        }
    }
    foreach NewMarkerActor.Modules(ModuleIter, )
    {
        ModuleMarkerIter = SFXModule_Marker(ModuleIter);
        if (ModuleMarkerIter != None && ModuleMarkerIter.bActive)
        {
            break;
        }
    }
    if (ModuleMarkerIter != None)
    {
        NewMarker = ASAddMarker().CastTo(ModuleMarkerIter.GUIMarkerClass);
        NewMarker.ImmediateInitialize(NewMarkerActor, ModuleMarkerIter);
        Markers.AddItem(NewMarker);
    }
}
public final function GFxValue ASAddMarker()
{
    return ActionScriptObject("AddMarker");
}
public final function ASFadeOutObjectiveText()
{
    ActionScriptVoid("FadeOutObjectiveText");
}
public final function ASPlayObjectiveText(string Text, float StayUpDuration)
{
    ActionScriptVoid("PlayObjectiveText");
}
public final function ASPlayTextPopupAnimation(string Text)
{
    ActionScriptVoid("PlayTextPopupAnimation");
}
public final function ASRemoveMarker(GFxValue MovieClip)
{
    ActionScriptVoid("RemoveMarker");
}
public final function BeginOnDemandPulse()
{
    local SFXGUIValue_Marker MarkerIter;
    
    foreach Markers(MarkerIter, )
    {
        MarkerIter.PulseMarker();
    }
}
public function ConnectToMarkerManager()
{
    local array<Actor> ActiveMarkerActors;
    local Actor ActorIter;
    local SFXMarkerModuleManager MarkerModuleManager;
    local SFXGRI GRI;
    
    GRI = SFXGRI(oWorldInfo.GRI);
    if (GRI == None || GRI.MarkerModuleManager == None)
    {
        DeferredConnectToMarkerManager();
        return;
    }
    MarkerModuleManager = GRI.MarkerModuleManager;
    ActiveMarkerActors = MarkerModuleManager.GetActiveMarkerActors();
    foreach ActiveMarkerActors(ActorIter, )
    {
        AddMarker(ActorIter);
    }
    MarkerModuleManager.AddMarkerActivatedDelegate(AddMarker);
    MarkerModuleManager.AddMarkerDeactivatedDelegate(RemoveMarker);
    MarkerModuleManager.AddManagerDestroyedDelegate(MarkerManagerDestroyed);
}
public function DeferredConnectToMarkerManager()
{
    local PlayerController PC;
    
    PC = GetPC();
    if (PC != None)
    {
        PC.SetTimer(0.100000001, FALSE, 'ConnectToMarkerManager', Self);
    }
}
public final function DelayedGFxInitialize()
{
    local SFXGUIValue_Marker MarkerIter;
    
    foreach Markers(MarkerIter, )
    {
        if (!MarkerIter.FullyInitialized)
        {
            MarkerIter.Initialize();
        }
    }
}
public final function DisplayObjectiveText()
{
    if (ObjectiveText != 0)
    {
        ASPlayObjectiveText(UIStrRef(ObjectiveText), TextStayUpDuration);
    }
}
public final function DisplayTextPopup(string Text)
{
    ASPlayTextPopupAnimation(Text);
}
public final function FadeOutMarkers()
{
    local SFXGUIValue_Marker MarkerIter;
    
    foreach Markers(MarkerIter, )
    {
        MarkerIter.FadeOutMarker();
    }
}
public final function HideObjectiveText()
{
    if (ObjectiveText != 0)
    {
        ASFadeOutObjectiveText();
    }
}
public final function MarkerManagerDestroyed()
{
    DeferredConnectToMarkerManager();
}
public final function RemoveMarker(Actor MarkerActorToRemove)
{
    local SFXGUIValue_Marker MarkerIter;
    
    foreach Markers(MarkerIter, )
    {
        if (MarkerIter.Actor == MarkerActorToRemove)
        {
            ASRemoveMarker(MarkerIter);
            Markers.RemoveItem(MarkerIter);
            break;
        }
    }
}
public final function SetObjectiveText(stringref NewObjectiveText, Actor NewObjectiveTextActor)
{
    ObjectiveText = NewObjectiveText;
    ObjectiveTextActor = NewObjectiveTextActor;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TextStayUpDuration = 4.0
}