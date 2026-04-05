Class SFXProjectile_PowerCustomAction_InfernoChild extends SFXProjectile_PowerCustomAction
    config(Game);

var RvrClientEffectInterface CE_ChildExplosionTemplate;

public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local Vector Params;
    
    if (IsShuttingDown() || bClientPredictionActive)
    {
        return;
    }
    Super.Explode(HitLocation, HitNormal);
    Params.Y = SFXPowerCustomAction_InfernoGrenade(Power).ChildProjImpactRadius.CurrentValue;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_ChildExplosionTemplate, HitLocation, HitNormal, Params);
    Power = None;
    Caster = None;
}
public simulated function Init(Vector Direction)
{
    local float fMaxSpeed;
    
    Super.Init(Direction);
    if (Power != None)
    {
        fMaxSpeed = SFXPowerCustomAction_InfernoGrenade(Power).ChildProjMaxSpeed;
        MaxSpeed = fMaxSpeed * FRand() / 2.0 + 0.5 * fMaxSpeed;
        Speed = MaxSpeed;
        Velocity = Normal(Velocity) * MaxSpeed;
    }
}
public simulated function Recycle()
{
    Super.Recycle();
    Power = None;
    Caster = None;
}
public simulated function float GetDamageRadius()
{
    if (Power != None)
    {
        return SFXPowerCustomAction_InfernoGrenade(Power).ChildProjImpactRadius.CurrentValue;
    }
    return 0.0;
}
public function DoImpact(Actor InImpactedActor, Controller InInstigatorController, float BaseDamage, float InDamageRadius, float Momentum, Vector HurtOrigin, bool bFullDamage, out TraceHitInfo HitInfo)
{
    local Class<SFXDamageType> DamageType;
    local float Force;
    local int MaxImpactTargets;
    
    MaxImpactTargets = int(Power.MaximumImpactTargets.CurrentValue);
    if (Power != None)
    {
        Power.GetImpactDamage(InImpactedActor, DamageType);
        Force = Power.GetImpactForce(InImpactedActor);
        SFXPowerCustomAction_InfernoGrenade(Power).AreaExplosion(location, InDamageRadius, 0.0, DamageType, Force, Power.DetonationParameters, MaxImpactTargets, Power.OnImpact);
    }
}
public simulated function float GetDamage()
{
    if (Power != None)
    {
        return Power.Damage.CurrentValue;
    }
    return 0.0;
}
public simulated function bool InitializePowerProjectile(Actor oCaster, float fTravelSpeed, float fRadius, SFXPowerCustomAction oPower)
{
    local bool Result;
    
    Result = Super.InitializePowerProjectile(oCaster, fTravelSpeed, fRadius, oPower);
    Init(Vector(Rotation));
    return Result;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CE_ChildExplosionTemplate = RvrClientEffect'BioVFX_C_NapalmGrenade.VCFX.Grenade_Imp_explosion_VCFX'
    ExplosionSound = WwiseEvent'Wwise_Power_Soldier_InferGren.Play_power_soldier_S_INFgrenade_explosion'
    fFuseLength = 4.5
    ExplosionParticleLifetime = 5.0
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_C_NapalmGrenade.Particles.Napalm_Projectile_2'
    bArcing = TRUE
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    LifeSpan = 5.0
    CollisionComponent = CollisionCylinder
}