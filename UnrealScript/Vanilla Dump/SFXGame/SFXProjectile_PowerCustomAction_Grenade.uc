Class SFXProjectile_PowerCustomAction_Grenade extends SFXProjectile_PowerCustomAction
    config(Game);

var float ProjectileSpeedMin;
var float ProjectileSpeedMax;
var float RotationsPerSecond;
var transient float SpeedThresholdFuseLength;
var(Sounds) WwiseEventPairObject FuseSound;
var(Sounds) WwiseEvent GrenadeWarningStartSound;
var(Sounds) WwiseEvent GrenadeWarningStopSound;
var export bool bExploded;
var transient bool bSpeedThresholdFuseSet;

public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local SFXModule_Marker oMarker;
    
    if (!bArmed || IsShuttingDown() || bClientPredictionActive)
    {
        return;
    }
    oMarker = GetModule(Class'SFXModule_Marker');
    if (oMarker != None)
    {
        oMarker.Deactivate();
    }
    Super.Explode(HitLocation, HitNormal);
}
public event function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if (bBouncing)
    {
        Bounce(Wall, location, HitNormal);
    }
    else
    {
        Super.HitWall(HitNormal, Wall, WallComp);
    }
}
public simulated function Recycle()
{
    Super.Recycle();
    bReplicateMovement = default.bReplicateMovement;
    bUpdateSimulatedPosition = default.bUpdateSimulatedPosition;
}
public simulated function Tick(float DeltaTime)
{
    local Rotator NewRotator;
    
    Super.Tick(DeltaTime);
    if (bSpeedThresholdFuseSet)
    {
        SpeedThresholdFuseLength -= DeltaTime;
        if (SpeedThresholdFuseLength < float(0))
        {
            if (IsShuttingDown() == FALSE)
            {
                Explode(location, vect(0.0, 0.0, 1.0));
                ShutDown();
            }
        }
    }
    if (!bStopAiming)
    {
        if (ProjEffectsHead != None)
        {
            NewRotator = ProjEffectsHead.Rotation;
            NewRotator.Pitch += int(65000.0 * DeltaTime * RotationsPerSecond * FClamp(VSize(Velocity) / 2000.0, 0.0, 1.0));
            ProjEffectsHead.SetRotation(NewRotator);
        }
    }
}
public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn_Player Player;
    
    Player = SFXPawn_Player(Instigator);
    if (Player != None && Player.IsHostile(Pawn(Other)))
    {
        Explode(location, HitNormal);
        if (IsShuttingDown() == FALSE)
        {
            ShutDown();
        }
        return;
    }
    if (bBouncing)
    {
        if (Caster != None && Other == Caster)
        {
            return;
        }
        if (SFXPawn_Player(Instigator) != None && SFXPawn_Player(Instigator).IsFriendly(Pawn(Other)))
        {
            return;
        }
        if (Pawn(Other) == None && StaticMeshActor(Other) == None && BioPhysicsActor(Other) == None && DynamicSMActor(Other) == None)
        {
            return;
        }
        if (StaticMeshActor(Other) != None || BioPhysicsActor(Other) != None || DynamicSMActor(Other) != None)
        {
            if (VSizeSq(location - Owner.location) < float(40000))
            {
                return;
            }
        }
        Bounce(Other, HitLocation, HitNormal);
    }
    else
    {
        Super.ProcessTouch(Other, HitLocation, HitNormal);
    }
}
public simulated function Bounce(Actor HitActor, Vector HitLocation, Vector HitNormal)
{
    bReplicateMovement = TRUE;
    bUpdateSimulatedPosition = TRUE;
    SetLocation(location + HitNormal * float(1), );
    if (HitNormal Dot Normal(Velocity) > float(0))
    {
        return;
    }
    bBlockedByInstigator = TRUE;
    ImpactedActor = HitActor;
    Velocity = CoefficientOfRestitution * (Velocity Dot HitNormal * HitNormal * -2.0 + Velocity);
    Speed = VSize(Velocity);
    if (Velocity.Z > float(400))
    {
        Velocity.Z = 0.5 * (float(400) + Velocity.Z);
    }
    if (ExplodeSpeedThreshold > float(0))
    {
        if (Speed < ExplodeSpeedThreshold)
        {
            if (SpeedThresholdFuseLength > float(0))
            {
                if (!bSpeedThresholdFuseSet)
                {
                    bSpeedThresholdFuseSet = TRUE;
                    if (FuseSound != None)
                    {
                        PlaySound(FuseSound);
                    }
                }
            }
            else
            {
                Explode(location, HitNormal);
                if (IsShuttingDown() == FALSE)
                {
                    ShutDown();
                }
            }
        }
        else if (BounceSound != None)
        {
            PlaySound(BounceSound);
        }
    }
    else if (BounceSound != None)
    {
        PlaySound(BounceSound);
    }
}
public function FuseDone()
{
    if (IsShuttingDown() == FALSE)
    {
        Explode(location, vect(0.0, 0.0, 1.0));
        if (FuseSound != None)
        {
            StopSound(FuseSound);
        }
        if (GrenadeWarningStartSound != None)
        {
            StopSound(GrenadeWarningStopSound);
        }
        ShutDown();
    }
}
public simulated function bool InitializePowerProjectile(Actor oCaster, float fTravelSpeed, float fRadius, SFXPowerCustomAction oPower)
{
    local BioPlayerController PC;
    local SFXAI_Core AI;
    local BioPawn oCasterPawn;
    local float fMaxRange;
    local Vector InitialAIDirection;
    local SFXModule_MarkerGrenade oMarker;
    
    bExploded = FALSE;
    bSpeedThresholdFuseSet = FALSE;
    SpeedThresholdFuseLength = default.SpeedThresholdFuseLength;
    if (FuseSound != None)
    {
        PlaySound(FuseSound, TRUE);
    }
    if (GrenadeWarningStartSound != None)
    {
        PlaySound(GrenadeWarningStartSound, TRUE);
    }
    oCasterPawn = BioPawn(oCaster);
    if (oCasterPawn == None)
    {
        return FALSE;
    }
    AI = SFXAI_Core(oCasterPawn.Controller);
    if (AI != None && AI.FireTarget != None)
    {
        InitialAIDirection = Normal(AI.FireTarget.location - oCasterPawn.location);
        if (oPower != None)
        {
            fMaxRange = oPower.MaximumRange.CurrentValue;
            AI.CalculateGrenadeArc(ProjectileSpeedMin, ProjectileSpeedMax, fMaxRange, fTravelSpeed, InitialAIDirection);
        }
    }
    Super.InitializePowerProjectile(oCaster, fTravelSpeed, fRadius, oPower);
    if (AI != None)
    {
        if (AI.FireTarget != None)
        {
            Init(InitialAIDirection);
        }
    }
    else
    {
        PC = BioPlayerController(oCasterPawn.Controller);
        if (PC != None)
        {
            Init(Vector(PC.Rotation));
        }
    }
    if (fFuseLength > float(0))
    {
        SetTimer(fFuseLength, FALSE, 'FuseDone', );
    }
    oMarker = GetModule(Class'SFXModule_MarkerGrenade');
    if (oMarker != None)
    {
        oMarker.VisibleDistance = GetDamageRadius() * 1.29999995;
        oMarker.Activate();
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ProjectileSpeedMin = 500.0
    ProjectileSpeedMax = 2500.0
    RotationsPerSecond = 4.0
    SpeedThresholdFuseLength = 2.75
    fFuseLength = 5.0
    TossZ = 250.0
    CoefficientOfRestitution = 0.300000012
    ExplodeSpeedThreshold = 50.0
    BounceSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_grenade_bounce'
    bArcing = TRUE
    Speed = 2000.0
    MaxSpeed = 2000.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    LifeSpan = 5.0
    CollisionComponent = CollisionCylinder
}