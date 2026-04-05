Class SFXPowerCustomAction_SentryTurretArmorPiercingAmmo extends SFXPowerCustomAction_AmmoPower
    config(Game);

public function SetupEffect(SFXGameEffect_AmmoPower Effect, optional BioPawn oPawn)
{
    local SFXGameEffect_ArmorPiercingAmmo effectArmorPiercingAmmo;
    
    effectArmorPiercingAmmo = SFXGameEffect_ArmorPiercingAmmo(Effect);
    if (effectArmorPiercingAmmo != None)
    {
        effectArmorPiercingAmmo.Damage = Damage.CurrentValue;
        effectArmorPiercingAmmo.DamageType = DefaultDamageType;
    }
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_ArmorPiercingAmmo oEffect;
    
    if (oPawn == None || oWeapon == None)
    {
        return;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffect = SFXGameEffect_ArmorPiercingAmmo(Manager.CreateEffect(Class'SFXGameEffect_ArmorPiercingAmmo', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
    if (oEffect != None)
    {
        SetupEffect(oEffect);
        oEffect.Power = Self;
        oEffect.AddedByPlayer = m_bPlayerOrderedPowerUse;
        oEffect.OnApplied();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponPowerEffectClass = Class'SFXGameEffect_ArmorPiercingAmmo'
    oImpactVFX = ParticleSystem'BioVFX_C_Modal.Particles.Overload_Imp'
    oMuzzleVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl1_Overload'
    oMuzzleLoopVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl_Overload'
    bModifyImpactVFX = TRUE
    bModifyMuzzle = TRUE
    DefaultDamageType = Class'SFXDamageType_ArmorPiercingAmmo'
    CastAnimSet = None
    PowerName = 'SentryTurretArmorPiercingAmmo'
    PowerCustomActionID = 20
    Rank = 1.0
    bEnabled = FALSE
}