Class DynamicBlockingVolume extends BlockingVolume
    native
    placeable;

struct CheckpointRecord 
{
    var Vector location;
    var Rotator Rotation;
    var bool bCollideActors;
    var bool bBlockActors;
    var bool bNeedsReplication;
    
    structdefaultproperties
    {
        location = {X = 0.0, Y = 0.0, Z = 0.0}
        Rotation = {Pitch = 0, Yaw = 0, Roll = 0}
        bCollideActors = FALSE
        bBlockActors = FALSE
        bNeedsReplication = FALSE
    }
};

var(DynamicBlockingVolume) bool bEnabled;

public event simulated function PostBeginPlay()
{
    Super(Volume).PostBeginPlay();
    SetCollision(bEnabled, bBlockActors, );
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    if (!bHardAttach)
    {
        SetLocation(Record.location, );
        SetRotation(Record.Rotation);
    }
    CollisionComponent.SetActorCollision(TRUE, TRUE);
    CollisionComponent.SetTraceBlocking(FALSE, TRUE);
    CollisionComponent.SetBlockRigidBody(Record.bCollideActors);
    SetCollision(Record.bCollideActors, Record.bBlockActors, );
    if (Record.bNeedsReplication)
    {
        ForceNetRelevant();
    }
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.location = location;
    Record.Rotation = Rotation;
    Record.bCollideActors = bCollideActors;
    Record.bBlockActors = bBlockActors;
    Record.bNeedsReplication = RemoteRole != ENetRole.ROLE_None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    bEnabled = TRUE
    BrushColor = {B = 100, G = 255, R = 255, A = 255}
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = FALSE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    Physics = EPhysics.PHYS_Interpolating
}