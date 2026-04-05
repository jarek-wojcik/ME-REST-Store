Class SFXPowerCustomAction_SentryTurretCryoAmmo extends SFXPowerCustomAction_AmmoPower
    config(Game);

var float FreezeChance;

public event function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    local BioPawn oPawn;
    
    if (Super.ShouldUsePower(Target, sOptionalInfo) == FALSE)
    {
        return FALSE;
    }
    if (Target == m_oPawn)
    {
        return TRUE;
    }
    oPawn = BioPawn(Target);
    if (oPawn != None && int(oPawn.GetCurrentResistance()) != 0)
    {
        return FALSE;
    }
    return TRUE;
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_CryoAmmo oEffect;
    local float fDelay;
    local EPowerResistance Resistance;
    
    Super.ClientDoCustomActionImpact(oActor, ImpactCount, bFirstTarget, HitLocation, HitNormal, CustomActionReactionType);
    if (ImpactCount > 0)
    {
        if (oActor == None && m_oPawn.Weapon != None)
        {
            return;
        }
        Manager = m_oPawn.Weapon.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager == None)
        {
            return;
        }
        oEffect = SFXGameEffect_CryoAmmo(Manager.GetFirstEffectOfType(Class'SFXGameEffect_CryoAmmo'));
        if (oEffect != None)
        {
            ReplicationDecodeDelayAndResistance(ImpactCount, fDelay, Resistance);
            oEffect.DoFreezeEffect(BioPawn(oActor), fDelay, HitLocation, HitNormal, TRUE, Resistance);
        }
    }
}
public function SetupEffect(SFXGameEffect_AmmoPower Effect, optional BioPawn oPawn)
{
    local SFXGameEffect_CryoAmmo effectCryoAmmo;
    
    effectCryoAmmo = SFXGameEffect_CryoAmmo(Effect);
    if (effectCryoAmmo != None)
    {
        effectCryoAmmo.FreezeDuration = EffectDuration.CurrentValue;
        effectCryoAmmo.FreezeChance = FreezeChance;
    }
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_CryoAmmo oEffect;
    
    if (oPawn == None || oWeapon == None)
    {
        return;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffect = SFXGameEffect_CryoAmmo(Manager.CreateEffect(Class'SFXGameEffect_CryoAmmo', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
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
    FreezeChance = 1.0
    WeaponPowerEffectClass = Class'SFXGameEffect_CryoAmmo'
    oTracer = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Cryo_Mesh'
    oImpactVFX = ParticleSystem'BioVFX_C_CryoBlaster.Particles.Cry_Modal_Impact'
    oMuzzleVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl1_Cryo'
    oMuzzleLoopVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl_Cryo'
    bModifyTracer = TRUE
    bModifyImpactVFX = TRUE
    bModifyMuzzle = TRUE
    CastAnimSet = None
    PowerName = 'SentryTurretCryoAmmo'
    PowerCustomActionID = 19
    Rank = 1.0
    bEnabled = FALSE
}