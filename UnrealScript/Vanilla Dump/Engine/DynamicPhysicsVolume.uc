Class DynamicPhysicsVolume extends PhysicsVolume
    placeable;

var(DynamicPhysicsVolume) bool bEnabled;

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetCollision(bEnabled, bBlockActors, );
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    bEnabled = TRUE
    BrushColor = {B = 255, G = 255, R = 100, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = FALSE
    Physics = EPhysics.PHYS_Interpolating
}