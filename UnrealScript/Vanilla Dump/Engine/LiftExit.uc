Class LiftExit extends NavigationPoint
    native
    placeable;

var(LiftExit) LiftCenter MyLiftCenter;
var(LiftExit) bool bExitOnly;

public event function bool SuggestMovePreparation(Pawn Other)
{
    local Controller C;
    
    if (MyLiftCenter == None || Other.Controller == None)
    {
        return FALSE;
    }
    if (Other.Physics == EPhysics.PHYS_Flying)
    {
        if (Other.AirSpeed > float(0))
        {
            Other.Controller.MoveTimer = 2.0 + VSize(location - Other.location) / Other.AirSpeed;
        }
        return FALSE;
    }
    if (Other.Base == MyLiftCenter.Base || Other.ReachedDestination(MyLiftCenter))
    {
        if (CanBeReachedFromLiftBy(Other))
        {
            return FALSE;
        }
        WaitForLift(Other);
        return TRUE;
    }
    else if (MyLiftCenter != None)
    {
        foreach WorldInfo.AllControllers(Class'Controller', C)
        {
            if (C.Pawn != None && C.PendingMover == MyLiftCenter.MyLift && WorldInfo.GRI.OnSameTeam(C, Other.Controller) && C.Pawn.ReachedDestination(Self))
            {
                WaitForLift(Other);
                return TRUE;
            }
        }
        Other.Controller.ReadyForLift();
    }
    return FALSE;
}
public function bool CanBeReachedFromLiftBy(Pawn Other)
{
    return location.Z < Other.location.Z + Other.GetCollisionHeight() && Other.LineOfSightTo(Self);
}
public function WaitForLift(Pawn Other)
{
    if (MyLiftCenter != None)
    {
        Other.SetDesiredRotation(Rotator(location - Other.location));
        Other.Controller.WaitForMover(MyLiftCenter.MyLift);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    bNeverUseStrafing = TRUE
    bForceNoStrafing = TRUE
    bSpecialMove = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}