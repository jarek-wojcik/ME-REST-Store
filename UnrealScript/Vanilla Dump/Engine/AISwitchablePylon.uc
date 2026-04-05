Class AISwitchablePylon extends Pylon
    native
    placeable;

var(AISwitchablePylon) bool bOpen;

public event function bool IsEnabled()
{
    return bOpen;
}
public function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    SetEnabled(bOpen);
}
public event function SetEnabled(bool bEnabled)
{
    bOpen = bEnabled;
    bForceObstacleMeshCollision = !bOpen;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    bNeedsCostCheck = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, 
                  None, 
                  None, 
                  CollisionCylinder, 
                  None, 
                  None, 
                  None, 
                  None
                 )
    CollisionComponent = CollisionCylinder
}