Class SFXProjectile_Graal extends SFXProjectile_Explosive
    config(Weapon);

var Name AttachBoneName;
var const ParticleSystem GraalImpactTemplate;
var const ParticleSystem GraalBloodyImpactTemplate;
var bool UseRelativeOffset;

public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if (IsShuttingDown() || bClientPredictionActive)
    {
        return;
    }
    Super.Explode(HitLocation, HitNormal);
    ShutDown();
}
public simulated function Tick(float DeltaTime)
{
    local SFXPawn StuckPawn;
    
    Super(SFXProjectile).Tick(DeltaTime);
    StuckPawn = SFXPawn(StuckTo);
    if (!IsShuttingDown() && StuckPawn != None && (StuckPawn.bHidden || StuckPawn.bCorpseDestroyed))
    {
        ShutDown();
    }
}
public simulated function Timer();

public simulated function DoStickImpact(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo HitInfo)
{
    Other.TakeDamage(GetDamage(), Instigator.Controller, HitLocation, MomentumTransfer * Normal(Velocity), GetDamageType(), HitInfo, Self);
}
public function EReactionTypes GetStickReaction()
{
    return 1;
}
public simulated function bool Stick(Actor Other, Vector HitLocation, Vector HitNormal, int BoneIdx, optional int Reaction)
{
    local bool StuckToPawn;
    local BioPawn oPawn;
    local Name BoneName;
    local Rotator BoneRot;
    
    StuckToPawn = Super.Stick(Other, HitLocation, HitNormal, BoneIdx, Reaction);
    if (StuckToPawn)
    {
        oPawn = BioPawn(Other);
        BoneName = oPawn.Mesh.GetBoneName(BoneIdx);
        BoneRot = QuatToRotator(oPawn.Mesh.GetBoneQuaternion(BoneName));
        if (oPawn.RaceType != ERaceType.RaceType_Machine)
        {
            SFXGRI(WorldInfo.GRI).DuringAsyncWorker.SpawnEffectAtLocation(Instigator, GraalBloodyImpactTemplate, HitLocation, BoneRot);
        }
    }
    else
    {
        SFXGRI(WorldInfo.GRI).DuringAsyncWorker.SpawnEffectAtLocation(Instigator, GraalImpactTemplate, HitLocation, Rotation);
    }
    return StuckToPawn;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    AttachBoneName = 'Root'
    GraalImpactTemplate = ParticleSystem'BioVFX_C_Wpn_KShotGun.Particles.Krogan_ShotGun_Imp'
    GraalBloodyImpactTemplate = ParticleSystem'BioVFX_C_Impacts.Blood.Particles.Blood_Red_CriticalHit_Misty_nSound'
    StickPawnImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_pl_graal_knives_flesh'
    NPStickPawnImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_graal_knives_flesh'
    StickShieldImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_pl_graal_knives_shields'
    NPStickShieldImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_graal_knives_shields'
    StickEnvironmentImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_pl_graal_knives'
    NPStickEnvironmentImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_graal_knives'
    fFuseLength = 5.0
    bStickPawns = TRUE
    bStickWalls = TRUE
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_C_Wpn_KShotGun.Particles.Krogan_ShotGun_Proj_trail'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_C_Wpn_KShotGun.Particles.Krogan_ShotGun_Proj_head'
    bClientPredictProjectile = TRUE
    MyDamageType = Class'SFXDamageType_HeavyShotgun'
    Speed = 7500.0
    MaxSpeed = 10000.0
    MomentumTransfer = 50.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}