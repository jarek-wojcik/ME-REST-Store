Class Trigger extends Actor
    native
    placeable;

struct CheckpointRecord 
{
    var bool bCollideActors;
    
    structdefaultproperties
    {
        bCollideActors = FALSE
    }
};

var(Trigger) const editinline editconst export CylinderComponent CylinderComponent;
var(Trigger) float AITriggerDelay;
var bool bRecentlyTriggered;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (FindEventsOfClass(Class'SeqEvent_Touch'))
    {
        NotifyTriggered();
    }
}
public function UnTrigger()
{
    bRecentlyTriggered = FALSE;
}
public simulated function bool StopsProjectile(Projectile P)
{
    return bBlockActors;
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    SetCollision(Record.bCollideActors, bBlockActors, bIgnoreEncroachers);
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bCollideActors = bCollideActors;
}
public function NotifyTriggered()
{
    bRecentlyTriggered = TRUE;
    SetTimer(AITriggerDelay, FALSE, 'UnTrigger', );
}
public function bool ShouldSaveForCheckpoint()
{
    return bStatic || bNoDelete;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SpriteComponent Name=Sprite
        ReplacementPrimitive = None
        AlwaysLoadOnClient = FALSE
        AlwaysLoadOnServer = FALSE
    End Object
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 40.0
        CollisionRadius = 40.0
        bAlwaysRenderIfSelected = TRUE
        ReplacementPrimitive = None
        CollideActors = TRUE
    End Object
    CylinderComponent = CollisionCylinder
    AITriggerDelay = 2.0
    Components = (Sprite, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bHidden = TRUE
    bNoDelete = TRUE
    bCollideActors = TRUE
    bProjTarget = TRUE
}