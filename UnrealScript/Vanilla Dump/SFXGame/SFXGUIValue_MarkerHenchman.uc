Class SFXGUIValue_MarkerHenchman extends SFXGUIValue_Marker within SFXGUI_Markers
    native
    transient
    config(UI);

var BioPawn Henchman;
var bool PreviousHenchmanIsDown;

public function Initialize()
{
    Henchman = SFXPawn_Henchman(Actor);
    Super.Initialize();
    MarkerReticuleFreeArrowClipDI.visible = FALSE;
    MarkerReticuleClipDI.visible = FALSE;
    MarkerMiscTextClipAnimDI.visible = FALSE;
    MarkerReticuleFreeArrowClip.GetObject("bigArrow").SetVisible(FALSE);
    MarkerMiscTextClipAnim.SetDisplayInfo(MarkerMiscTextClipAnimDI);
    MarkerIconClip.GotoAndStop("revive");
}
public native function Update(const out SFXGUISceneView SceneView);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}