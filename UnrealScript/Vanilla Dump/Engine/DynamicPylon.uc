Class DynamicPylon extends Pylon
    native
    placeable;

var bool bMoving;

public native function FlushDynamicEdges();

public function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    RebuildDynamicEdges();
}
public native function RebuildDynamicEdges();

public event function StartedMoving()
{
    bMoving = TRUE;
    FlushDynamicEdges();
}
public event function StoppedMoving()
{
    bMoving = FALSE;
    RebuildDynamicEdges();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
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
    bStatic = FALSE
}