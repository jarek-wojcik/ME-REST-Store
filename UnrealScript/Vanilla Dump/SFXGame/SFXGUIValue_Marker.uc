Class SFXGUIValue_Marker extends GFxValue within SFXGUI_Markers
    native
    transient
    config(UI);

var ASDisplayInfo MarkerRootDI;
var ASDisplayInfo MarkerReticuleFreeArrowClipDI;
var ASDisplayInfo MarkerReticuleClipDI;
var ASDisplayInfo MarkerMiscTextClipAnimDI;
var config Vector2D ScreenEdgeBorder[2];
var Actor Actor;
var editinline export SkeletalMeshComponent SkelMeshComponent;
var int BoneIndex;
var GFxValue MarkerClip;
var GFxValue MarkerReticuleFreeArrowClip;
var GFxValue MarkerReticuleClip;
var GFxValue MarkerIconClip;
var GFxValue MarkerMiscTextClipAnim;
var config float OffscreenDirectionDampenPower;
var bool FullyInitialized;
var bool MarkerReticuleArrowClipDIDirty;
var bool MarkerMiscTextClipAnimDIDirty;
var bool PreviousIsOffscreen;
var EAimNodes DefaultPawnAimNodeToAttachTo;

protected native function CalculateMarkerPosition(const out SFXGUISceneView SceneView, const Vector WorldLocation, out Vector2D ScreenCoords, out Vector4 PostProjectCoords, out int LocationIsOffscreen, out int LocationIsBehindView);

protected native function Vector GetMarkerWorldPosition(SFXModule_Marker Module);

public function Initialize()
{
    FullyInitialized = TRUE;
    MarkerClip = GetObject("Marker");
    MarkerReticuleClip = MarkerClip.GetObject("MarkerReticule");
    MarkerReticuleFreeArrowClip = MarkerClip.GetObject("reticuleFree");
    MarkerIconClip = MarkerClip.GetObject("iconAnim.icons");
    MarkerMiscTextClipAnim = MarkerClip.GetObject("miscTextAnim");
    MarkerRootDI = GetDisplayInfo();
    MarkerReticuleClipDI = MarkerReticuleClip.GetDisplayInfo();
    MarkerReticuleFreeArrowClipDI = MarkerReticuleFreeArrowClip.GetDisplayInfo();
    MarkerMiscTextClipAnimDI = MarkerMiscTextClipAnim.GetDisplayInfo();
    MarkerReticuleArrowClipDIDirty = TRUE;
    MarkerMiscTextClipAnimDIDirty = TRUE;
    AS_FadeIn(0.0);
}
public native function Update(const out SFXGUISceneView SceneView);

public final native function UpdateReticuleArrows(bool MarkerIsOffscreen, const out Vector4 OffscreenDirection);

public final function AS_FadeIn(float TimeVisible)
{
    ActionScriptVoid("FadeIn");
}
public final function AS_FadeInMiscText(float TimeVisible)
{
    ActionScriptVoid("FadeInMiscText");
}
public final function AS_FadeOut()
{
    ActionScriptVoid("FadeOut");
}
public final function AS_FadeOutMiscText()
{
    ActionScriptVoid("FadeOutMiscText");
}
public final function AS_SetArrowStyle(string sArrowFrame, string sOffscreenArrowFrame)
{
    ActionScriptVoid("SetArrowStyle");
}
public final function AS_SetText(string NewText)
{
    ActionScriptVoid("SetText");
}
public function FadeOutMarker()
{
    AS_FadeOut();
}
public final function ImmediateInitialize(Actor NewActor, SFXModule_Marker Module)
{
    local Name BoneToAttachTo;
    
    Actor = NewActor;
    SkelMeshComponent = Actor.GetPrimarySkelMeshComponent();
    if (SkelMeshComponent != None)
    {
        BoneToAttachTo = Module.BoneToAttachTo;
        if (BoneToAttachTo == 'None')
        {
            if (BioPawn(Actor) != None)
            {
                BoneToAttachTo = BioPawn(Actor).AimNodes[int(DefaultPawnAimNodeToAttachTo)];
            }
            else
            {
                BoneToAttachTo = 'Root';
            }
        }
        if (BoneToAttachTo != 'None')
        {
            BoneIndex = SkelMeshComponent.MatchRefBone(BoneToAttachTo);
        }
    }
}
public function PulseMarker();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenEdgeBorder[0] = {X = 0.0500000007, Y = 0.219999999}
    ScreenEdgeBorder[1] = {X = 0.949999988, Y = 0.850000024}
    BoneIndex = -1
    OffscreenDirectionDampenPower = 7.0
    DefaultPawnAimNodeToAttachTo = EAimNodes.AimNode_Chest
}