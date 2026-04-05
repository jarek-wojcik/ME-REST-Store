Class SFXProjectile_PowerCustomAction_SentryTurretRocket extends SFXProjectile_PowerCustomAction_Seeking
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ExplosionSound = WwiseEvent'Wwise_Weapons_Heavy_Mech.Play_heavymech_missle_impacts'
    fFuseLength = 5.0
    ProjExplosionTemplate = ParticleSystem'BioVFX_Crt_Rockets.Particles.Rocket_Impact'
    ExplosionDecal = DecalMaterial'BioVFX_C_Impacts.Generic.Decals.DECAL_Blast_Generic'
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_Crt_Rockets.Particles.RPG_ProjTrail'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_Crt_Rockets.Particles.RPG_ProjBase'
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}