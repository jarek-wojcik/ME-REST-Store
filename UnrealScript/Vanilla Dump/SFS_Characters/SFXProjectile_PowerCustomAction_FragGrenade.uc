Class SFXProjectile_PowerCustomAction_FragGrenade extends SFXProjectile_PowerCustomAction_Grenade
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    SpeedThresholdFuseLength = 0.0
    ExplosionSound = WwiseEvent'Wwise_Weapons_Heavy_Missile.Play_weapon_heavy_missile_impact'
    fFuseLength = 3.0
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_C_Grenades.Generic.Particles.FragGrenade_Projectile_Trail'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_C_Grenades.Generic.Particles.FragGrenade_Projectile_Head'
    bBouncing = TRUE
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}