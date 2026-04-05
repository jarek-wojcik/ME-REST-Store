Class SFXGUIValue_MarkerPlayer extends SFXGUIValue_Marker within SFXGUI_Markers
    native
    transient
    config(UI);

var BioPawn Player;
var float TimeToHideDeathIconAt;
var config float MaxWorldDistanceForVisibility;
var config float MaxScreenDistanceFromCenter;
var config float LingeringDeathIconTime;
var bool PreviousIconIsVisible;
var bool PreviousPlayerIsDead;

public function Initialize()
{
    Player = BioPawn(Actor);
    Super.Initialize();
    if (Player.IsLocallyControlled())
    {
        MarkerRootDI.visible = FALSE;
        SetDisplayInfo(MarkerRootDI);
    }
    MarkerReticuleFreeArrowClipDI.visible = FALSE;
    MarkerReticuleClipDI.visible = FALSE;
    MarkerReticuleFreeArrowClip.GetObject("bigArrow").SetVisible(FALSE);
    Player.SetTimer(0.100000001, TRUE, 'DeferredMarkerTextUpdate', Self);
}
public final native function bool IsTargetInAreaOfInterest(Vector TargetLocation, const out SFXGUISceneView SceneView);

public native function Update(const out SFXGUISceneView SceneView);

public native function UpdateIcon(bool PlayerIsDown, bool PlayerIsDead);

public final function DeferredMarkerTextUpdate()
{
    if (Player.PlayerReplicationInfo == None)
    {
        return;
    }
    Player.ClearTimer('DeferredMarkerTextUpdate', Self);
    AS_SetText(Player.GetHumanReadableName());
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxWorldDistanceForVisibility = 800.0
    MaxScreenDistanceFromCenter = 0.349999994
    LingeringDeathIconTime = 4.0
    DefaultPawnAimNodeToAttachTo = EAimNodes.AimNode_Head
}