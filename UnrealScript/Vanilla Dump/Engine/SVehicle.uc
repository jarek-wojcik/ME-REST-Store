Class SVehicle extends Vehicle
    native
    placeable
    nativereplication
    abstract
    config(Game);

struct native VehicleState 
{
    var RigidBodyState RBState;
    var int ServerView;
    var bool bServerHandbrake;
    var byte ServerBrake;
    var byte ServerGas;
    var byte ServerSteering;
    var byte ServerRise;
};

var const native VehicleState VState;
var(SVehicle) editinline export array<SVehicleWheel> Wheels;
var(SVehicle) Vector COMOffset;
var(SVehicle) Vector InertiaTensorMultiplier;
var(SVehicle) Vector BaseOffset;
var(SVehicle) const editinline export noclear SVehicleSimBase SimObj;
var(UprightConstraint) float StayUprightRollResistAngle;
var(UprightConstraint) float StayUprightPitchResistAngle;
var(UprightConstraint) float StayUprightStiffness;
var(UprightConstraint) float StayUprightDamping;
var float HeavySuspensionShiftPercent;
var(SVehicle) float MaxSpeed;
var(SVehicle) float MaxAngularVelocity;
var const float TimeOffGround;
var(Uprighting) float UprightLiftStrength;
var(Uprighting) float UprightTorqueStrength;
var(Uprighting) float UprightTime;
var float UprightStartTime;
var(Sounds) editinline export AudioComponent EngineSound;
var(Sounds) editinline export AudioComponent SquealSound;
var(Sounds) SoundCue CollisionSound;
var(Sounds) SoundCue EnterVehicleSound;
var(Sounds) SoundCue ExitVehicleSound;
var(Sounds) float CollisionIntervalSecs;
var(Sounds) const float SquealThreshold;
var(Sounds) const float SquealLatThreshold;
var(Sounds) const float LatAngleVolumeMult;
var(Sounds) const float EngineStartOffsetSecs;
var(Sounds) const float EngineStopOffsetSecs;
var float LastCollisionSoundTime;
var float OutputBrake;
var float OutputGas;
var float OutputSteering;
var float OutputRise;
var float ForwardVel;
var int NumPoweredWheels;
var(SVehicle) float CamDist;
var int DriverViewPitch;
var int DriverViewYaw;
var const native float AngErrorAccumulator;
var float RadialImpulseScaling;
var export RB_StayUprightSetup StayUprightConstraintSetup;
var export RB_ConstraintInstance StayUprightConstraintInstance;
var(UprightConstraint) bool bStayUpright;
var bool bUseSuspensionAxis;
var bool bUpdateWheelShapes;
var const bool bVehicleOnGround;
var const bool bVehicleOnWater;
var const bool bIsInverted;
var const bool bChassisTouchingGround;
var const bool bWasChassisTouchingGroundLastTick;
var bool bCanFlip;
var bool bFlipRight;
var bool bIsUprighting;
var bool bOutputHandbrake;
var bool bHoldingDownHandbrake;

public native function AddForce(Vector Force);

public native function AddImpulse(Vector impulse);

public native function AddTorque(Vector Torque);

public event simulated function Destroyed()
{
    Super.Destroyed();
    StopVehicleSounds();
}
public simulated native function bool HasWheelsOnGround();

public native function InitVehicleRagdoll(SkeletalMesh RagdollMesh, PhysicsAsset RagdollPhysAsset, Vector ActorMove, bool bClearAnimTree);

public native function bool IsSleeping();

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (EngineSound != None)
    {
        EngineSound.bShouldRemainActiveIfDropped = TRUE;
    }
    if (CollisionSound != None && CollisionIntervalSecs <= 0.0)
    {
        CollisionIntervalSecs = CollisionSound.GetCueDuration() / WorldInfo.TimeDilation;
    }
}
public event simulated function PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local int WheelIndex;
    local SVehicleWheel Wheel;
    
    Super(Pawn).PostInitAnimTree(SkelComp);
    if (SkelComp == Mesh)
    {
        for (WheelIndex = 0; WheelIndex < Wheels.Length; WheelIndex++)
        {
            Wheel = Wheels[WheelIndex];
            Wheel.WheelControl = SkelControlWheel(Mesh.FindSkelControl(Wheel.SkelControlName));
        }
    }
}
public event simulated function RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    if (CollisionSound != None && WorldInfo.TimeSeconds - LastCollisionSoundTime > CollisionIntervalSecs)
    {
        if (CollisionSound != None)
        {
            PlaySound(CollisionSound, TRUE);
            LastCollisionSoundTime = WorldInfo.TimeSeconds;
        }
    }
}
public final native function SetWheelCollision(int WheelNum, bool bCollision);

