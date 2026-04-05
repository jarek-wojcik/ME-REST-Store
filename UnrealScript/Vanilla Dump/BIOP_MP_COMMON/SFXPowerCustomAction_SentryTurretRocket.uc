Class SFXPowerCustomAction_SentryTurretRocket extends SFXPowerCustomAction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_SentryTurretRocket'
    ProjectileAttachPoint = 'Root'
    ReleaseEffectBoneName = 'Root'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_Incinerate.Play_power_tech_drone_rocket_impact'
    CastSound = WwiseEvent'Wwise_Power_Tech_Incinerate.Play_power_tech_turret_rocket_cast'
    ImpactDistanceLayer = WwiseEvent'Wwise_Generic_Explosions.Play_power_engineer_S_turret_rocket_distant'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    MinimumRange = {BaseValue = 1000.0}
    MaximumRange = {BaseValue = 6000.0}
    PowerName = 'SentryTurretRocket'
    PowerCustomActionID = 56
    Rank = 1.0
    DelayBeforeFirstUse = 1.0
    bEnabled = FALSE
    AimingIgnoresObstructions = TRUE
    UsesSharedCooldown = FALSE
    PowerType = EPowerType.PowerType_Projectile
}