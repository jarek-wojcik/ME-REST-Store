Class SFXProjectile_GethShotgun extends SFXProjectile_Explosive
    config(Weapon);

struct ReplicatedInit_GethShotgun 
{
    var Vector Direction;
    var Vector location;
    var float Speed;
    var Pawn Instigator;
    var float ChargeAmount;
    var Pawn AcquiredTarget;
    var byte Trigger;
};

var transient repnotify ReplicatedInit_GethShotgun ReplicatedInitInfo_GethShotgun;
var Vector EmitterParameter;
var transient BioPawn AcquiredTarget;
var const float MaxAngleChange;
var float ChargeAmount;
var float DamageMultiplier;
var WwiseEvent ReleaseHighSound;
var WwiseEvent ReleaseMedSound;
var WwiseEvent ReleaseLowSound;
var WwiseEvent ImpactHighSound;
var WwiseEvent ImpactMedSound;
var WwiseEvent ImpactLowSound;
var float HitOnceDuration;

public simulated function Vector GetAimLocation()
{
    local Vector NodeLocation;
    
    if (AcquiredTarget != None && AcquiredTarget.GetAimNodeLocation(4, NodeLocation))
    {
        return NodeLocation;
    }
    return AcquiredTarget.location;
}
public event function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local TraceHitInfo HitInfo;
    local SFXWeapon_Shotgun_Geth oWeapon;
    
    oWeapon = SFXWeapon_Shotgun_Geth(ProjectileOwner);
    if (BioPhysicsActor(Wall) != None)
    {
        BioPhysicsActor(Wall).TakeDamage(GetProjectileDamage(0), Instigator.Controller, location, HitNormal * -GetMomentum(), oWeapon.GetDamageType(), HitInfo);
    }
    Super.HitWall(HitNormal, Wall, WallComp);
}
public simulated function Init(Vector Direction)
{
    if (!bClientPredictionTarget)
    {
        EmitterParameter.X = ChargeAmount;
        EmitterParameter.Y = ChargeAmount;
        EmitterParameter.Z = ChargeAmount;
        if (ProjEffectsHead != None)
        {
            ProjEffectsHead.SetVectorParameter('Intensity', EmitterParameter);
        }
        if (ProjEffectsTrail != None)
        {
            ProjEffectsTrail.SetVectorParameter('Intensity', EmitterParameter);
        }
        if (!bSuppressAudio)
        {
            if (ChargeAmount >= 1.0)
            {
                PlaySound(ReleaseHighSound);
            }
            else if (ChargeAmount >= 0.5)
            {
                PlaySound(ReleaseMedSound);
            }
            else
            {
                PlaySound(ReleaseLowSound);
            }
        }
    }
    AcquireInitialTarget();
    Super.Init(Direction);
}
public simulated function Recycle()
{
    Super.Recycle();
    AcquiredTarget = default.AcquiredTarget;
    ChargeAmount = default.ChargeAmount;
    DamageMultiplier = default.DamageMultiplier;
    bSuppressAudio = default.bSuppressAudio;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedInitInfo_GethShotgun')
    {
        if (int(LastReplicatedInitInfoTrigger) != int(ReplicatedInitInfo_GethShotgun.Trigger))
        {
            ReplicatedInitUpdated();
            LastReplicatedInitInfoTrigger = ReplicatedInitInfo_GethShotgun.Trigger;
        }
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public simulated function Tick(float DeltaTime)
{
    local Vector DesiredOrientation;
    local Vector CurrentOrientation;
    local float fAngle;
    local float fTargetVelocity;
    local float fAngleChange;
    
    Super(SFXProjectile).Tick(DeltaTime);
    if (!bStopAiming)
    {
        if (AcquiredTarget != None)
        {
            DesiredOrientation = Normal(GetAimLocation() - location);
            CurrentOrientation = Normal(Vector(Rotation));
            fAngle = GetAngleBetween(DesiredOrientation, CurrentOrientation);
            if (fAngle > float(0))
            {
                if (fAngle > MaxAngleChange)
                {
                    fTargetVelocity = VSize(AcquiredTarget.Velocity);
                    fAngleChange = MaxAngleChange * (1.0 + fTargetVelocity / 350.0) * (DeltaTime * 60.0);
                    CurrentOrientation = VLerp(CurrentOrientation, DesiredOrientation, fAngleChange / fAngle);
                    SetRotation(Rotator(CurrentOrientation));
                }
                else
                {
                    SetRotation(Rotator(DesiredOrientation));
                }
                Velocity = Normal(Vector(Rotation)) * Speed;
            }
        }
    }
}
public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local ImpactInfo Info;
    local SFXWeapon_Shotgun_Geth oWeapon;
    
    oWeapon = SFXWeapon_Shotgun_Geth(ProjectileOwner);
    if (Pawn(Other) != None && Instigator.IsFriendly(Pawn(Other)))
    {
        return;
    }
    if (Pawn(Other) == None && StaticMeshActor(Other) == None && BioPhysicsActor(Other) == None && DynamicSMActor(Other) == None)
    {
        return;
    }
    if (StaticMeshActor(Other) != None || BioPhysicsActor(Other) != None || DynamicSMActor(Other) != None)
    {
        if (VSizeSq(location - Owner.location) < 40000.0)
        {
            return;
        }
    }
    if (GetTimesHit(Other) == 0)
    {
        if (oWeapon != None)
        {
            Info.HitActor = Other;
            Info.HitLocation = HitLocation;
            Info.HitNormal = HitNormal;
            Info.RayDir = -HitNormal;
            if (Pawn(Other) != None)
            {
                Info.HitInfo.BoneName = Pawn(Other).Mesh.FindClosestBone(HitLocation);
            }
            oWeapon.__OnWeaponImpact__Delegate(oWeapon, Info);
        }
    }
    if (IsShuttingDown() == FALSE)
    {
        Explode(HitLocation, HitNormal);
        ShutDown();
    }
}
public function DoImpact(Actor InImpactedActor, Controller InInstigatorController, float BaseDamage, float InDamageRadius, float Momentum, Vector HurtOrigin, bool bFullDamage, out TraceHitInfo HitInfo)
{
    local SFXWeapon_Shotgun_Geth oWeapon;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    local int TimesHit;
    
    oWeapon = SFXWeapon_Shotgun_Geth(ProjectileOwner);
    Manager = InImpactedActor.GetModule(Class'SFXModule_GameEffectManager');
    TimesHit = GetTimesHit(InImpactedActor);
    if (TimesHit > 0 && Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Class == Class'SFXGameEffect_CustomFlag' && Effect.Category == ProjectileOwner.Name)
            {
                Effect.EffectValue += 1.0;
            }
        }
    }
    if (TimesHit == 0)
    {
        if (Manager != None)
        {
            Effect = Manager.CreateEffect(Class'SFXGameEffect_CustomFlag', ProjectileOwner.Name, HitOnceDuration, 1, 1.0, InInstigatorController);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
        }
        oWeapon.OnProjectileImpact(InImpactedActor, location, ChargeAmount);
    }
    Super.DoImpact(InImpactedActor, InInstigatorController, GetProjectileDamage(TimesHit), InDamageRadius, Momentum, HurtOrigin, bFullDamage, HitInfo);
}
public simulated function ReplicatedInitUpdated()
{
    if (bPooled)
    {
        if (bActive)
        {
            Reset();
        }
        Class'SFXObjectPool'.static.ResetActorParticleSystemComponents(Self);
        Reuse();
    }
    Instigator = ReplicatedInitInfo_GethShotgun.Instigator;
    if (Instigator != None && Instigator.Role == ENetRole.ROLE_AutonomousProxy && SFXWeapon(Instigator.Weapon) != None)
    {
        SFXWeapon(Instigator.Weapon).OnClientProjectileSpawned(Self);
    }
    SetLocation(ReplicatedInitInfo_GethShotgun.location, );
    Speed = ReplicatedInitInfo_GethShotgun.Speed;
    Init(ReplicatedInitInfo_GethShotgun.Direction * 0.00100000005);
    if (LatestExplodeTime > 0.0 && Abs(WorldInfo.TimeSeconds - LatestExplodeTime) < ExplodeTimeOut)
    {
        Explode(ReplicatedExplosionInfo.HitLocation, ReplicatedExplosionInfo.HitNormal);
    }
    ChargeAmount = ReplicatedInitInfo_GethShotgun.ChargeAmount;
    AcquiredTarget = BioPawn(ReplicatedInitInfo_GethShotgun.AcquiredTarget);
}
public function ReplicateInit(Vector Direction)
{
    ReplicatedInitInfo_GethShotgun.Trigger++;
    ReplicatedInitInfo_GethShotgun.location = location;
    ReplicatedInitInfo_GethShotgun.Direction = Direction * 1000.0;
    ReplicatedInitInfo_GethShotgun.Speed = Speed;
    ReplicatedInitInfo_GethShotgun.Instigator = Instigator;
    ReplicatedInitInfo_GethShotgun.AcquiredTarget = AcquiredTarget;
    ReplicatedInitInfo_GethShotgun.ChargeAmount = ChargeAmount;
    bForceNetUpdate = TRUE;
    NetInitTime = WorldInfo.TimeSeconds;
    InitEventEndReplicationTime = WorldInfo.TimeSeconds + 3.0;
}
public simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    local Rotator EffectRotation;
    local SFXEmitter ProjExplosionEmitter;
    local MaterialInstanceTimeVarying MITV_Decal;
    local Vector ListenerPosition;
    
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer)
    {
        if (ProjExplosionTemplate != None && EffectIsRelevant(HitLocation, FALSE, MaxEffectDistance))
        {
            EffectRotation = Rotator(HitNormal) + rot(-16384, 0, 0);
            ProjExplosionEmitter = SFXGRI(WorldInfo.GRI).ObjectPool.GetImpactEmitter(ProjExplosionTemplate, HitLocation, EffectRotation);
            if (ProjExplosionEmitter != None)
            {
                ProjExplosionEmitter.SetVectorParameter('Intensity', EmitterParameter);
                ProjExplosionEmitter.SetLifetime(ExplosionParticleLifetime);
                ProjExplosionEmitter.ParticleSystemComponent.SetActive(TRUE);
            }
            if (ExplosionDecal != None && Pawn(ImpactedActor) == None)
            {
                if (MaterialInstanceTimeVarying(ExplosionDecal) != None)
                {
                    MITV_Decal = new Class'MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(ExplosionDecal);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, Rotator(-HitNormal), DecalWidth, DecalHeight, 10.0, FALSE);
                    MITV_Decal.SetScalarStartTime(DecalDissolveParamName, DurationOfDecal);
                }
                else
                {
                    WorldInfo.MyDecalManager.SpawnDecal(ExplosionDecal, HitLocation, Rotator(-HitNormal), DecalWidth, DecalHeight, 10.0, TRUE);
                }
            }
        }
        if (!bSuppressAudio)
        {
            if (ChargeAmount >= 1.0)
            {
                PlaySound(ImpactHighSound);
            }
            else if (ChargeAmount >= 0.5)
            {
                PlaySound(ImpactMedSound);
            }
            else
            {
                PlaySound(ImpactLowSound);
            }
        }
        if (bDuckAudio)
        {
            ListenerPosition = Class'WwiseAudioComponent'.static.GetMicPosition();
            if (VSize(ListenerPosition - HitLocation) < DuckDistanceThreshold)
            {
                PlaySound(WwiseDuckEvent);
            }
        }
        bSuppressExplosionFX = TRUE;
    }
}
public function Tick_Prediction(float DeltaTime)
{
    local SFXProjectile_GethShotgun oTargetProjectile;
    
    Super.Tick_Prediction(DeltaTime);
    oTargetProjectile = SFXProjectile_GethShotgun(TargetProjectile);
    if (bGotAPredictionTarget && oTargetProjectile != None)
    {
        AcquiredTarget = oTargetProjectile.AcquiredTarget;
    }
}
public function AcquireInitialTarget()
{
    local SFXWeapon FromWeapon;
    
    FromWeapon = SFXWeapon(Instigator.Weapon);
    if (FromWeapon != None && FromWeapon.StartFireTarget != None)
    {
        AcquiredTarget = BioPawn(FromWeapon.StartFireTarget);
    }
}
public simulated function float GetProjectileDamage(int TimesHit)
{
    local float fDamage;
    local SFXWeapon_Shotgun_Geth oWeapon;
    
    oWeapon = SFXWeapon_Shotgun_Geth(ProjectileOwner);
    fDamage = GetDamage() * DamageMultiplier;
    switch (TimesHit)
    {
        case 0:
            return fDamage * oWeapon.FirstHitDamage;
        case 1:
            return fDamage * oWeapon.SecondHitDamage;
        default:
    }
    return fDamage * oWeapon.ThirdHitDamage;
}
private final simulated function int GetTimesHit(Actor Other)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    Manager = Other.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Class == Class'SFXGameEffect_CustomFlag' && Effect.Category == ProjectileOwner.Name)
            {
                return int(Effect.EffectValue);
            }
        }
    }
    return 0;
}

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < InitEventEndReplicationTime)
        ReplicatedInitInfo_GethShotgun;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    MaxAngleChange = 0.00150000001
    ReleaseHighSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_proj_high'
    ReleaseMedSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_proj_med'
    ReleaseLowSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_proj_low'
    ImpactHighSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_impact_high'
    ImpactMedSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_impact_med'
    ImpactLowSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_impact_low'
    HitOnceDuration = 0.300000012
    fFuseLength = 3.0
    ProjExplosionTemplate = ParticleSystem'BioVFX_C_Wpn_Gsg.Particles.Geth_Shotgun_Imp'
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_C_Wpn_Gsg.Particles.Tracer_Smoke_Trail_GSG'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_C_Wpn_Gsg.Particles.Geth_Shotgun_ProjectileHead'
    bClientPredictProjectile = TRUE
    MyDamageType = Class'SFXDamageType_GethShotgun'
    MomentumTransfer = 40.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}