public event simulated function SuspensionHeavyShift(float Delta);

public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    local Vector HitLocation;
    local Vector Dir;
    local Vector NewDir;
    local float Dist;
    local float DamageScale;
    
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    HitLocation = location;
    Dir = location - HurtOrigin;
    CheckHitInfo(HitInfo, Mesh, Dir, HitLocation);
    NewDir = HitLocation - HurtOrigin;
    Dist = VSize(NewDir);
    if (bFullDamage)
    {
        DamageScale = 1.0;
    }
    else if (Dist > DamageRadius)
    {
        return;
    }
    else
    {
        DamageScale = FMax(0.0, 1.0 - Dist / DamageRadius);
        DamageScale = DamageScale ** DamageFalloffExponent;
    }
    RadialImpulseScaling = DamageScale;
    TakeDamage(BaseDamage * DamageScale, instigatedBy, HitLocation, DamageScale * Momentum * Normal(Dir), DamageType, HitInfo, DamageCauser);
    RadialImpulseScaling = 1.0;
    if (Health > 0)
    {
        DriverRadiusDamage(BaseDamage, DamageRadius, instigatedBy, DamageType, Momentum, HurtOrigin, DamageCauser);
    }
}
public simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector pos;
    local Vector HitLocation;
    local Vector HitNormal;
    
    GetActorEyesViewPoint(out_CamLoc, out_CamRot);
    out_CamLoc += BaseOffset;
    pos = out_CamLoc - Vector(out_CamRot) * CamDist;
    if (Trace(HitLocation, HitNormal, pos, out_CamLoc, FALSE, vect(0.0, 0.0, 0.0), , ) != None)
    {
        out_CamLoc = HitLocation + HitNormal * float(2);
    }
    else
    {
        out_CamLoc = pos;
    }
    return TRUE;
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local array<string> DebugInfo;
    local int i;
    
    Super.DisplayDebug(HUD, out_YL, out_YPos);
    GetSVehicleDebug(DebugInfo);
    HUD.Canvas.SetDrawColor(0, 255, 0);
    for (i = 0; i < DebugInfo.Length; i++)
    {
        HUD.Canvas.DrawText("  " @ DebugInfo[i]);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0, out_YPos);
    }
}
public function PostTeleport(Teleporter OutTeleporter)
{
    Mesh.SetRBPosition(location);
}
public function AddVelocity(Vector NewVelocity, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    if (!IsZero(NewVelocity))
    {
        NewVelocity = RadialImpulseScaling * MomentumMult * DamageType.default.VehicleMomentumScaling * DamageType.default.KDamageImpulse * Normal(NewVelocity);
        if (!bIgnoreForces && !IsZero(NewVelocity))
        {
            if (location.Z > WorldInfo.StallZ)
            {
                NewVelocity.Z = FMin(NewVelocity.Z, 0.0);
            }
            if (InGodMode())
            {
                NewVelocity *= 0.25;
            }
            Mesh.AddImpulse(NewVelocity, HitLocation);
        }
    }
    RadialImpulseScaling = 1.0;
}
public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    if (Super.Died(Killer, DamageType, HitLocation))
    {
        bDriving = FALSE;
        AddVelocity(TearOffMomentum, HitLocation, DamageType);
        return TRUE;
    }
    return FALSE;
}
public simulated function DisplayWheelsDebug(HUD HUD, float YL)
{
    local int i;
    local int J;
    local Vector WorldLoc;
    local Vector ScreenLoc;
    local Vector X;
    local Vector Y;
    local Vector Z;
    local Color SaveColor;
    local float LastForceValue;
    local float GraphScale;
    local float ForceValue;
    local Vector ForceValueLoc;
    
    if (SimObj == None)
    {
        return;
    }
    GraphScale = 100.0;
    SaveColor = HUD.Canvas.DrawColor;
    for (i = 0; i < Wheels.Length; i++)
    {
        GetAxes(Rotation, X, Y, Z);
        WorldLoc = location + (Wheels[i].WheelPosition >> Rotation);
        ScreenLoc = HUD.Canvas.Project(WorldLoc);
        if (ScreenLoc.X >= float(0) && ScreenLoc.X < HUD.Canvas.ClipX && ScreenLoc.Y >= float(0) && ScreenLoc.Y < HUD.Canvas.ClipY)
        {
            HUD.Canvas.DrawColor = MakeColor(255, 255, 255, 255);
            HUD.Draw2DLine(int(ScreenLoc.X), int(ScreenLoc.Y), int(ScreenLoc.X + GraphScale), int(ScreenLoc.Y), MakeColor(0, 0, 255, 255));
            HUD.Canvas.SetPos(ScreenLoc.X + GraphScale, ScreenLoc.Y);
            HUD.Canvas.DrawText(string(3.14159274 * 0.5));
            HUD.Draw2DLine(int(ScreenLoc.X), int(ScreenLoc.Y), int(ScreenLoc.X), int(ScreenLoc.Y - GraphScale), MakeColor(0, 0, 255, 255));
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y - GraphScale);
            HUD.Canvas.DrawText(string(SimObj.WheelLatExtremumValue));
            LastForceValue = 0.0;
            for (J = 0; float(J) <= GraphScale; J++)
            {
                ForceValue = HermiteEval(float(J) * (3.14159274 * 0.5 / GraphScale));
                ForceValue = ForceValue / SimObj.WheelLatExtremumValue * GraphScale;
                HUD.Draw2DLine(int(ScreenLoc.X + float((J - 1))), int(ScreenLoc.Y - LastForceValue), int(ScreenLoc.X + float(J)), int(ScreenLoc.Y - ForceValue), MakeColor(0, 255, 0, 255));
                LastForceValue = ForceValue;
            }
            ForceValue = HermiteEval(Abs(Wheels[i].LatSlipAngle));
            ForceValueLoc.X = ScreenLoc.X + Abs(Wheels[i].LatSlipAngle) / (3.14159274 * 0.5) * GraphScale;
            ForceValueLoc.Y = ScreenLoc.Y - ForceValue / SimObj.WheelLatExtremumValue * GraphScale;
            HUD.Draw2DLine(int(ForceValueLoc.X - float(5)), int(ForceValueLoc.Y), int(ForceValueLoc.X + float(5)), int(ForceValueLoc.Y), MakeColor(255, 0, 0, 255));
            HUD.Draw2DLine(int(ForceValueLoc.X), int(ForceValueLoc.Y - float(5)), int(ForceValueLoc.X), int(ForceValueLoc.Y + float(5)), MakeColor(255, 0, 0, 255));
            HUD.Canvas.SetPos(ScreenLoc.X, ForceValueLoc.Y);
            HUD.Canvas.DrawText(string(ForceValue));
            HUD.Canvas.SetPos(ForceValueLoc.X, ScreenLoc.Y + YL);
            HUD.Canvas.DrawText(string(Wheels[i].LatSlipAngle));
        }
    }
    HUD.Canvas.DrawColor = SaveColor;
}
public simulated function DrivingStatusChanged()
{
    bUpdateWheelShapes = TRUE;
    if (bDriving)
    {
        VehiclePlayEnterSound();
    }
    else if (Health > 0)
    {
        VehiclePlayExitSound();
    }
}
public simulated function Name GetDefaultCameraMode(PlayerController RequestedBy)
{
    return 'Default';
}
public simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
    DebugInfo[DebugInfo.Length] = "----Vehicle----: ";
    DebugInfo[DebugInfo.Length] = "Speed: " $ VSize(Velocity) $ " Unreal -- " $ VSize(Velocity) * 0.0426125005 $ " MPH";
    if (Wheels.Length > 0)
    {
        DebugInfo[DebugInfo.Length] = "MotorTorque: " $ Wheels[0].MotorTorque;
    }
    DebugInfo[DebugInfo.Length] = "Throttle: " $ OutputGas;
    DebugInfo[DebugInfo.Length] = "Brake: " $ OutputBrake;
}
public simulated function float HermiteEval(float Slip)
{
    local float LatExtremumSlip;
    local float LatExtremumValue;
    local float LatAsymptoteSlip;
    local float LatAsymptoteValue;
    local float SlipSquared;
    local float SlipCubed;
    local float C0;
    local float C1;
    local float C3;
    
    LatExtremumSlip = SimObj.WheelLatExtremumSlip;
    LatExtremumValue = SimObj.WheelLatExtremumValue;
    LatAsymptoteSlip = SimObj.WheelLatAsymptoteSlip;
    LatAsymptoteValue = SimObj.WheelLatAsymptoteValue;
    if (Slip < LatExtremumSlip)
    {
        Slip /= LatExtremumSlip;
        SlipSquared = Slip * Slip;
        SlipCubed = SlipSquared * Slip;
        C3 = -2.0 * SlipCubed + 3.0 * SlipSquared;
        C1 = SlipCubed - 2.0 * SlipSquared + Slip;
        return (C1 + C3) * LatExtremumValue;
    }
    else if (Slip > LatAsymptoteSlip)
    {
        return LatAsymptoteValue;
    }
    else
    {
        Slip /= LatAsymptoteSlip - LatExtremumSlip;
        Slip -= LatExtremumSlip;
        SlipSquared = Slip * Slip;
        SlipCubed = SlipSquared * Slip;
        C3 = -2.0 * SlipCubed + 3.0 * SlipSquared;
        C0 = 2.0 * SlipCubed - 3.0 * SlipSquared + 1.0;
        return C0 * LatExtremumValue + C3 * LatAsymptoteValue;
    }
}
public simulated function SetAllWheelParticleSystem(ParticleSystem NewSystem)
{
    local int i;
    
    for (i = 0; i < Wheels.Length; i++)
    {
        if (Wheels[i].WheelParticleComp != None)
        {
            Wheels[i].WheelParticleComp.SetTemplate(NewSystem);
        }
    }
}
public simulated function StartEngineSound()
{
    if (EngineSound != None)
    {
        EngineSound.Play();
    }
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
}
public simulated function StartEngineSoundTimed()
{
    if (EngineStartOffsetSecs > 0.0)
    {
        ClearTimer('StopEngineSound');
        SetTimer(EngineStartOffsetSecs, FALSE, 'StartEngineSound', );
    }
    else
    {
        StartEngineSound();
    }
}
public simulated function StopEngineSound()
{
    if (EngineSound != None)
    {
        EngineSound.Stop();
    }
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
}
public simulated function StopEngineSoundTimed()
{
    if (EngineStopOffsetSecs > 0.0)
    {
        ClearTimer('StartEngineSound');
        SetTimer(EngineStopOffsetSecs, FALSE, 'StopEngineSound', );
    }
    else
    {
        StopEngineSound();
    }
}
public simulated function StopVehicleSounds()
{
    if (EngineSound != None)
    {
        EngineSound.Stop();
    }
    if (SquealSound != None)
    {
        SquealSound.Stop();
    }
}
public function bool TryToDrive(Pawn P)
{
    return Super.TryToDrive(P);
}
public simulated function TurnOff()
{
    Super(Pawn).TurnOff();
    StopVehicleSounds();
}
public simulated function VehiclePlayEnterSound()
{
    if (EnterVehicleSound != None)
    {
        PlaySound(EnterVehicleSound);
    }
    StartEngineSoundTimed();
}
public simulated function VehiclePlayExitSound()
{
    if (ExitVehicleSound != None)
    {
        PlaySound(ExitVehicleSound);
    }
    StopEngineSoundTimed();
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (Physics == EPhysics.PHYS_RigidBody)
        VState, MaxSpeed;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=RB_ConstraintInstance Name=MyStayUprightConstraintInstance
    End Object
    Begin Object Class=RB_StayUprightSetup Name=MyStayUprightSetup
    End Object
    Begin Object Class=SkeletalMeshComponent Name=SVehicleMesh
        bUseSingleBodyPhysics = 1
        bForceDiscardRootMotion = TRUE
        ReplacementPrimitive = None
        RBChannel = ERBCollisionChannel.RBCC_Vehicle
        CollideActors = TRUE
        BlockActors = TRUE
        BlockZeroExtent = TRUE
        BlockNonZeroExtent = TRUE
        BlockRigidBody = TRUE
        bNotifyRigidBodyCollision = TRUE
        RBCollideWithChannels = {Default = TRUE, Vehicle = TRUE, GameplayPhysics = TRUE, EffectPhysics = TRUE, BlockingVolume = TRUE}
        ScriptRigidBodyCollisionThreshold = 250.0
    End Object
    InertiaTensorMultiplier = {X = 1.0, Y = 1.0, Z = 1.0}
    BaseOffset = {X = 0.0, Y = 0.0, Z = 128.0}
    HeavySuspensionShiftPercent = 0.5
    MaxSpeed = 2500.0
    MaxAngularVelocity = 75000.0
    UprightLiftStrength = 225.0
    UprightTorqueStrength = 50.0
    UprightTime = 1.5
    SquealThreshold = 250.0
    SquealLatThreshold = 250.0
    LatAngleVolumeMult = 1.0
    EngineStartOffsetSecs = 2.0
    EngineStopOffsetSecs = 1.0
    CamDist = 512.0
    RadialImpulseScaling = 1.0
    StayUprightConstraintSetup = MyStayUprightSetup
    StayUprightConstraintInstance = MyStayUprightConstraintInstance
    bCanFlip = TRUE
    Mesh = SVehicleMesh
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder, SVehicleMesh)
    CollisionComponent = SVehicleMesh
    bNetInitialRotation = TRUE
    bBlocksTeleport = TRUE
    bEdShouldSnap = TRUE
    Physics = EPhysics.PHYS_RigidBody
    TickGroup = ETickingGroup.TG_PostAsyncWork
}