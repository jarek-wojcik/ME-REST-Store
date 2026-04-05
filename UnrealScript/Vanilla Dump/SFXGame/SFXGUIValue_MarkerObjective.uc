Class SFXGUIValue_MarkerObjective extends SFXGUIValue_Marker within SFXGUI_Markers
    native
    transient
    config(UI);

var config float MarkerReticleStayUpDuration;
var config float MarkerTextStayUpDuration;
var BioPawn LocalPlayer;
var bool ShouldPlaySpawn;

public function Initialize()
{
    local SFXModule_MarkerObjective MarkerModule;
    
    Super.Initialize();
    MarkerModule = Actor.GetModule(Class'SFXModule_MarkerObjective');
    if (MarkerModule.MarkerIconType == EObjectiveMarkerIconType.EOMIT_Supply)
    {
        MarkerReticuleFreeArrowClip.GetObject("bigArrow").SetVisible(FALSE);
        MarkerIconClip.GotoAndStop("supply");
    }
    else
    {
        MarkerReticuleFreeArrowClip.GetObject("littleArrow").SetVisible(FALSE);
        MarkerIconClip.GotoAndStop("none");
        if (MarkerModule.MarkerIconType == EObjectiveMarkerIconType.EOMIT_Attack)
        {
            AS_SetArrowStyle("red", "red");
        }
        else
        {
            AS_SetArrowStyle("blue", "blueblink");
        }
    }
    MarkerReticuleFreeArrowClipDI.visible = FALSE;
    AS_SetText(Outer.GetUIString(MarkerModule.MarkerLabel));
    if (ShouldPlaySpawn)
    {
        PulseMarker();
        PlayOnSpawnSoundEffect();
    }
    else
    {
        GotoAndStop("fadedOut");
    }
    DeferredInitialize();
}
public native function Update(const out SFXGUISceneView SceneView);

public function DeferredInitialize()
{
    LocalPlayer = BioPawn(Outer.GetPC().Pawn);
    if (LocalPlayer == None)
    {
        Actor.SetTimer(0.100000001, FALSE, 'DeferredInitialize', Self);
    }
}
public function FadeOutMarker()
{
    AS_FadeOutMiscText();
}
public function PlayOnSpawnSoundEffect()
{
    Outer.PlayGuiSound('ObjectiveMarkerSpawn');
}
public function PulseMarker()
{
    AS_FadeInMiscText(MarkerTextStayUpDuration);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MarkerReticleStayUpDuration = 5.0
    MarkerTextStayUpDuration = 4.0
    ShouldPlaySpawn = TRUE
}