Class SFXVehicle_MountedGun extends SVehicle
    native
    placeable
    abstract
    config(Game);

var Rotator AimDir;
var Rotator DesiredAimDir;
var Controller Claim;
var(SFXVehicle_MountedGun) SFXLoadoutData Loadout;
var transient float PreviousCameraPitch;
var config float MaxPitchAngle;
var(Lighting) editinline export LightEnvironmentComponent LightEnvironment;
var config float RadarRange;
var config float RadarFOV;
var transient SkelControlLookAt oSkelControlGun;
var transient SkelControlLookAt oSkelControlShield;
var(Target) SFXAnimSetCookSpec DriverAnimInfo;
var float YawClamp;
var(SFXVehicle_MountedGun) float TrackSpeed;
var(SFXVehicle_MountedGun) float SearchSpeed;
var(SFXVehicle_MountedGun) float TooCloseDist;
var(SFXVehicle_MountedGun) float EligibleAIRange;
var(SFXVehicle_MountedGun) Actor MountingPoint;
var(SFXVehicle_MountedGun) float PlayerDamageReduction;
var float MaxYawSpeed;
var WwiseEvent TurretLoopStart;
var WwiseEvent TurretLoopStop;
var bool bWeaponFiring;
var transient bool m_bIsPaused;
var(SFXVehicle_MountedGun) bool bAllowedToLeave;
var(SFXVehicle_MountedGun) bool bAICanUse;
var transient bool bFiring;
var(SFXVehicle_MountedGun) bool bForceTightAim;

public function AddDefaultInventory()
{
    local SFXLoadoutData ChkLoadout;
    local SFXShield_Base Shields;
    local Class<SFXWeapon> WeaponClass;
    local ShieldLoadout ShieldLoadout;
    local Vector LookAt;
    
    ChkLoadout = Loadout;
    if (ChkLoadout == None)
    {
        return;
    }
    foreach ChkLoadout.Weapons(WeaponClass, )
    {
        Weapon = SFXWeapon(CreateInventory(WeaponClass));
        Weapon.AttachWeaponTo(Mesh, 'Socket_Gun');
    }
    foreach ChkLoadout.ShieldLoadouts(ShieldLoadout, )
    {
        Shields = SFXShield_Base(CreateInventory(ShieldLoadout.Shields));
        if (Shields != None)
        {
            Shields.ShieldScale = ChkLoadout.ShieldScale;
            Shields.ShieldOffset = ChkLoadout.ShieldOffset;
        }
    }
    LookAt = location + Vector(Rotation) * float(200);
    if (oSkelControlGun == None)
    {
        oSkelControlGun = SkelControlLookAt(Mesh.FindSkelControl('Gun'));
    }
    if (oSkelControlGun != None)
    {
        oSkelControlGun.TargetLocation = LookAt;
    }
    if (oSkelControlShield == None)
    {
        oSkelControlShield = SkelControlLookAt(Mesh.FindSkelControl('Shield'));
    }
    if (oSkelControlShield != None)
    {
        oSkelControlShield.TargetLocation = LookAt;
    }
}
public function bool DriverLeave(bool bForceLeave)
{
    local BioPawn ChkPawn;
    local SFXModule_GameEffectManager GEManager;
    local bool bRetval;
    local AnimNodeBlend DrivingBlendNode;
    
    ChkPawn = BioPawn(Driver);
    bRetval = Super(Vehicle).DriverLeave(bForceLeave);
    PlaySound(TurretLoopStop, TRUE);
    if (bRetval)
    {
        Weapon.GotoState('Inactive', , , );
        if (ChkPawn != None)
        {
            DrivingBlendNode = AnimNodeBlend(ChkPawn.Mesh.FindAnimNode('Driving'));
            if (DrivingBlendNode != None)
            {
                DrivingBlendNode.SetBlendTarget(0.0, 0.0);
            }
            if (ChkPawn.IsPlayerPawn())
            {
                GEManager = ChkPawn.GetModule(Class'SFXModule_GameEffectManager');
                if (GEManager != None)
                {
                    GEManager.RemoveEffectsByCategory('CAMGDamageReduction');
                }
            }
            if (BioPlayerController(ChkPawn.Controller) != None)
            {
                BioPlayerController(ChkPawn.Controller).HintSystem.HintEvent('ExitTurret');
            }
        }
    }
    return bRetval;
}
public simulated function Rotator GetViewRotation()
{
    local Rotator ViewRotation;
    local Rotator ControlRotation;
    local Rotator MaxDelta;
    
    ViewRotation.Yaw = Controller.Rotation.Yaw;
    MaxDelta.Yaw = Controller.Rotation.Yaw;
    if (!ClampRotation(ViewRotation, Rotation, MaxDelta, MaxDelta))
    {
        ControlRotation.Yaw = Controller.Rotation.Yaw;
        if (!ClampRotation(ControlRotation, ViewRotation, rot(0, 16384, 0), rot(0, 16384, 0)))
        {
            ControlRotation.Pitch = Controller.Rotation.Pitch;
            ControlRotation.Roll = Controller.Rotation.Roll;
            Controller.SetRotation(ControlRotation);
        }
    }
    ViewRotation.Pitch = Controller.Rotation.Pitch;
    ViewRotation.Roll = Controller.Rotation.Roll;
    return ViewRotation;
}
public function Tick(float DeltaTime)
{
    local BioPlayerController BPC;
    local BioAiController BAIC;
    local Vector CamLoc;
    local Rotator CamRot;
    local Vector LookAt;
    local BioPlayerInput Input;
    local bool bFireInputPressed;
    local bool bIsWeaponPendingFire;
    local SFXWeapon W;
    local int FireMode;
    
    Super(Actor).Tick(DeltaTime);
    UpdateForMovingBase(Base);
    if (Controller == None)
    {
        return;
    }
    BPC = BioPlayerController(Controller);
    BAIC = BioAiController(Controller);
    if (BPC != None)
    {
        bFiring = int(BPC.bFire) == 1;
        Input = BioPlayerInput(BPC.PlayerInput);
        BPC.GetPlayerViewPoint(CamLoc, CamRot);
        LookAt = CamLoc + Normal(Vector(Controller.Rotation)) * float(100000);
    }
    else if (BAIC != None && BAIC.FireTarget != None)
    {
        LookAt = BAIC.FireTarget.location;
    }
    if (oSkelControlGun != None)
    {
        oSkelControlGun.TargetLocation = LookAt;
    }
    if (oSkelControlShield != None)
    {
        oSkelControlShield.TargetLocation = LookAt;
    }
    bFireInputPressed = Controller != None && int(Controller.bFire) == 1;
    W = SFXWeapon(Weapon);
    if (W == None)
    {
        return;
    }
    FireMode = int(W.DefaultFireMode);
    if (InvManager != None && InvManager.IsPendingFire(W, FireMode))
    {
        bIsWeaponPendingFire = TRUE;
    }
    if (bIsWeaponPendingFire == FALSE && bFireInputPressed)
    {
        StartFire(byte(FireMode));
    }
    else if (bIsWeaponPendingFire && bFireInputPressed == FALSE)
    {
        if (Weapon == None)
        {
            if (InvManager != None)
            {
                InvManager.ClearPendingFire(None, FireMode);
            }
        }
        else
        {
            StopFire(byte(FireMode));
        }
    }
    if (Input != None && bAllowedToLeave == TRUE)
    {
        if (Input.RawJoyUp < -0.800000012)
        {
            DriverLeave(TRUE);
            return;
        }
    }
}
protected simulated native function UpdateForMovingBase(Actor BaseActor);

