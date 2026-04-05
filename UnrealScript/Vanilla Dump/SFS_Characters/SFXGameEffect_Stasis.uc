Class SFXGameEffect_Stasis extends SFXGameEffect_WeldPhysics;

var Guid StasisCrustGuid;
var BioPawn OwnerPawn;
var float ForceDrag;
var float InitialHealth;
var float HealthThreshold;
var RvrClientEffectInterface CE_StasisCrust;
var clearcrosslevel SFXPowerCustomAction_Stasis Power;
var bool StopAllVelocity;
var bool bWasInMatinee;
var bool bWasDisabled;

public function OnRemoved()
{
    Super.OnRemoved();
    if (Power != None)
    {
        Power.OnGameEffectEnded(Owner);
    }
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_StasisCrust, StasisCrustGuid, TRUE);
    if (OwnerPawn == None)
    {
        return;
    }
    if (OwnerPawn.SnapshotNode != None)
    {
        OwnerPawn.SnapshotNode.m_bCaptureOnRelevant = TRUE;
    }
    if (bWasInMatinee || bWasDisabled)
    {
        OwnerPawn.AddRagdollImpulse(vect(0.0, 0.0, 0.0), Instigator, vect(0.0, 0.0, 0.0));
    }
}
public function OnUpdate(float DeltaSeconds)
{
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    NullVelocity(DeltaSeconds);
    if (OwnerPawn.Role == ENetRole.ROLE_Authority && (InitialHealth - OwnerPawn.GetCurrentHealth() > HealthThreshold || OwnerPawn.IsDead()))
    {
        UnStasisTarget();
        if (Power.ShouldReplicate())
        {
            Power.ReplicatePowerSubsequentImpact(OwnerPawn, , , -4);
        }
    }
}
public function OnApplied()
{
    local SFXAI_Core AI;
    
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn == None)
    {
        return;
    }
    InitialHealth = OwnerPawn.GetCurrentHealth();
    AI = SFXAI_Core(OwnerPawn.Controller);
    if (AI != None)
    {
        bWasDisabled = AI.IsInState('Disabled', TRUE);
    }
    bWasInMatinee = OwnerPawn.Physics == EPhysics.PHYS_Interpolating;
    StartCrustVFX();
    Super.OnApplied();
    NullVelocity(1.0);
}
public final function StartCrustVFX()
{
    local RvrClientEffectManager Manager;
    local RvrClientEffectTarget Target;
    
    Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (Manager != None)
    {
        Target.Instigator = Owner;
        Target.SpawnValue.X = Duration;
        StasisCrustGuid = Manager.StartOnTarget(CE_StasisCrust, Target, Owner);
    }
    else
    {
        Owner.SetTimer(0.100000001, FALSE, 'StartCrustVFX', Self);
    }
}
public function NullVelocity(float DeltaSeconds)
{
    local Vector LinearForce;
    local Vector AngularForce;
    
    if (OwnerPawn != None)
    {
        OwnerPawn.Velocity.X = 0.0;
        OwnerPawn.Velocity.Y = 0.0;
        OwnerPawn.Velocity.Z = 0.0;
        if (StopAllVelocity)
        {
            OwnerPawn.Mesh.SetRBLinearVelocity(Owner.Velocity);
            OwnerPawn.Mesh.SetRBAngularVelocity(Owner.Velocity);
        }
        else
        {
            AngularForce = OwnerPawn.Mesh.PhysicsAssetInstance.Bodies[0].GetUnrealWorldAngularVelocity();
            LinearForce = OwnerPawn.Mesh.PhysicsAssetInstance.Bodies[0].GetUnrealWorldVelocity();
            OwnerPawn.Mesh.SetRBAngularVelocity(AngularForce * ForceDrag ** DeltaSeconds);
            OwnerPawn.Mesh.SetRBLinearVelocity(LinearForce * ForceDrag ** DeltaSeconds);
        }
    }
}
public function UnStasisTarget()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    Manager = OwnerPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Category == Category)
            {
                Effect.CurrentTime = Effect.Duration + 1.0;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceDrag = 0.0500000007
    CE_StasisCrust = RvrClientEffect'BioVFX_B_Stasis.VCFX.Stasis_Crust_VCFX'
    StopAllVelocity = TRUE
}