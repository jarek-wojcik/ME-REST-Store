Class FluidSurfaceActor extends Actor
    native
    placeable;

var(FluidSurfaceActor) const editinline editconst export FluidSurfaceComponent FluidComponent;
var(FluidSurfaceActor) ParticleSystem ProjectileEntryEffect;

public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    FluidComponent.ApplyForce(HitLocation, FluidComponent.ForceImpact, FluidComponent.TestRippleRadius, TRUE);
}
public event simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Super.Touch(Other, OtherComp, HitLocation, HitNormal);
    Other.ApplyFluidSurfaceImpact(Self, HitLocation);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=FluidSurfaceComponent Name=NewFluidComponent
        ReplacementPrimitive = None
    End Object
    FluidComponent = NewFluidComponent
    Components = (NewFluidComponent)
    bNoDelete = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bProjTarget = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}