Class SFXGUIValue_MarkerObjectiveSP extends SFXGUIValue_MarkerObjective within SFXGUI_Markers
    transient
    config(UI);

public function Initialize()
{
    local SFXModule_MarkerObjectiveSP MarkerSPModule;
    
    MarkerSPModule = Actor.GetModule(Class'SFXModule_MarkerObjectiveSP');
    ShouldPlaySpawn = MarkerSPModule.DisplayMarkerOnSpawn;
    Super.Initialize();
}
public function FadeOutMarker()
{
    AS_FadeOut();
}
public function PulseMarker()
{
    AS_FadeIn(MarkerReticleStayUpDuration);
    AS_FadeInMiscText(MarkerTextStayUpDuration);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}