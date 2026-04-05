Class SFXProjectile_PowerCustomAction_SentryTurret extends SFXProjectile_PowerCustomAction_BouncingGrenade
    config(Game);

public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn_Player Player;
    
    Player = SFXPawn_Player(Instigator);
    if (Player != None && Player.IsHostile(Pawn(Other)))
    {
        return;
    }
    Super(SFXProjectile_PowerCustomAction_Grenade).ProcessTouch(Other, HitLocation, HitNormal);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    SpeedThresholdFuseLength = 0.200000003
    ExplosionSound = WwiseEvent'Wwise_VFX_DLC_Flashbang.Play_weapon_dlc_flashbang_explosion'
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_C_Grenade_FlashBang.Particles.FlashBangGrenade_Projectile_Trail'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_T_TechBall.Particles.SentryTurret_Grenade'
    CoefficientOfRestitution = 0.200000003
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}