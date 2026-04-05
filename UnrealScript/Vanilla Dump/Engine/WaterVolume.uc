Class WaterVolume extends PhysicsVolume;

var(WaterVolume) Class<Actor> EntryActor;
var(WaterVolume) Class<Actor> ExitActor;
var(WaterVolume) Class<Actor> PawnEntryActor;
var(WaterVolume) SoundCue EntrySound;
var(WaterVolume) SoundCue ExitSound;

public event simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Super.Touch(Other, OtherComp, HitLocation, HitNormal);
    if (Other.CanSplash())
    {
        PlayEntrySplash(Other);
    }
}
public event function UnTouch(Actor Other)
{
    if (Other.CanSplash())
    {
        PlayExitSplash(Other);
    }
}
public function PlayEntrySplash(Actor Other)
{
    if (EntrySound != None)
    {
        Other.PlaySound(EntrySound);
        if (Other.Instigator != None)
        {
            Other.MakeNoise(1.0, );
        }
    }
    if (EntryActor != None)
    {
        Spawn(EntryActor);
    }
}
public function PlayExitSplash(Actor Other)
{
    if (ExitSound != None)
    {
        Other.PlaySound(ExitSound);
        if (Other.Instigator != None)
        {
            Other.MakeNoise(1.0, );
        }
    }
    if (ExitActor != None)
    {
        Spawn(ExitActor);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        RBChannel = ERBCollisionChannel.RBCC_Water
        bDisableAllRigidBody = FALSE
    End Template
    FluidFriction = 2.4000001
    bWaterVolume = TRUE
    LocationName = "under water"
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}