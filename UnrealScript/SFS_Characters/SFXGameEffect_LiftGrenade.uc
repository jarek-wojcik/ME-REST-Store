Class SFXGameEffect_LiftGrenade extends SFXGameEffect;

var Class<SFXRumble_Power> SlamRumbleClass;
var Class<SFXShake_Power> SlamShakeClass;
var Vector ForceVector;
var BioPawn OwnerPawn;
var float SlamForce;
var float SlamRagdollDuration;
var ParticleSystem SlamPS;
var float UpdateInterval;
var float GravityScaleTime;
var float Force;
var float MinimumVelocity;
var WwiseEvent SlamSound;
var clearcrosslevel SFXPowerCustomAction Power;
var bool bSlamWhenDone;
var bool bBioticComboOnSlam;

public function MoveActor(Vector vForce)
{
    if (OwnerPawn != None)
    {
        OwnerPawn.AddRagdollImpulse(vForce, Instigator, OwnerPawn.location);
    }
    else if (Owner != None && Owner.CollisionComponent != None)
    {
        Owner.CollisionComponent.AddForce(vForce, Owner.location, 'None');
    }
}
public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    
    Owner.ClearTimer('UpdateRagdoll', Self);
    Super.OnRemoved();
    Owner.m_fGravityScaling = 1.0;
    if (bSlamWhenDone)
    {
        if (Owner == None)
        {
            return;
        }
        Owner.PlaySound(SlamSound, TRUE);
        Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && SlamRagdollDuration > float(0))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_Ragdoll', Category, SlamRagdollDuration, 1, 1.0, Instigator);
        }
        Owner.CollisionComponent.AddForce(vect(0.0, 0.0, -1.0) * SlamForce, Owner.location, 'None');
        SFXGRI(Owner.WorldInfo.GRI).DuringAsyncWorker.SpawnEffectAtLocation(Owner, SlamPS, Owner.location, Rotator(vect(0.0, 0.0, -1.0)));
        if (Power != None && bBioticComboOnSlam)
        {
            Power.CheckForPowerCombo(OwnerPawn, 2, OwnerPawn.location, vect(0.0, 0.0, 1.0));
            Power.PlayPowerControllerRumble(SlamRumbleClass, Owner.location);
            Power.PlayPowerScreenShake(SlamShakeClass, Owner.location);
        }
    }
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheImpactEmitter(default.SlamPS);
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
    if (Owner != None)
    {
        if (Normal(Owner.Velocity) Dot Normal(ForceVector) < float(0) || VSize(Owner.Velocity) < MinimumVelocity)
        {
            MoveActor(ForceVector * Force * UpdateInterval);
        }
        Owner.m_fGravityScaling = FClamp(1.0 - CurrentTime / GravityScaleTime, 0.0, 1.0);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SlamRumbleClass = Class'SFXRumble_Power_HeavyImpact'
    SlamShakeClass = Class'SFXShake_Power_HeavyImpact'
    SlamPS = ParticleSystem'BioVFX_Hch_Miranda.Particles.Crush_Impact'
    UpdateInterval = 0.200000003
    GravityScaleTime = 1.0
    Force = 25.0
    MinimumVelocity = 75.0
    SlamSound = WwiseEvent'Wwise_Power_Biotic_Slam.Play_power_biotic_S_slam'
}