Class SFXProjectile_PowerCustomAction_ProximityMine extends SFXProjectile_PowerCustomAction
    config(Game);

var Guid ImpactGUID;
var Vector MineHitNormal;
var float UpdateFrequency;
var float LastUpdateTime;
var float StartTime;
var clearcrosslevel SFXPowerCustomAction_ProximityMine MinePower;
var float TriggerRadius;
var RvrClientEffectInterface CE_MineDeployedTemplate;
var WwiseEvent AttachToWallSound;
var WwiseEvent HenchAttachToWallSound;
var transient bool bIsMineDeployed;
var transient bool bIsMineTriggered;

public event simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if (bIsMineDeployed)
    {
        return;
    }
    SetLocation(location + HitNormal * float(1), );
    MineHitNormal = HitNormal;
    Speed = 0.0;
    Velocity = vect(0.0, 0.0, 0.0);
    PlayMineImpact(HitNormal);
}
public simulated function Init(Vector Direction)
{
    local SFXPawn_Player PlayerPawn;
    local Controller PlayerController;
    local int MineCap;
    
    MinePower = SFXPowerCustomAction_ProximityMine(Power);
    if (MinePower == None)
    {
        return;
    }
    if (MinePower.m_oPawn != None && MinePower.m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (SFXPawn_Player(MinePower.m_oPawn) != None)
        {
            MineCap = MinePower.MaxActiveMines;
        }
        else
        {
            MineCap = MinePower.MaxActiveMines + 1;
        }
        if (MinePower.Projectiles.Length >= MineCap)
        {
            MinePower.Projectiles[0].Explode(MinePower.Projectiles[0].location, Normal(Vector(MinePower.Projectiles[0].Rotation)));
        }
    }
    PlayerPawn = SFXPawn_Player(MinePower.m_oPawn);
    if (PlayerPawn != None)
    {
        PlayerController = PlayerPawn.Controller;
        if (PlayerController != None)
        {
            Direction = Vector(PlayerController.Rotation);
        }
    }
    Super.Init(Direction);
    LifeSpan = MinePower.EffectDuration.CurrentValue + 5.0;
    Speed = MaxSpeed;
    Velocity = Normal(Velocity) * MaxSpeed;
    LastUpdateTime = WorldInfo.GameTimeSeconds;
    StartTime = WorldInfo.GameTimeSeconds;
    bIsMineTriggered = FALSE;
    bIsMineDeployed = FALSE;
}
public simulated function Recycle()
{
    Super.Recycle();
    MinePower = default.MinePower;
    ImpactGUID = default.ImpactGUID;
}
public simulated function ShutDown()
{
    if (bShuttingDown)
    {
        return;
    }
    if (ImpactGUID.A != 0 && ImpactGUID.B != 0 && ImpactGUID.C != 0 && ImpactGUID.D != 0)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_MineDeployedTemplate, ImpactGUID, TRUE);
    }
    if (MinePower != None && MinePower.Projectiles.Find(Self) >= 0)
    {
        MinePower.Projectiles.RemoveItem(Self);
    }
    Super.ShutDown();
}
public event simulated function Tick(float DeltaTime)
{
    local Pawn CurrentPawn;
    
    Super.Tick(DeltaTime);
    if (!bIsMineDeployed || bIsMineTriggered || bClientPredictionActive)
    {
        return;
    }
    if (MinePower == None)
    {
        if (!IsShuttingDown())
        {
            ShutDown();
        }
        return;
    }
    if (MinePower.m_oPawn != None && MinePower.m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (WorldInfo.GameTimeSeconds - LastUpdateTime >= UpdateFrequency)
        {
            LastUpdateTime = WorldInfo.GameTimeSeconds;
            foreach WorldInfo.CollidingActors(Class'Pawn', CurrentPawn, MinePower.ImpactRadius.CurrentValue * TriggerRadius, location, , , )
            {
                if (CurrentPawn.GetTeam().TeamIndex == 0)
                {
                    continue;
                }
                bIsMineTriggered = TRUE;
                Explode(location, MineHitNormal);
                ShutDown();
                break;
            }
        }
        else if (WorldInfo.GameTimeSeconds - StartTime >= MinePower.EffectDuration.CurrentValue)
        {
            Explode(location, MineHitNormal);
            ShutDown();
        }
    }
}
public event simulated function Timer();

public simulated function float GetDamage()
{
    if (MinePower != None)
    {
        return MinePower.Damage.CurrentValue;
    }
    return 0.0;
}
public simulated function ReplicatedInitUpdated()
{
    Super.ReplicatedInitUpdated();
    if (ReplicatedPowerProjInitInfo.TravelSpeed == 0.0 && !bIsMineDeployed)
    {
        HitWall(ReplicatedPowerProjInitInfo.Direction * 0.00100000005, None, None);
    }
}
public function Tick_Prediction(float DeltaTime)
{
    local SFXProjectile_PowerCustomAction_ProximityMine oTargetProjectile;
    
    oTargetProjectile = SFXProjectile_PowerCustomAction_ProximityMine(TargetProjectile);
    if (bGotAPredictionTarget && oTargetProjectile != None && oTargetProjectile.bIsMineDeployed)
    {
        ShutDown();
        return;
    }
    Super(SFXProjectile_Explosive).Tick_Prediction(DeltaTime);
}
public simulated function PlayMineImpact(Vector HitNormal)
{
    local RvrClientEffectTarget EffectTarget;
    
    bIsMineDeployed = TRUE;
    EffectTarget.HitNormal = HitNormal;
    EffectTarget.HitLocation = location;
    EffectTarget.Instigator = MinePower.m_oPawn;
    ImpactGUID = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_MineDeployedTemplate, EffectTarget, Self);
    if (ProjEffectsHead != None)
    {
        ProjEffectsHead.SetActive(FALSE);
    }
    if (SFXPawn_Player(Caster) != None)
    {
        PlaySound(AttachToWallSound);
    }
    else
    {
        PlaySound(HenchAttachToWallSound);
    }
}
public function ReplicateMineDeployed()
{
    ReplicatedPowerProjInitInfo.Trigger++;
    InitEventEndReplicationTime = WorldInfo.TimeSeconds + 3.0;
    bForceNetUpdate = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    UpdateFrequency = 0.5
    TriggerRadius = 0.75
    CE_MineDeployedTemplate = RvrClientEffect'BioVFX_C_NapalmGrenade.VCFX.ProximityMine_Imp_VCFX'
    AttachToWallSound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_P_proxmine_latch'
    HenchAttachToWallSound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_NP_proxmine_latch'
    CE_ExplosionTemplate = RvrClientEffect'BioVFX_C_NapalmGrenade.VCFX.ProximityMine_Explosion_VCFX'
    ExplosionParticleLifetime = 5.0
    ProjEffectsHeadTemplate = ParticleSystem'BioVFX_C_NapalmGrenade.Particles.ProximityMine_Projectile'
    PredictionInitialSpeedGain = 0.200000003
    PredictionAccelerationRate = 1.00100005
    bClientPredictProjectile = TRUE
    MaxSpeed = 6000.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}