Class SFXReachSpecPlaceholderCylinder extends Actor
    native;

var array<Pawn> PawnsToIgnore;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 44.0
        CollisionRadius = 21.0
        ReplacementPrimitive = None
        CollideActors = TRUE
        BlockActors = TRUE
        BlockZeroExtent = FALSE
        CanBlockCamera = FALSE
    End Object
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bCollideActors = TRUE
    bBlockActors = TRUE
}