public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType)
{
    if (Damage > float(0))
    {
        TakeDamage(Damage, Caster.Controller, HitLocation, vect(0.0, 0.0, 0.0), DamageType, , Caster);
    }
    return FALSE;
}
public function bool CanEnterVehicle(Pawn P)
{
    return AnySeatAvailable() && P.DrivenVehicle == None && P.Controller != None && !P.IsA('Vehicle') && Health > 0;
}
public function DriverDied(Class<DamageType> DamageType)
{
    Super(Vehicle).DriverDied(DamageType);
    Claim = None;
}
public function bool DriverEnter(Pawn P)
{
    local bool bSuccess;
    local BioPawn ChkPawn;
    local SFXModule_GameEffectManager GEManager;
    local AnimNodeBlend DrivingBlendNode;
    
    ExitPositions[0] = P.location + vect(0.0, 0.0, 16.0);
    ChkPawn = BioPawn(P);
    if (ChkPawn != None && SFXWeapon(ChkPawn.Weapon) != None)
    {
        SFXWeapon(ChkPawn.Weapon).SetWeaponHidden(TRUE);
    }
    if (ChkPawn.IsPlayerPawn())
    {
        GEManager = ChkPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (GEManager != None)
        {
            GEManager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', 'CAMGDamageReduction', 0.0, 2, -PlayerDamageReduction, ChkPawn.Controller);
        }
    }
    bSuccess = Super(Vehicle).DriverEnter(P);
    if (bSuccess)
    {
        Claim = None;
        PlaySound(TurretLoopStart, TRUE);
        Weapon.GotoState('Active', , , );
        if (ChkPawn != None)
        {
            ChkPawn.SetBase(Self, , Mesh, 'Socket_Synch');
            ChkPawn.UnregisterTemporaryAnim(DriverAnimInfo.AnimSet);
            ChkPawn.RegisterTemporaryAnim(DriverAnimInfo.AnimSet);
            if (ChkPawn.Mesh != None)
            {
                ChkPawn.Mesh.UpdateAnimations();
                DrivingBlendNode = AnimNodeBlend(ChkPawn.Mesh.FindAnimNode('Driving'));
                if (DrivingBlendNode != None)
                {
                    DrivingBlendNode.SetBlendTarget(1.0, 0.0);
                }
            }
        }
        if (BioPlayerController(Controller) != None)
        {
            BioPlayerController(Controller).HintSystem.HintEvent('EnterTurret');
        }
        MaxYawSpeed = (YawClamp != 0.0 ? YawClamp : 360.0) / 0.00100000005;
    }
    return bSuccess;
}
public final simulated function bool IsPendingFire(byte InFiringMode)
{
    return InvManager != None && InvManager.IsPendingFire(None, int(InFiringMode));
}
public function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    local BioPawn Pawn;
    
    Pawn = BioPawn(Driver);
    if (Pawn != None)
    {
        Pawn.SetBase(None, , , );
        if (SFXWeapon(Pawn.Weapon) != None)
        {
            SFXWeapon(Pawn.Weapon).SetWeaponHidden(FALSE);
        }
        Pawn.StartCustomAction(14, Self);
        Pawn.UnregisterTemporaryAnim(DriverAnimInfo.AnimSet);
        return TRUE;
    }
    return FALSE;
}
public simulated function ProcessViewRotation(float DeltaTime, out Rotator OutViewRot, out Rotator OutDeltaRot)
{
    local WwiseAudioComponent AudioComponent;
    local float OldYaw;
    local float NewYaw;
    local float ActualDeltaYaw;
    
    OldYaw = float(OutViewRot.Yaw);
    Super(Pawn).ProcessViewRotation(DeltaTime, OutViewRot, OutDeltaRot);
    TurretClampYaw(OutViewRot);
    NewYaw = float(OutViewRot.Yaw);
    ActualDeltaYaw = Abs(NewYaw - OldYaw);
    AudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Self);
    if (AudioComponent != None)
    {
        AudioComponent.SetWwiseRTPC("Weapon_MountedGun_Movement", ActualDeltaYaw / DeltaTime / MaxYawSpeed);
    }
}
public function bool TryToDrive(Pawn P)
{
    local Pawn OldDriver;
    local SFXAI_Core AI;
    
    if (Driver == None && P.IsHumanControlled() || Claim == P.Controller)
    {
        if (P.IsHumanControlled() == FALSE)
        {
            OldDriver = Driver;
            Driver = P;
            if (P.SetLocation(GetEntryLocation(), ) && P.SetRotation(Rotation))
            {
                Driver = OldDriver;
                Super.TryToDrive(P);
                AI = SFXAI_Core(Controller);
                if (AI != None)
                {
                    AI.BeginCombatCommand(Class'SFXAICmd_Base_MountedGunner', "Put on turret");
                    return TRUE;
                }
            }
        }
        else
        {
            return Super.TryToDrive(P);
        }
    }
    return FALSE;
}
public function AIIdleNotification(SFXAI_Core C)
{
    if (FRand() < 0.330000013)
    {
        DesiredAimDir = GetRandomRotForTurretScan(C);
    }
}
public function bool AITryToDriveMe(Pawn P)
{
    local SFXAI_Core AI;
    
    if (Claim == None)
    {
        ClaimTurret(P.Controller);
        AI = SFXAI_Core(P.Controller);
        if (AI != None)
        {
            AI.DriveTarget = Self;
            AI.BeginCombatCommand(Class'SFXAICmd_EnterMountedGun');
            return TRUE;
        }
    }
    return FALSE;
}
public function bool CanBeDrivenBy(SFXPawn PossibleDriver)
{
    local SFXAI_Core AI;
    
    if (PossibleDriver != None && Driver == None && bAICanUse && VSize(location - PossibleDriver.location) <= EligibleAIRange)
    {
        AI = SFXAI_Core(PossibleDriver.Controller);
        if (AI != None && (AI.FireTarget == None || IsWithinRotationClamps(AI.FireTarget.location)))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool ClaimTurret(Controller C)
{
    if (Claim != None && Claim != C)
    {
        return FALSE;
    }
    Claim = C;
    return TRUE;
}
public function Rotator GetRandomRotForTurretScan(SFXAI_Core C)
{
    local Rotator DesiredRot;
    
    if (C.HasValidTarget())
    {
        DesiredRot = Rotator(C.GetFireTargetLocation() - C.Pawn.location);
    }
    else
    {
        DesiredRot = Rotation;
    }
    DesiredRot.Pitch += Rand(2048) - 512;
    DesiredRot.Yaw += Rand(8192) - 4096;
    return DesiredRot;
}
public simulated function bool IsWithinRotationClamps(Vector Loc)
{
    local Rotator Rot;
    
    Rot = Rotator(Loc - location);
    return !TurretClampYaw(Rot);
}
public final simulated function bool TurretClampYaw(out Rotator Rot)
{
    local int DeltaFromCenter;
    local int YawAdj;
    local bool bResult;
    local float YawClampInUU;
    
    if (YawClamp == float(0))
    {
        return FALSE;
    }
    DeltaFromCenter = NormalizeRotAxis(Rot.Yaw - Rotation.Yaw);
    YawClampInUU = YawClamp * 182.044449;
    if (float(DeltaFromCenter) > YawClampInUU)
    {
        YawAdj = int(YawClampInUU - float(DeltaFromCenter));
        bResult = TRUE;
    }
    else if (float(DeltaFromCenter) < -YawClampInUU)
    {
        YawAdj = int(-(float(DeltaFromCenter) + YawClampInUU));
        bResult = TRUE;
    }
    Rot.Yaw += YawAdj;
    return bResult;
}
public function bool UnclaimTurret(Controller C)
{
    if (Claim == C)
    {
        Claim = None;
        return TRUE;
    }
    return FALSE;
}
public function UpdateAIController(SFXAI_Core C, float DeltaTime)
{
    local float InterpSpeed;
    local float DistToTarg;
    local Vector TargLoc;
    
    InterpSpeed = SearchSpeed;
    if (C.HasValidTarget())
    {
        InterpSpeed = TrackSpeed;
        TargLoc = C.GetFireTargetLocation();
        DistToTarg = VSize(location - TargLoc);
        if (C.FireTarget != Self && DistToTarg < TooCloseDist)
        {
            return;
        }
        DesiredAimDir = Rotator(TargLoc - location);
    }
    if (TurretClampYaw(DesiredAimDir))
    {
    }
    AimDir = RInterpTo(AimDir, DesiredAimDir, DeltaTime, InterpSpeed);
    C.Pawn.SetDesiredRotation(AimDir);
}
public function Used(Actor User)
{
    local BioPawn Pawn;
    
    Pawn = BioPawn(User);
    if (Pawn != None && Driver == None)
    {
        Pawn.RegisterTemporaryAnim(DriverAnimInfo.AnimSet);
        Pawn.StartCustomAction(13, Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
        TargetBoneName = 'Root'
        UseTargetBoneAsOrigin = TRUE
    End Object
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius = 10.0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=RB_ConstraintInstance Name=MyStayUprightConstraintInstance
    End Template
    Begin Template Class=RB_StayUprightSetup Name=MyStayUprightSetup
    End Template
    Begin Object Class=SFXSimpleUseModule Name=tempSelectionModule
        __OnUsed__Delegate = class'SFXVehicle_MountedGun'.Used
        fUseRange = 180.0
        m_srGameName = $717641
        m_bTargetable = TRUE
        m_TargetTipText = ETargetTipText.TargetTipText_Activate
    End Object
    Begin Template Class=SkeletalMeshComponent Name=SVehicleMesh
        ReplacementPrimitive = None
    End Template
    LightEnvironment = BioLightEnvComponent0
    YawClamp = 100.0
    TrackSpeed = 2.0
    SearchSpeed = 0.400000006
    TooCloseDist = 355.0
    EligibleAIRange = 2048.0
    PlayerDamageReduction = 0.5
    TurretLoopStart = WwiseEvent'Wwise_Weapons_S_MinigunTurret.Play_wep_s_minigunturret_move_loop_start'
    TurretLoopStop = WwiseEvent'Wwise_Weapons_S_MinigunTurret.Play_wep_s_minigunturret_move_loop_stop'
    bAllowedToLeave = TRUE
    StayUprightConstraintSetup = MyStayUprightSetup
    StayUprightConstraintInstance = MyStayUprightConstraintInstance
    bDriverIsVisible = TRUE
    bAttachDriver = FALSE
    InventoryManagerClass = Class'SFXInventoryManager'
    Mesh = SVehicleMesh
    CylinderComponent = CollisionCylinder
    ViewPitchMin = -6144.0
    ViewPitchMax = 6144.0
    Components = (CollisionCylinder, SVehicleMesh, BioLightEnvComponent0)
    Modules = (tempSelectionModule)
    RotationRate = {Pitch = 16384, Yaw = 109226, Roll = 16384}
    CollisionComponent = SVehicleMesh
    bIgnoreEncroachers = TRUE
    bBlocksTeleport = FALSE
    bCollideAsEncroacher = TRUE
    Physics = EPhysics.PHYS_None
}