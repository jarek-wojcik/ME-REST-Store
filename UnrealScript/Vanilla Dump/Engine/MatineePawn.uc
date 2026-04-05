Class MatineePawn extends Pawn
    native
    placeable
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 72.0
        ReplacementPrimitive = None
    End Template
    Begin Object Class=SkeletalMeshComponent Name=PawnMesh
        ReplacementPrimitive = None
        Translation = {X = 0.0, Y = 0.0, Z = -72.0}
    End Object
    Mesh = PawnMesh
    CylinderComponent = CollisionCylinder
    Components = (None, CollisionCylinder, None, PawnMesh)
    CollisionComponent = CollisionCylinder
    Physics = EPhysics.PHYS_Interpolating
}