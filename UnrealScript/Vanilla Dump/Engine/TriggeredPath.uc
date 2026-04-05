Class TriggeredPath extends NavigationPoint
    placeable;

var(TriggeredPath) Actor MyTrigger;
var(TriggeredPath) bool bOpen;

public function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bOpen = TRUE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bOpen = FALSE;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bOpen = !bOpen;
    }
    WorldInfo.Game.NotifyNavigationChanged(Self);
}
public event function Actor SpecialHandling(Pawn Other)
{
    local Actor TouchActor;
    
    if (bOpen || MyTrigger == None)
    {
        return Self;
    }
    else
    {
        TouchActor = MyTrigger.SpecialHandling(Other);
        if (TouchActor == None)
        {
            TouchActor = MyTrigger;
        }
        return TouchActor;
    }
}
public event function bool SuggestMovePreparation(Pawn Other)
{
    if (bOpen)
    {
        return FALSE;
    }
    else if (MyTrigger != None && Other.Controller.ActorReachable(MyTrigger))
    {
        if (Other.Controller.Focus == Other.Controller.MoveTarget)
        {
            Other.Controller.Focus = MyTrigger;
        }
        Other.Controller.MoveTarget = MyTrigger;
        Other.Controller.CurrentPath = None;
        Other.Controller.NextRoutePath = None;
        return FALSE;
    }
    else
    {
        Other.Controller.MoveTimer = 1.0;
        Other.Controller.bPreparingMove = TRUE;
        Other.Velocity = vect(0.0, 0.0, 0.0);
        Other.Acceleration = vect(0.0, 0.0, 0.0);
        return TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ExtraCost = 100
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}