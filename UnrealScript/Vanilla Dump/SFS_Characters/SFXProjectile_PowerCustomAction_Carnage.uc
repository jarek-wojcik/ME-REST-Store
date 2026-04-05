Class SFXProjectile_PowerCustomAction_Carnage extends SFXProjectile_PowerCustomAction_SuperSeeking
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_C_Carnage.Particles.Tracer_Smoke_Trail_Carnage'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_C_Carnage.Particles.Carnage_ProjectileHead'
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}