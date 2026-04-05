Class SplineActor extends Actor
    native
    placeable;

struct native SplineConnection 
{
    var(SplineConnection) editinline export SplineComponent SplineComponent;
    var(SplineConnection) SplineActor ConnectTo;
};

var(SplineActor) InterpCurveFloat SplineVelocityOverTime;
var editinline array<SplineConnection> Connections;
var array<SplineActor> LinksFrom;
var(SplineActor) Vector SplineActorTangent;
var(SplineActor) Color SplineColor;
var transient SplineActor nextOrdered;
var transient SplineActor prevOrdered;
var transient SplineActor previousPath;
var transient int bestPathWeight;
var transient int visitedWeight;
var(SplineActor) bool bDisableDestination;
var transient bool bAlreadyVisited;

public native function AddConnectionTo(SplineActor NextActor);

public native function BreakAllConnections();

public native function BreakAllConnectionsFrom();

public native function BreakConnectionTo(SplineActor NextActor);

public native function SplineComponent FindSplineComponentTo(SplineActor NextActor);

public native function bool FindSplinePathTo(SplineActor Goal, out array<SplineActor> OutRoute);

public native function SplineActor FindTargetForComponent(SplineComponent SplineComp);

public native function GetAllConnectedSplineActors(out array<SplineActor> OutSet);

public native function SplineActor GetBestConnectionInDirection(Vector DesiredDir, optional bool bUseLinksFrom);

public native function SplineActor GetRandomConnection(optional bool bUseLinksFrom);

public native function Vector GetWorldSpaceTangent();

public native function bool IsConnectedTo(SplineActor NextActor, bool bCheckForDisableDestination);

public function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bDisableDestination = FALSE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bDisableDestination = TRUE;
    }
    else
    {
        bDisableDestination = !bDisableDestination;
    }
    UpdateConnectedSplineComponents(TRUE);
}
public native function UpdateConnectedSplineComponents(bool bFinish);

public native function UpdateSplineComponents(bool bFinish);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SplineActorTangent = {X = 300.0, Y = 0.0, Z = 0.0}
    SplineColor = {B = 255, G = 0, R = 255, A = 255}
    Components = (None)
}