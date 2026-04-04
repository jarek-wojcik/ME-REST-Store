Class SFXPowerCustomAction_CombatDroneRocket extends SFXPowerCustomAction
    config(Game);

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXAI_Core oAI;
    local SFXPawn oPawn;
    
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        oPawn = SFXPawn(oImpacted);
        if (oPawn != None)
        {
            oAI = SFXAI_Core(oPawn.Controller);
            if (oAI != None)
            {
                oAI.IgnoredTargets.RemoveItem(m_oPawn);
                if (oAI.PreferredTarget == None && !oPawn.bIgnoresPets)
                {
                    oAI.PreferredTarget = m_oPawn;
                }
            }
        }
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultDamageType = None
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_CombatDroneRocket'
    ProjectileAttachPoint = 'Root'
    ReleaseEffectBoneName = 'Root'
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.Tech_Attack_Muzzle_VCFX'
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechRocket_Projectile_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_Rocket_Exp_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_Incinerate.Play_power_tech_drone_rocket_impact'
    CastSound = WwiseEvent'Wwise_Power_Tech_Incinerate.Play_power_tech_drone_rocket_cast'
    ImpactDistanceLayer = WwiseEvent'Wwise_Generic_Explosions.Play_power_engineer_S_turret_rocket_distant'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    MinimumRange = {BaseValue = 400.0}
    MaximumRange = {BaseValue = 4000.0}
    PowerName = 'CombatDroneRocket'
    PowerCustomActionID = 50
    Rank = 1.0
    DelayBeforeFirstUse = 1.0
    bEnabled = FALSE
    AimingIgnoresObstructions = TRUE
    UsesSharedCooldown = FALSE
    PowerType = EPowerType.PowerType_Projectile
}