Class SFXSmokeActorBase extends Actor
    native
    abstract;

var(SFXSmokeActorBase) editinline export ParticleSystemComponent PSC_Smoke;
var const float SmokeDuration;
var transient bool bActive;

public simulated function Destroyed()
{
    Super.Destroyed();
    SFXGame(WorldInfo.Game).CurrentSmokeCount--;
    BioWorldInfo(WorldInfo).SmokeList.RemoveItem(Self);
}
public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    BioWorldInfo(WorldInfo).SmokeList.AddItem(Self);
    bActive = TRUE;
    SetTimer(SmokeDuration, FALSE, 'Deactivate', );
}
public simulated function Reset()
{
    Destroy();
}
public simulated function Deactivate()
{
    bActive = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=Cylinder0
        CollisionHeight = 300.0
        CollisionRadius = 200.0
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=PSC_Smoke0
        ReplacementPrimitive = None
    End Object
    PSC_Smoke = PSC_Smoke0
    SmokeDuration = 14.0
    Components = (PSC_Smoke0, Cylinder0)
    LifeSpan = 20.0
    CollisionComponent = Cylinder0
}