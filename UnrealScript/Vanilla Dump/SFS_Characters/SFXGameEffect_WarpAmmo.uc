Class SFXGameEffect_WarpAmmo extends SFXGameEffect_AmmoPower;

var float Damage;
var float LiftedDamageBonus;
var float ArmorWeakness;
var float ArmorWeaknessDuration;
var(SFXGameEffect_WarpAmmo) ParticleSystem ImpactEffect;
var float SpareAmmoBonus;
var float HeadShotDamageBonus;

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
}
public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    local Actor oHitActor;
    local float fDamage;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    local bool bBioticCombo;
    
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
    Manager = oHitActor.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    foreach Manager.GameEffects(oEffect, )
    {
        if (oEffect.Class.Name == 'SFXGameEffect_PowerCombo_Biotic')
        {
            bBioticCombo = TRUE;
            break;
        }
    }
    if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ArmorWeakness', Category))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_ArmorWeakness', Category, ArmorWeaknessDuration, 1, -ArmorWeakness, Instigator);
    }
    if (bBioticCombo)
    {
        fDamage = GetWeaponDamage(Weapon, Impact) * Damage * (1.0 + LiftedDamageBonus);
    }
    else
    {
        fDamage = GetWeaponDamage(Weapon, Impact) * Damage;
    }
    oHitActor.TakeDamage(fDamage, OwnerPawn.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), Class'SFXDamageType_WarpAmmo');
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Warp'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_Warp'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_warp_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_warp_mzzl'
}