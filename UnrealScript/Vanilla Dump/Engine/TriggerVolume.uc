Class TriggerVolume extends Volume
    native
    placeable;

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (BrushComponent != None)
    {
        bProjTarget = BrushComponent.BlockZeroExtent;
    }
}
public simulated function bool StopsProjectile(Projectile P)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushColor = {B = 100, G = 255, R = 100, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bProjTarget = TRUE
}