Class SFXProjectile_PowerCustomAction_BatarianNet_Shared extends SFXProjectile_PowerCustomAction_SuperSeeking
    config(Game);

var Guid TrapGuid;
var config float TrapDuration;
var config float ProximityRadius;
var float ProximityCheckFrequency;
var RvrClientEffectInterface CE_TrapEffect;
var float TrapSurfaceOffset;

public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    ClearTimer('ProximityCheck');
    ClearTimer('TrapDurationDone');
    if (TrapGuid.A != 0 || TrapGuid.B != 0 || TrapGuid.C != 0 || TrapGuid.D != 0)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_TrapEffect, TrapGuid, TRUE);
    }
    Super(SFXProjectile_PowerCustomAction).Explode(HitLocation, HitNormal);
}
public simulated function Init(Vector Direction)
{
    Super(SFXProjectile_PowerCustomAction).Init(Direction);
    if (Role == ENetRole.ROLE_Authority)
    {
        LifeSpan = TrapDuration + 5.0;
    }
}
public event simulated function Timer();

public simulated function bool Stick(Actor Other, Vector HitLocation, Vector HitNormal, int BoneIdx, optional int Reaction)
{
    local RvrClientEffectTarget EffectTarget;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        SetTimer(ProximityCheckFrequency, TRUE, 'ProximityCheck', );
        SetTimer(TrapDuration, FALSE, 'TrapDurationDone', );
    }
    if (ProjEffectsHead != None)
    {
        ProjEffectsHead.SetActive(FALSE);
    }
    if (ProjEffectsTrail != None)
    {
        ProjEffectsTrail.SetActive(FALSE);
    }
    EffectTarget.HitNormal = HitNormal;
    EffectTarget.HitLocation = location + HitNormal * TrapSurfaceOffset;
    EffectTarget.Instigator = Self;
    TrapGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_TrapEffect, EffectTarget);
    return Super(SFXProjectile_Explosive).Stick(Other, HitLocation, HitNormal, BoneIdx, Reaction);
}
public function Tick_Prediction(float DeltaTime)
{
    local SFXProjectile_PowerCustomAction_Seeking oTargetProjectile;
    
    oTargetProjectile = SFXProjectile_PowerCustomAction_Seeking(TargetProjectile);
    if (bGotAPredictionTarget && oTargetProjectile != None)
    {
        TargetActor = oTargetProjectile.TargetActor;
        if (oTargetProjectile.bStuck && !bStuck)
        {
            if (ProjEffectsHead != None)
            {
                ProjEffectsHead.SetActive(FALSE);
            }
            if (ProjEffectsTrail != None)
            {
                ProjEffectsTrail.SetActive(FALSE);
            }
        }
    }
    Super(SFXProjectile_PowerCustomAction_Seeking).Tick_Prediction(DeltaTime);
}
public function ProximityCheck()
{
    local BioPawn NearbyPawn;
    
    foreach WorldInfo.AllPawns(Class'BioPawn', NearbyPawn, location, ProximityRadius)
    {
        if (!NearbyPawn.IsDead() && NearbyPawn.GetTeam().TeamIndex == 1)
        {
            TouchedActor = NearbyPawn;
            Explode(location, vect(0.0, 0.0, 1.0));
            ShutDown();
            break;
        }
    }
}
public function TrapDurationDone()
{
    Explode(location, vect(0.0, 0.0, 1.0));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    TrapDuration = 20.0
    ProximityRadius = 150.0
    ProximityCheckFrequency = 0.5
    CE_TrapEffect = RvrClientEffect'BioVFX_DLC_MP1_Bat.VCFX.Web_Trap'
    TrapSurfaceOffset = 15.0
    StickEnvironmentImpactSound = WwiseEvent'Wwise_Power_DLC_StasisNet.Play_power_DLC_P_stasisnet_impact'
    NPStickEnvironmentImpactSound = WwiseEvent'Wwise_Power_DLC_StasisNet.Play_power_DLC_NP_stasisnet_impact'
    bStickWalls = TRUE
    ProjEffectsTrailTemplate = ParticleSystem'BioVFX_DLC_MP1_Bat.Particles.Net_Projectile_Trail'
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_DLC_MP1_Bat.Particles.Net_Projectile_Head'
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}