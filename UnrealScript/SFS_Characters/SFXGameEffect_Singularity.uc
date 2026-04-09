Class SFXGameEffect_Singularity extends SFXGameEffect_PhysicsPower;

var Vector SingularityLocation;
var Name BoneName;
var float InnerRadius;
var float UpdateInterval;
var BioPawn Caster;
var BioPawn OwnerPawn;
var float SingularityRadius;
var float ForcePerSecond;
var float DamagePerSecond;
var float minHeightForBodyFallSound;
var clearcrosslevel SFXPowerCustomAction_Singularity Power;
var bool bApplied;

public function OnRemoved()
{
    local BioPawn oBioPawn;
    
    Super(SFXGameEffect).OnRemoved();
    Owner.ClearTimer('UpdateActor', Self);
    if (!bApplied)
    {
        return;
    }
    bApplied = FALSE;
    oBioPawn = BioPawn(Owner);
    if (oBioPawn != None)
    {
        oBioPawn.m_bRagdollEnteredPendingBodyFallSound = TRUE;
    }
    if (Power != None)
    {
        Power.OnGameEffectEnded(Owner);
    }
}
public function OnApplied()
{
    Super(SFXGameEffect).OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (bApplied)
    {
        return;
    }
    if (Owner == None)
    {
        return;
    }
    InnerRadius = SingularityRadius * 0.5;
    InitialMovement();
    bApplied = TRUE;
    Owner.SetTimer(UpdateInterval, TRUE, 'UpdateActor', Self);
}
public function AddForceToActor(Vector vForce)
{
    if (OwnerPawn != None)
    {
        OwnerPawn.AddRagdollImpulse(vForce, Instigator, OwnerPawn.location, , , , 2);
    }
    else
    {
        Owner.CollisionComponent.AddForce(vForce, Owner.location, BoneName);
    }
}
public function InitialMovement()
{
    local Vector Direction;
    
    if (Owner == None || Owner.CollisionComponent == None)
    {
        return;
    }
    Direction = SingularityLocation - Owner.location;
    if (VSize(Direction) < 1.0)
    {
        Direction = VRand();
    }
    Direction = Normal(Direction);
    AddForceToActor(Direction * ForcePerSecond);
}
public function bool IsStillInSingularity()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    if (Owner == None)
    {
        return FALSE;
    }
    Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class == Class'SFXGameEffect_Singularity' && oEffect != Self)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function bool OutOfRangeCheck(float Distance)
{
    local SFXModule_GameEffectManager Manager;
    
    if (Distance < SingularityRadius * 4.0)
    {
        return FALSE;
    }
    CurrentTime = Duration + 1.0;
    if (Owner != None)
    {
        Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.RemoveEffectsByCategory(Category);
        }
    }
    return TRUE;
}
public function UpdateActor()
{
    local Vector Direction;
    local float Distance;
    local float fVelocity;
    
    if (Owner == None || Owner.CollisionComponent == None)
    {
        return;
    }
    if (DamagePerSecond > float(0))
    {
        Owner.TakeDamage(DamagePerSecond * UpdateInterval, Caster.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), Class'SFXDamageType_Singularity_DoT');
    }
    Direction = SingularityLocation - Owner.location;
    Distance = VSize(Direction);
    Direction = Normal(Direction);
    fVelocity = VSize(Owner.Velocity);
    if (OutOfRangeCheck(Distance) == FALSE)
    {
        if (Duration - CurrentTime < 1.5)
        {
            AddForceToActor(Normal(Owner.Velocity) * ForcePerSecond);
        }
        else if (Distance > InnerRadius)
        {
            AddForceToActor(Direction * ForcePerSecond * UpdateInterval);
        }
        else if (fVelocity < 100.0)
        {
            AddForceToActor(Normal(Owner.Velocity) * ForcePerSecond * UpdateInterval);
        }
    }
    if (OwnerPawn != None && OwnerPawn.location.Z - OwnerPawn.m_fInitialZVal > minHeightForBodyFallSound)
    {
        OwnerPawn.m_bRagdollEnteredPendingBodyFallSound = TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    UpdateInterval = 0.25
    minHeightForBodyFallSound = 5.0
}