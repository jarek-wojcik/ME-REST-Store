Class SFXGameEffect_ArmorPiercingAmmo extends SFXGameEffect_AmmoPower;

var Class<SFXDamageType> DamageType;
var float Damage;
var float VFXSpawnChance;
var float Penetration;
var float PenetrationDamage;
var float ArmorReduction;
var float SpareAmmoBonus;
var float HeadShotDamageBonus;
var(SFXGameEffect_ArmorPiercingAmmo) ParticleSystem PS_OrganicImpactEffect;
var(SFXGameEffect_ArmorPiercingAmmo) ParticleSystem PS_NonOrganicImpactEffect;

public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnRemoved();
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
    if (Penetration > float(0))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_PenetrationBonus', Category);
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_PenetrationDamageBonus', Category);
    }
    if (ArmorReduction > float(0))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_ArmorPiercingBonus', Category);
    }
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(SFXGameEffect).PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheImpactParticleSystemComponent(default.PS_OrganicImpactEffect);
    ObjectPool.PrecacheImpactParticleSystemComponent(default.PS_NonOrganicImpactEffect);
}
public function OnApplied()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnApplied();
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
    if (Penetration > float(0))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_PenetrationBonus', Category, 0.0, 2, Penetration, Instigator);
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_PenetrationDamageBonus', Category, 0.0, 2, PenetrationDamage, Instigator);
    }
    if (ArmorReduction > float(0))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_ArmorPiercingBonus', Category, 0.0, 2, ArmorReduction, Instigator);
    }
}
public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    local BioPawn oPawn;
    local float fExtraDamage;
    local Actor oHitActor;
    
    Super.OnWeaponImpact(Weapon, Impact);
    oHitActor = GetHitTarget(Impact);
    if (Weapon == None || oHitActor == None || Power == None)
    {
        return;
    }
    if (BioPawn(oHitActor) != None && Power.m_oPawn.IsFriendly(BioPawn(oHitActor)))
    {
        return;
    }
    fExtraDamage = GetWeaponDamage(Weapon, Impact) * Damage;
    oHitActor.TakeDamage(fExtraDamage, OwnerPawn.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), DamageType);
    oPawn = BioPawn(oHitActor);
    if (oPawn == None || int(oPawn.GetCurrentResistance()) != 0)
    {
        if (FRand() < VFXSpawnChance / BulletsPerSecond)
        {
            if (Class'SFXPowerCustomAction'.static.IsMachineRace(Impact.HitActor))
            {
                SpawnWeaponImpactVFX(Instigator, Impact, PS_NonOrganicImpactEffect);
            }
            else
            {
                SpawnWeaponImpactVFX(Instigator, Impact, PS_OrganicImpactEffect, FALSE);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VFXSpawnChance = 0.5
    PS_OrganicImpactEffect = ParticleSystem'BioVFX_C_Impacts.Blood.Particles.Blood_Red_Psys_MassiveDamage'
    PS_NonOrganicImpactEffect = ParticleSystem'BioVFX_C_Impacts.Metal.Particles.Blue_Metal_Robot_MassiveDamage'
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_ArmorPiercing'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_ArmorPiercing'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_ap_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_ap_mzzl'
}