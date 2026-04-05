Class SFXGameEffect_Pull extends SFXGameEffect_PhysicsPower;

var Vector ForceVector;
var Vector Direction;
var Name BoneName;
var float Force;
var BioPawn Caster;
var BioPawn OwnerPawn;
var float MinimumVelocity;
var float MinimumVelocityForceMult;
var float minHeightForBodyFallSound;
var float DamagePerSecond;
var float TargetExtraDamage;

public function MoveActor(Vector vForce)
{
    if (OwnerPawn != None)
    {
        OwnerPawn.AddRagdollImpulse(vForce, Instigator, OwnerPawn.location, , , , 2);
    }
    else if (Owner != None && Owner.CollisionComponent != None)
    {
        Owner.CollisionComponent.AddForce(vForce, Owner.location, BoneName);
    }
}
public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    
    Super(SFXGameEffect).OnRemoved();
    if (TargetExtraDamage > float(0) && CurrentTime < Duration)
    {
        Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_DamageTakenBonus', Category);
        }
    }
}
public function OnUpdate(float DeltaSeconds)
{
    if (Owner != None)
    {
        if (Normal(Owner.Velocity) Dot Normal(ForceVector) < float(0) || VSize(Owner.Velocity) < MinimumVelocity)
        {
            MoveActor(ForceVector * MinimumVelocityForceMult);
        }
        if (DamagePerSecond > float(0))
        {
            Owner.TakeDamage(DamagePerSecond * DeltaSeconds, Caster.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), Class'SFXDamageType_Pull_DoT');
        }
        if (OwnerPawn != None && OwnerPawn.location.Z - OwnerPawn.m_fInitialZVal > minHeightForBodyFallSound)
        {
            OwnerPawn.m_bRagdollEnteredPendingBodyFallSound = TRUE;
        }
    }
}
public function OnApplied()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    Super(SFXGameEffect).OnApplied();
    if (Owner == None)
    {
        return;
    }
    OwnerPawn = BioPawn(Owner);
    Force = VSize(ForceVector);
    Direction = Normal(ForceVector);
    Owner.Velocity.X = 0.0;
    Owner.Velocity.Y = 0.0;
    Owner.Velocity.Z = 0.0;
    if (OwnerPawn != None && OwnerPawn.Mesh != None)
    {
        OwnerPawn.Mesh.SetRBLinearVelocity(Owner.Velocity);
        OwnerPawn.Mesh.SetRBAngularVelocity(Owner.Velocity);
    }
    MoveActor(ForceVector);
    if (TargetExtraDamage > float(0))
    {
        Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Effect = Manager.CreateEffect(Class'SFXGameEffect_DamageTakenBonus', Category, Duration, 1, TargetExtraDamage, Instigator);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    minHeightForBodyFallSound = 5.0
}