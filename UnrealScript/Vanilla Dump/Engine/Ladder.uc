Class Ladder extends NavigationPoint
    native
    placeable;

var LadderVolume MyLadder;
var Ladder LadderList;

public event function bool SuggestMovePreparation(Pawn Other)
{
    if (MyLadder == None)
    {
        return FALSE;
    }
    if (!MyLadder.InUse(Other))
    {
        MyLadder.PendingClimber = Other;
        return FALSE;
    }
    Other.Controller.bPreparingMove = TRUE;
    Other.Acceleration = vect(0.0, 0.0, 0.0);
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 80.0
        CollisionRadius = 40.0
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bNotBased = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}