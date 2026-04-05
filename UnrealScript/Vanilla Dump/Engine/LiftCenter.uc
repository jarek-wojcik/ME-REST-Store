Class LiftCenter extends NavigationPoint
    native
    placeable;

var Vector LiftOffset;
var InterpActor MyLift;
var float MaxDist2D;
var float CollisionHeight;
var(LiftCenter) Trigger LiftTrigger;
var bool bJumpLift;

public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    if (Base == MyLift && MyLift != None)
    {
        LiftOffset = location - MyLift.location;
        MyLift.bIsLift = TRUE;
    }
}
public event function Actor SpecialHandling(Pawn Other)
{
    if (MyLift == None || LiftTrigger == None || LiftTrigger.bRecentlyTriggered)
    {
        return Self;
    }
    else
    {
        return LiftTrigger;
    }
}
public event function bool SuggestMovePreparation(Pawn Other)
{
    if (Other.Base == MyLift)
    {
        return FALSE;
    }
    if (Base != MyLift || location != MyLift.location + LiftOffset)
    {
        SetLocation(MyLift.location + LiftOffset, );
        SetBase(MyLift, , , );
    }
    if (!IsZero(MyLift.Velocity) || !ProceedWithMove(Other))
    {
        Other.Controller.WaitForMover(MyLift);
        return TRUE;
    }
    return FALSE;
}
public function bool ProceedWithMove(Pawn Other)
{
    if (Other.Controller == None)
    {
        return FALSE;
    }
    else if (LiftExit(Other.Controller.MoveTarget) != None && Other.ReachedDestination(Self))
    {
        return LiftExit(Other.Controller.MoveTarget).CanBeReachedFromLiftBy(Other);
    }
    else if (location.Z - CollisionHeight < Other.location.Z - Other.GetCollisionHeight() + Other.MaxStepHeight + 2.0 && location.Z - CollisionHeight > Other.location.Z - Other.GetCollisionHeight() - float(1200) && (VSize2D(location - Other.location) < MaxDist2D || IsZero(MyLift.Velocity) && Other.ValidAnchor() && LiftExit(Other.Anchor) != None))
    {
        return TRUE;
    }
    if (LiftTrigger != None && !LiftTrigger.bRecentlyTriggered && IsZero(MyLift.Velocity))
    {
        Other.SetMoveTarget(LiftTrigger);
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    MaxDist2D = 400.0
    CollisionHeight = 50.0
    ExtraCost = 400
    CylinderComponent = CollisionCylinder
    bNeverUseStrafing = TRUE
    bForceNoStrafing = TRUE
    bSpecialMove = TRUE
    bNoAutoConnect = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bStatic = FALSE
}