Class SFXGameEffect_IncendiaryAmmo extends SFXGameEffect_AmmoPower;

var Class<SFXDamageType> DamageType;
var float AreaExplosionChance;
var float Damage;
var float DOTDuration;
var(SFXGameEffect_IncendiaryAmmo) ParticleSystem PS_FlameEffect;
var(SFXGameEffect_IncendiaryAmmo) ParticleSystem PS_FireSpreadEffect;
var float SpareAmmoBonus;
var float HeadShotDamageBonus;
var float LastTimeFlameSpawned;
var float MinTimeBetweenFlameSpawns;
var bool bAreaExplosion;

public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnRemoved();
    if (OwnerWeapon == None)
    {
        return;
    }
    Manager = OwnerWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (SpareAmmoBonus > float(0))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_SpareAmmo', Category);
    }
    if (HeadShotDamageBonus > float(0))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_ConstraintDmgBonus', Category);
    }
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(SFXGameEffect).PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheImpactParticleSystemComponent(default.PS_FlameEffect);
    ObjectPool.PrecacheImpactParticleSystemComponent(default.PS_FireSpreadEffect);
}
public function float GetDamageVocProbabilityMod()
{
    return 0.0500000007;
}
public function OnApplied()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnApplied();
    if (OwnerWeapon == None)
    {
        return;
    }
    Manager = OwnerWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (SpareAmmoBonus > float(0))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_SpareAmmo', Category, 0.0, 2, SpareAmmoBonus, Instigator);
    }
    if (HeadShotDamageBonus > float(0))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_ConstraintDmgBonus', Category, 0.0, 2, HeadShotDamageBonus, Instigator);
    }
    LastTimeFlameSpawned = -100.0;
}
public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    local Actor oHitActor;
    local float fExtraDamage;
    local float LastExplosionTime;
    local SFXGameEffect_FireDamageOverTime DamageEffect;
    local SFXModule_GameEffectManager Manager;
    local BioPawn HitPawn;
    local float fZeroDamage;
    local Vector fZeroForce;
    local Actor oTargetOverride;
    local EPowerResistance Resistance;
    
    Super.OnWeaponImpact(Weapon, Impact);
    oHitActor = GetHitTarget(Impact);
    if (Weapon == None || oHitActor == None || Power == None)
    {
        return;
    }
    HitPawn = BioPawn(oHitActor);
    if (HitPawn != None && Power.m_oPawn.IsFriendly(BioPawn(oHitActor)))
    {
        return;
    }
    if (bAreaExplosion && Power.m_oPawn != None && Power.m_oPawn.WorldInfo != None && Power.m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (FRand() < AreaExplosionChance && Power.m_oPawn.WorldInfo.GameTimeSeconds - LastExplosionTime > 1.0)
        {
            LastExplosionTime = Power.m_oPawn.WorldInfo.GameTimeSeconds;
            SFXPowerCustomAction_IncendiaryAmmo(Power).DoEvolvedAoEImpact(Impact, Self);
        }
    }
    fExtraDamage = GetWeaponDamage(Weapon, Impact) * Damage;
    Resistance = oHitActor.GetPowerResistance(Power.m_oPawn, Impact.HitLocation, Impact.HitNormal, fZeroDamage, fZeroForce, DamageType, oTargetOverride);
    if (oTargetOverride != None)
    {
        oHitActor = oTargetOverride;
    }
    HitPawn = BioPawn(oHitActor);
    if (oHitActor.ImpactWithPower(Resistance, None, Impact.HitLocation, Impact.HitNormal, fZeroDamage, fZeroForce, DamageType))
    {
        if (HitPawn != None)
        {
            HitPawn.ReplicateAnimatedReaction(HitPawn.CurrentCustomAction);
        }
    }
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        Manager = oHitActor.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            DamageEffect = SFXGameEffect_FireDamageOverTime(Manager.GetFirstEffectOfTypeAndCategory(Class'SFXGameEffect_FireDamageOverTime', Name));
            if (DamageEffect != None)
            {
                DamageEffect.AddFireDamage(fExtraDamage, DOTDuration);
            }
            else
            {
                DamageEffect = SFXGameEffect_FireDamageOverTime(Manager.CreateEffect(Class'SFXGameEffect_FireDamageOverTime', Name, DOTDuration, 1, fExtraDamage / DOTDuration, Power.m_oPawn.Controller));
                if (DamageEffect != None)
                {
                    DamageEffect.DamageType = DamageType;
                    DamageEffect.ComboPower = Power;
                    DamageEffect.OnApplied();
                }
            }
        }
        if (!SFXGRI(Owner.WorldInfo.GRI).IsMultiplayerGame() && Owner.WorldInfo.GameTimeSeconds - LastTimeFlameSpawned > MinTimeBetweenFlameSpawns && HitPawn != None && HitPawn.HasAnyShieldResistance() == FALSE)
        {
            LastTimeFlameSpawned = Owner.WorldInfo.GameTimeSeconds;
            SpawnWeaponImpactVFX(Instigator, Impact, PS_FlameEffect, , , 1.0);
        }
        AddGameEffects(oHitActor);
    }
}
public function AddGameEffects(Actor oTarget)
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = oTarget.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_HealthRegenPenalty', Category))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_HealthRegenPenalty', Category, 0.0, 2, 1.0, Instigator);
        }
        if (!SFXGRI(Owner.WorldInfo.GRI).IsMultiplayerGame())
        {
            if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_FireDeath', Category))
            {
                Manager.CreateAndApplyEffect(Class'SFXGameEffect_FireDeath', Category, DOTDuration, 1, 0.0, Instigator);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DOTDuration = 3.0
    PS_FlameEffect = ParticleSystem'BioVFX_C_Carnage.Particles.Carnage_Dot_Damage_Permanent'
    PS_FireSpreadEffect = ParticleSystem'BioVFX_C_Carnage.Particles.Flame_Burst'
    MinTimeBetweenFlameSpawns = 1.5
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Carnage'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_Incendiary'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_vfx_inc_ammo_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_inc_mzzl'
}