Class SFXGameEffect_BarrierLift extends SFXGameEffect;

var Vector Force;
var BioPawn OwnerPawn;
var float UpdateInterval;
var float MinimumVelocity;

public function OnRemoved()
{
    Owner.ClearTimer('UpdateRagdoll', Self);
    Super.OnRemoved();
}
public function OnApplied()
{
    Super.OnApplied();
    if (Owner == None)
    {
        return;
    }
    OwnerPawn = BioPawn(Owner);
    Owner.SetTimer(UpdateInterval, TRUE, 'UpdateRagdoll', Self);
}
public final function UpdateRagdoll()
{
    if (OwnerPawn != None)
    {
        if (Normal(Owner.Velocity) Dot Normal(Force) < float(0) || VSize(Owner.Velocity) < MinimumVelocity)
        {
            OwnerPawn.AddRagdollImpulse(Force, Instigator, OwnerPawn.location);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Force = {X = 0.0, Y = 0.0, Z = 25.0}
    UpdateInterval = 0.200000003
    MinimumVelocity = 75.0
}