Class SFXGUIValue_MarkerGrenade extends SFXGUIValue_Marker within SFXGUI_Markers
    native
    transient
    config(UI);

var config Vector2D MarkerScale;
var config float FadeInExponent;
var Pawn Player;
var float DisplayRange;

public function Initialize()
{
    local SFXModule_MarkerGrenade Marker;
    
    Super.Initialize();
    Marker = Actor.GetModule(Class'SFXModule_MarkerGrenade');
    DisplayRange = Marker.VisibleDistance;
    Player = Outer.GetPC().Pawn;
    AS_SetArrowStyle("grenade", "grenade");
    MarkerIconClip.GotoAndStop("grenade");
    MarkerReticuleFreeArrowClip.GetObject("bigArrow").SetVisible(FALSE);
    MarkerReticuleFreeArrowClipDI.visible = FALSE;
    MarkerMiscTextClipAnimDI.visible = FALSE;
    MarkerMiscTextClipAnim.SetDisplayInfo(MarkerMiscTextClipAnimDI);
}
public native function Update(const out SFXGUISceneView SceneView);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FadeInExponent = 20.0
    ScreenEdgeBorder[0] = {X = 0.100000001, Y = 0.270000011}
    ScreenEdgeBorder[1] = {X = 0.899999976, Y = 0.800000012}
}