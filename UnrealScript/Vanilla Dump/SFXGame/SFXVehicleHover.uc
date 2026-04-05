Class SFXVehicleHover extends SVehicle
    native
    placeable
    config(Game);

var(SFXVehicleHover) config Vector JumpForce;
var(SFXVehicleHover) config Vector BoostForce;
var config Vector OffGroundForce;
var transient Vector m_vPauseVelocity;
var(SFXVehicleHover) SFXLoadoutData Loadout;
var transient float CurrentThrustJuice;
var(SFXVehicleHover) config float MaxThrustJuice;
var(SFXVehicleHover) config float ThrustRegenerationFactor;
var editinline transient export WwiseAudioComponent AudioComponent;
var WwiseEventPairObject VehicleMotorEventPair;
var WwiseEventPairObject VehicleVerticalBoostEventPair;
var WwiseEventPairObject VehicleForwardBoostEventPair;
var WwiseEvent VehicleVerticalBoostEndEvent;
var WwiseEvent VehicleForwardBoostEndEvent;
var WwiseEvent VehicleBottomOutEvent;
var WwiseEvent VehicleMiningSuccessEvent;
var WwiseEvent VehicleMiningFailureEvent;
var WwiseEvent VehicleStartupEvent;
var WwiseEvent VehicleShutdownEvent;
var WwiseEvent LeftSuspensionEvent;
var WwiseEvent RightSuspensionEvent;
var WwiseEvent HitSomething;
var WwiseEventPairObject VehicleMiningEventPair;
var WwiseEventPairObject VehicleTurretMovementStartEventPair;
var transient float LastLeftSuspension;
var transient float LastRightSuspension;
var ForceFeedbackWaveform ThrustFeedback;
var transient float PreviousCameraPitch;
var(SFXVehicleHover) config float OnGroundJumpMultiplier;
var config float ForwardThrustBurnRate;
var config float VerticalThrustBurnRate;
var config float ThrustRegenerationDelay;
var config float BurnOutPercentage;
var transient float ForcedRegenAmount;
var transient float TimeLeftToStartRegen;
var config float SelfRepairDelay;
var config float SelfRepairRate;
var transient float LastHitTime;
var float HitDamage;
var config float MaxPitchAngle;
var transient SFXMiningNode CurrentMiningNode;
var transient float TotalMiningTime;
var transient float TimeToNextMiningImpulse;
var ForceFeedbackWaveform MiningFeedbackWaveForm;
var transient float TimeToNextMiningFlash;
var transient float TimeToFlashMiningIndicator;
var transient float MiningIndicatorColor;
var float MiningFlashDelay;
var float MiningFlashDuration;
var ParticleSystem m_oMiningVFXTemplate;
var editinline export ParticleSystemComponent MiningPSC;
var ParticleSystem m_oAfterburnerVisual;
var editinline export ParticleSystemComponent LeftAfterburnerPSC;
var editinline export ParticleSystemComponent RightAfterburnerPSC;
var(Lighting) editinline export LightEnvironmentComponent LightEnvironment;
var config float RadarRange;
var config float RadarFOV;
var bool bWeaponFiring;
var transient bool bAudioXBoostEventStopped;
var transient bool bAudioZBoostEventStopped;
var transient bool bTurrentMovementSoundStopped;
var transient bool bMiningFailed;
var transient bool m_bIsPaused;

public function AddDefaultInventory()
{
    local SFXLoadoutData ChkLoadout;
    local SFXShield_Base Shields;
    local Class<SFXWeapon> WeaponClass;
    local ShieldLoadout ShieldLoadout;
    
    AudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Self);
    if (AudioComponent != None)
    {
        AudioComponent.Play(VehicleMotorEventPair);
    }
    ChkLoadout = Loadout;
    if (ChkLoadout == None)
    {
        return;
    }
    foreach ChkLoadout.Weapons(WeaponClass, )
    {
        Weapon = SFXWeapon(CreateInventory(WeaponClass));
        Weapon.AttachWeaponTo(Mesh, 'Turret_Muzzle_1');
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
    CurrentThrustJuice = MaxThrustJuice;
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
public function bool IsFriendly(Pawn Other)
{
    return int(GetTeamNum()) == int(Other.GetTeamNum());
}
public function bool IsHostile(Pawn Other)
{
    return int(GetTeamNum()) != int(Other.GetTeamNum());
}
public function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local BioPawn BPawn;
    
    BPawn = BioPawn(Other);
    if (BPawn != None)
    {
        BPawn.AddRagdollImpulse(Velocity * (HitNormal Dot Normal(Velocity)), Controller, BPawn.location, TRUE);
        Other.TakeDamage(HitDamage, BPawn.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), Class'SFXDamageType');
    }
    return TRUE;
}
public event function RanInto(Actor Other);

public event simulated function RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local float ContactMag;
    
    if (OtherComponent.Owner == Self)
    {
        OtherComponent = HitComponent;
    }
    ContactMag = VSize(RigidCollisionData.TotalNormalForceVector);
    if (ContactMag > float(20))
    {
        AudioComponent.Play(HitSomething);
        BioPlayerController(Controller).CameraShake(0.449999988, vect(0.00200000009, 0.00200000009, 0.00200000009) * ContactMag, vect(10.0, 10.0, 10.0), vect(0.000199999995, 0.000199999995, 0.000199999995) * ContactMag, vect(100.0, 100.0, 100.0), 0.000199999995 * ContactMag, 10.0);
    }
}
public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SFXModule_Damage DmgModule;
    
    Super(Vehicle).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo);
    DmgModule = GetModule(Class'SFXModule_Damage');
    if (AudioComponent != None && DmgModule != None)
    {
        AudioComponent.SetWwiseRTPC("Health", DmgModule.GetCurrentHealth());
    }
    LastHitTime = WorldInfo.GameTimeSeconds;
}
public function Tick(float DeltaTime)
{
    local BioPlayerController BPC;
    local Vector ForceVector;
    local SkelControlLookAt oSkelControl;
    local Vector CamLoc;
    local Rotator CamRot;
    local SFXModule_Damage DmgModule;
    local float fHealthPercent;
    local MaterialInstanceConstant DamageMaterial;
    local SFXMiningNode Node;
    local Rotator RandomRotation;
    local Vector RandomImpulse;
    local int idx;
    local SFXSeqEvt_VehicleMiningSuccess SuccessEvent;
    local SFXSeqEvt_VehicleMiningFailure FailureEvent;
    local float fBottomOutPercentage;
    
    if (m_bIsPaused || WorldInfo.bPlayersOnly)
    {
        return;
    }
    fBottomOutPercentage = 0.850000024;
    bWeaponFiring = IsFiring();
    if (AudioComponent != None)
    {
        AudioComponent.SetWwiseRTPC("Velocity", VSize(Velocity));
        if (Abs(LastLeftSuspension - Wheels[0].SuspensionPosition) > float(3) && !AudioComponent.IsPlaying(LeftSuspensionEvent))
        {
            AudioComponent.Play(LeftSuspensionEvent);
        }
        LastLeftSuspension = Wheels[0].SuspensionPosition;
        if (Abs(LastRightSuspension - Wheels[3].SuspensionPosition) > float(3) && !AudioComponent.IsPlaying(RightSuspensionEvent))
        {
            AudioComponent.Play(RightSuspensionEvent);
        }
        LastRightSuspension = Wheels[3].SuspensionPosition;
        if ((Wheels[0].SuspensionPosition > Wheels[0].SuspensionTravel * fBottomOutPercentage || Wheels[3].SuspensionPosition > Wheels[3].SuspensionTravel * fBottomOutPercentage) && !AudioComponent.IsPlaying(VehicleBottomOutEvent))
        {
            AudioComponent.Play(VehicleBottomOutEvent);
        }
    }
    if (Controller == None)
    {
        return;
    }
    BPC = BioPlayerController(Controller);
    if (BPC != None)
    {
        if (int(BPC.bBoost) == 1 && CurrentThrustJuice > float(0) && ForcedRegenAmount <= 0.0 && float(Rotation.Pitch) < MaxPitchAngle)
        {
            CurrentThrustJuice -= DeltaTime * ForwardThrustBurnRate;
            ForceVector = QuatRotateVector(QuatFromRotator(Rotation), BoostForce);
            Mesh.AddForce(ForceVector);
            BPC.ClientPlayForceFeedbackWaveform(ThrustFeedback);
            if (AudioComponent != None && bAudioXBoostEventStopped)
            {
                AudioComponent.Play(VehicleForwardBoostEventPair);
                bAudioXBoostEventStopped = FALSE;
            }
            TimeLeftToStartRegen = ThrustRegenerationDelay;
            if (m_oAfterburnerVisual != None)
            {
                if (LeftAfterburnerPSC != None && !LeftAfterburnerPSC.bIsActive)
                {
                    LeftAfterburnerPSC.SetTemplate(m_oAfterburnerVisual);
                    LeftAfterburnerPSC.SetAbsolute(FALSE, FALSE, FALSE);
                    LeftAfterburnerPSC.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
                    LeftAfterburnerPSC.SetTranslation(vect(-164.439499, -57.0, 16.5));
                    LeftAfterburnerPSC.SetRotation(rot(32768, 0, 0));
                    LeftAfterburnerPSC.ActivateSystem();
                }
                if (RightAfterburnerPSC != None && !RightAfterburnerPSC.bIsActive)
                {
                    RightAfterburnerPSC.SetTemplate(m_oAfterburnerVisual);
                    RightAfterburnerPSC.SetAbsolute(FALSE, FALSE, FALSE);
                    RightAfterburnerPSC.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
                    RightAfterburnerPSC.SetTranslation(vect(-164.439499, 57.0, 16.5));
                    RightAfterburnerPSC.SetRotation(rot(32768, 0, 0));
                    RightAfterburnerPSC.ActivateSystem();
                }
            }
        }
        else
        {
            if (AudioComponent != None && !bAudioXBoostEventStopped)
            {
                AudioComponent.Stop(VehicleForwardBoostEventPair);
                AudioComponent.Play(VehicleForwardBoostEndEvent);
                bAudioXBoostEventStopped = TRUE;
            }
            if (LeftAfterburnerPSC != None)
            {
                LeftAfterburnerPSC.DeactivateSystem();
            }
            if (RightAfterburnerPSC != None)
            {
                RightAfterburnerPSC.DeactivateSystem();
            }
        }
        if (int(BPC.bJump) == 1 && CurrentThrustJuice > float(0) && ForcedRegenAmount <= 0.0)
        {
            CurrentThrustJuice -= DeltaTime * VerticalThrustBurnRate;
            ForceVector = QuatRotateVector(QuatFromRotator(Rotation), JumpForce);
            if (bVehicleOnGround)
            {
                Mesh.AddForce((ForceVector + OffGroundForce) * OnGroundJumpMultiplier);
            }
            else
            {
                Mesh.AddForce(ForceVector);
            }
            if (AudioComponent != None && bAudioZBoostEventStopped)
            {
                AudioComponent.Play(VehicleVerticalBoostEventPair);
                bAudioZBoostEventStopped = FALSE;
            }
            TimeLeftToStartRegen = ThrustRegenerationDelay;
        }
        else if (AudioComponent != None && !bAudioZBoostEventStopped)
        {
            AudioComponent.Stop(VehicleVerticalBoostEventPair);
            AudioComponent.Play(VehicleVerticalBoostEndEvent);
            bAudioZBoostEventStopped = TRUE;
        }
        if (bVehicleOnGround)
        {
            TimeLeftToStartRegen = 0.0;
        }
        if ((int(BPC.bJump) == 0 && int(BPC.bBoost) == 0 || ForcedRegenAmount > 0.0) && TimeLeftToStartRegen <= 0.0)
        {
            if (ForcedRegenAmount > 0.0)
            {
                ForcedRegenAmount -= DeltaTime * ThrustRegenerationFactor;
            }
            if (CurrentThrustJuice < MaxThrustJuice)
            {
                CurrentThrustJuice = CurrentThrustJuice + DeltaTime * ThrustRegenerationFactor;
                if (CurrentThrustJuice > MaxThrustJuice)
                {
                    CurrentThrustJuice = MaxThrustJuice;
                }
            }
        }
        else
        {
            if (TimeLeftToStartRegen > 0.0)
            {
                TimeLeftToStartRegen -= DeltaTime;
            }
            if ((int(BPC.bJump) == 1 || int(BPC.bBoost) == 1) && CurrentThrustJuice <= 0.0)
            {
                ForcedRegenAmount = MaxThrustJuice * BurnOutPercentage;
            }
        }
    }
    if (!bVehicleOnGround)
    {
        Mesh.AddForce(OffGroundForce);
    }
    DmgModule = GetModule(Class'SFXModule_Damage');
    fHealthPercent = DmgModule.GetCurrentHealth() / DmgModule.GetMaxHealth();
    if (DmgModule != None && WorldInfo.GameTimeSeconds - LastHitTime > SelfRepairDelay && DmgModule.GetCurrentHealth() < DmgModule.GetMaxHealth())
    {
        DmgModule.SetCurrentHealth(FMin(DmgModule.GetCurrentHealth() + DeltaTime * SelfRepairRate, DmgModule.GetMaxHealth()));
        if (AudioComponent != None)
        {
            AudioComponent.SetWwiseRTPC("Health", DmgModule.GetCurrentHealth());
        }
    }
    if (Mesh.SkeletalMesh.Materials.Length > 0)
    {
        DamageMaterial = MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[0]);
        if (DamageMaterial != None)
        {
            DamageMaterial.SetScalarParameterValue('VEH_ROVb_Damage_Scalar', 1.5 - fHealthPercent * 1.5);
            if (fHealthPercent <= 0.200000003)
            {
                DamageMaterial.SetScalarParameterValue('Engine_Damaged', 1.0);
            }
            else if (fHealthPercent <= 0.300000012)
            {
                DamageMaterial.SetScalarParameterValue('Engine_Damaged', 1.0 - (fHealthPercent - 0.200000003) / 0.100000001);
            }
            else
            {
                DamageMaterial.SetScalarParameterValue('Engine_Damaged', 0.0);
            }
            DamageMaterial.SetScalarParameterValue('Fuel_Time', CurrentThrustJuice / MaxThrustJuice * 0.25 + 0.349999994);
            DamageMaterial.SetScalarParameterValue('Fuel_Gauge', 1.0 - CurrentThrustJuice / MaxThrustJuice * 0.600000024);
            if (CurrentThrustJuice / MaxThrustJuice < BurnOutPercentage && BurnOutPercentage > 0.0)
            {
                DamageMaterial.SetScalarParameterValue('Engine_Heat', 1.0 - CurrentThrustJuice / MaxThrustJuice / BurnOutPercentage);
            }
            else
            {
                DamageMaterial.SetScalarParameterValue('Engine_Heat', 0.0);
            }
            if (CurrentMiningNode != None && int(BPC.bMine) != 0 && bVehicleOnGround == TRUE && CurrentMiningNode.bAlreadyMined != TRUE)
            {
                DamageMaterial.SetScalarParameterValue('mining_color', 1.0 - TotalMiningTime / CurrentMiningNode.Duration);
                DamageMaterial.SetScalarParameterValue('Mining_Time', TotalMiningTime / CurrentMiningNode.Duration * 0.800000012);
                AudioComponent.SetWwiseRTPC("mining_progress", TotalMiningTime / CurrentMiningNode.Duration);
            }
            else if (TimeToFlashMiningIndicator > 0.0)
            {
                TimeToFlashMiningIndicator -= DeltaTime;
                TimeToNextMiningFlash -= DeltaTime;
                DamageMaterial.SetScalarParameterValue('mining_color', MiningIndicatorColor);
                if (TimeToNextMiningFlash <= 0.0)
                {
                    DamageMaterial.SetScalarParameterValue('Mining_Time', 0.0);
                    TimeToNextMiningFlash = MiningFlashDelay;
                }
                else
                {
                    DamageMaterial.SetScalarParameterValue('Mining_Time', TimeToNextMiningFlash / MiningFlashDelay);
                }
            }
            else
            {
                DamageMaterial.SetScalarParameterValue('Mining_Time', 0.0);
            }
        }
        if (Mesh.SkeletalMesh.Materials.Length > 1)
        {
            DamageMaterial = MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[1]);
            if (DamageMaterial != None)
            {
                if (CurrentThrustJuice / MaxThrustJuice < BurnOutPercentage && BurnOutPercentage > 0.0)
                {
                    DamageMaterial.SetScalarParameterValue('Engine_Heat', 1.0 - CurrentThrustJuice / MaxThrustJuice / BurnOutPercentage);
                }
                else
                {
                    DamageMaterial.SetScalarParameterValue('Engine_Heat', 0.0);
                }
            }
        }
    }
    if (fHealthPercent <= 0.75)
    {
    }
    oSkelControl = SkelControlLookAt(Mesh.FindSkelControl('Turret_01'));
    if (oSkelControl != None)
    {
        BPC.GetPlayerViewPoint(CamLoc, CamRot);
        if (BPC != None && AudioComponent != None)
        {
            if (float(CamRot.Pitch) != PreviousCameraPitch)
            {
                if (!AudioComponent.IsPlaying(VehicleTurretMovementStartEventPair.Play))
                {
                    AudioComponent.Play(VehicleTurretMovementStartEventPair);
                }
                AudioComponent.SetWwiseRTPC("turret_movement", float(CamRot.Pitch) - PreviousCameraPitch);
            }
            else if (AudioComponent.IsPlaying(VehicleTurretMovementStartEventPair.Play))
            {
                AudioComponent.Stop(VehicleTurretMovementStartEventPair);
            }
            PreviousCameraPitch = float(CamRot.Pitch);
        }
        oSkelControl.TargetLocation = CamLoc + Normal(Vector(CamRot)) * float(100000);
    }
    if (bWeaponFiring == FALSE && int(Controller.bFire) == 1 && DmgModule.bOwnerIsDead == FALSE)
    {
        StartFire(0);
    }
    else if (bWeaponFiring && int(Controller.bFire) == 0)
    {
        StopFire(0);
    }
    if (m_oMiningVFXTemplate != None)
    {
        if (int(BPC.bMine) != 0 && bVehicleOnGround == TRUE)
        {
            if (MiningPSC != None && !MiningPSC.bIsActive)
            {
                MiningPSC.SetTemplate(m_oMiningVFXTemplate);
                MiningPSC.SetAbsolute(FALSE, FALSE, FALSE);
                MiningPSC.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
                MiningPSC.SetTranslation(vect(100.0, 0.0, -200.0));
                MiningPSC.ActivateSystem();
            }
        }
        else if (MiningPSC != None)
        {
            MiningPSC.DeactivateSystem();
        }
    }
    if (int(BPC.bMine) != 0 && bMiningFailed == FALSE && (CurrentMiningNode == None || CurrentMiningNode.bAlreadyMined == FALSE))
    {
        if (!AudioComponent.IsPlaying(VehicleMiningEventPair))
        {
            AudioComponent.Play(VehicleMiningEventPair);
        }
        if (CurrentMiningNode == None)
        {
            foreach AllActors(Class'SFXMiningNode', Node, )
            {
                if (VSize(Node.location - location) <= Node.Radius)
                {
                    if (Node != CurrentMiningNode)
                    {
                        TimeToNextMiningImpulse = 0.0;
                        TotalMiningTime = 0.0;
                        CurrentMiningNode = Node;
                        break;
                    }
                }
            }
        }
        if (CurrentMiningNode == None || bVehicleOnGround != TRUE || VSize(CurrentMiningNode.location - location) > CurrentMiningNode.Radius && TotalMiningTime > float(0))
        {
            for (idx = 0; idx < CurrentMiningNode.GeneratedEvents.Length; idx++)
            {
                FailureEvent = SFXSeqEvt_VehicleMiningFailure(CurrentMiningNode.GeneratedEvents[idx]);
                if (FailureEvent != None)
                {
                    FailureEvent.CheckActivate(CurrentMiningNode, CurrentMiningNode);
                }
            }
            AudioComponent.Play(VehicleMiningFailureEvent);
            CurrentMiningNode = None;
            TotalMiningTime = 0.0;
            TimeToNextMiningImpulse = 0.0;
            bMiningFailed = TRUE;
            MiningFeedbackWaveForm.Samples[0].Duration = 1.0;
            BPC.ClientPlayForceFeedbackWaveform(MiningFeedbackWaveForm);
            TimeToFlashMiningIndicator = MiningFlashDuration;
            MiningIndicatorColor = 2.0;
            BPC.bMine = 0;
        }
        else if (CurrentMiningNode != None && CurrentMiningNode.bAlreadyMined != TRUE)
        {
            AudioComponent.SetWwiseRTPC("distance_to_node", VSize(CurrentMiningNode.location - location) / CurrentMiningNode.Radius);
            if (TotalMiningTime == float(0))
            {
                TimeToNextMiningImpulse = FRand() * (CurrentMiningNode.ImpulseMaxFrequency - CurrentMiningNode.ImpulseMinFrequency) + CurrentMiningNode.ImpulseMinFrequency;
            }
            TimeToNextMiningImpulse -= DeltaTime;
            TotalMiningTime += DeltaTime;
            if (TotalMiningTime > CurrentMiningNode.Duration)
            {
                MiningFeedbackWaveForm.Samples[0].Duration = 2.0;
                BPC.ClientPlayForceFeedbackWaveform(MiningFeedbackWaveForm);
                CurrentMiningNode.bAlreadyMined = TRUE;
                MiningIndicatorColor = 0.0;
                TimeToFlashMiningIndicator = MiningFlashDuration;
                CurrentMiningNode.PSC_GroundReticle.DeactivateSystem();
                BPC.bMine = 0;
                for (idx = 0; idx < CurrentMiningNode.GeneratedEvents.Length; idx++)
                {
                    SuccessEvent = SFXSeqEvt_VehicleMiningSuccess(CurrentMiningNode.GeneratedEvents[idx]);
                    if (SuccessEvent != None)
                    {
                        SuccessEvent.CheckActivate(CurrentMiningNode, CurrentMiningNode);
                    }
                }
                AudioComponent.Play(VehicleMiningSuccessEvent);
            }
            else if (TimeToNextMiningImpulse <= float(0))
            {
                RandomRotation.Yaw = int(FRand() * float(65536));
                RandomImpulse.X = FRand() * (CurrentMiningNode.ImpulseMaxStrength - CurrentMiningNode.ImpulseMinStrength) + CurrentMiningNode.ImpulseMinStrength;
                MiningFeedbackWaveForm.Samples[0].LeftAmplitude = byte(RandomImpulse.X / CurrentMiningNode.ImpulseMaxStrength * 100.0);
                MiningFeedbackWaveForm.Samples[0].RightAmplitude = byte(RandomImpulse.X / CurrentMiningNode.ImpulseMaxStrength * 100.0);
                RandomImpulse.Y = 0.0;
                RandomImpulse.Z = 0.0;
                RandomImpulse = QuatRotateVector(QuatFromRotator(RandomRotation), RandomImpulse);
                Mesh.AddImpulse(RandomImpulse);
                TimeToNextMiningImpulse = FRand() * (CurrentMiningNode.ImpulseMaxFrequency - CurrentMiningNode.ImpulseMinFrequency) + CurrentMiningNode.ImpulseMinFrequency;
                MiningFeedbackWaveForm.Samples[0].Duration = TimeToNextMiningImpulse;
                BPC.ClientPlayForceFeedbackWaveform(MiningFeedbackWaveForm);
            }
        }
    }
    else
    {
        if (AudioComponent.IsPlaying(VehicleMiningEventPair))
        {
            AudioComponent.Stop(VehicleMiningEventPair);
        }
        if (CurrentMiningNode != None)
        {
            CurrentMiningNode = None;
            TotalMiningTime = 0.0;
        }
        if (int(BPC.bMine) == 0)
        {
            bMiningFailed = FALSE;
        }
    }
}
public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    StopFiring();
    if (AudioComponent != None)
    {
        AudioComponent.Stop(VehicleMotorEventPair);
    }
    SetHidden(TRUE);
    SetPhysics(0);
    return BioPawn(Driver).Squad.Died(Self, Killer);
}
public final simulated function bool IsPendingFire(byte InFiringMode)
{
    return InvManager != None && InvManager.IsPendingFire(None, int(InFiringMode));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
        TargetBoneName = 'Chassis'
        UseTargetBoneAsOrigin = TRUE
    End Object
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=ForceFeedbackWaveform Name=ThrustShakeFF0
        Samples = ({Duration = 0.100000001, LeftAmplitude = 20, RightAmplitude = 20, LeftFunction = EWaveformFunction.WF_LinearDecreasing, RightFunction = EWaveformFunction.WF_LinearDecreasing}
                  )
    End Object
    Begin Object Class=ParticleSystemComponent Name=AfterburnerPSC_0
        bAutoActivate = FALSE
        bUpdateComponentInTick = TRUE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=AfterburnerPSC_1
        bAutoActivate = FALSE
        bUpdateComponentInTick = TRUE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=MiningPSC_0
        bAutoActivate = FALSE
        bUpdateComponentInTick = TRUE
        ReplacementPrimitive = None
    End Object
    Begin Template Class=RB_ConstraintInstance Name=MyStayUprightConstraintInstance_0
    End Template
    Begin Template Class=RB_StayUprightSetup Name=MyStayUprightSetup_0
    End Template
    Begin Object Class=SFXVehicleSimHover Name=SimObject
        MaxThrustForce = 650.0
        MaxReverseForce = 600.0
        LongDamping = 0.800000012
        MaxStrafeForce = 650.0
        LatDamping = 0.800000012
        DirectionChangeForce = 500.0
        UpDamping = 0.100000001
        TurnTorqueFactor = 20000.0
        TurnTorqueMax = 10000.0
        TurnDamping = 1.0
        MaxYawRate = 75000.0
        PitchTorqueFactor = 200.0
        PitchTorqueMax = 18.0
        PitchDamping = 0.100000001
        RollTorqueTurnFactor = 1000.0
        RollTorqueStrafeFactor = 110.0
        RollTorqueMax = 500.0
        RollDamping = 0.800000012
        MaxRandForce = 20.0
        RandForceInterval = 0.400000006
        bAllowZThrust = TRUE
        WheelSuspensionStiffness = 20.0
        WheelSuspensionDamping = 1.0
    End Object
    Begin Template Class=SkeletalMeshComponent Name=SVehicleMesh
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Object Class=SVehicleWheel Name=LFWheel
        BoneOffset = {X = 0.0, Y = -50.0, Z = 0.0}
        SkelControlName = 'Wheel_01'
        BoneName = 'Wheel_05'
        SteerFactor = 1.0
        WheelRadius = 130.0
        SuspensionTravel = 145.0
        SuspensionSpeed = 0.0
        LongSlipFactor = 0.0
        LatSlipFactor = 0.0
        HandbrakeLongSlipFactor = 0.0
        HandbrakeLatSlipFactor = 0.0
        bHoverWheel = TRUE
    End Object
    Begin Object Class=SVehicleWheel Name=LRWheel
        BoneOffset = {X = 0.0, Y = -50.0, Z = 0.0}
        SkelControlName = 'Wheel_02'
        BoneName = 'Wheel_02'
        SteerFactor = 1.0
        WheelRadius = 130.0
        SuspensionTravel = 145.0
        SuspensionSpeed = 0.0
        LongSlipFactor = 0.0
        LatSlipFactor = 0.0
        HandbrakeLongSlipFactor = 0.0
        HandbrakeLatSlipFactor = 0.0
        bHoverWheel = TRUE
    End Object
    Begin Object Class=SVehicleWheel Name=RFWheel
        BoneOffset = {X = 0.0, Y = 50.0, Z = 0.0}
        SkelControlName = 'Wheel_04'
        BoneName = 'Wheel_06'
        SteerFactor = 1.0
        WheelRadius = 130.0
        SuspensionTravel = 145.0
        SuspensionSpeed = 0.0
        LongSlipFactor = 0.0
        LatSlipFactor = 0.0
        HandbrakeLongSlipFactor = 0.0
        HandbrakeLatSlipFactor = 0.0
        bHoverWheel = TRUE
    End Object
    Begin Object Class=SVehicleWheel Name=RRWheel
        BoneOffset = {X = 0.0, Y = 50.0, Z = 0.0}
        SkelControlName = 'Wheel_03'
        BoneName = 'Wheel_03'
        SteerFactor = 1.0
        WheelRadius = 130.0
        SuspensionTravel = 145.0
        SuspensionSpeed = 0.0
        LongSlipFactor = 0.0
        LatSlipFactor = 0.0
        HandbrakeLongSlipFactor = 0.0
        HandbrakeLatSlipFactor = 0.0
        bHoverWheel = TRUE
    End Object
    JumpForce = {X = 200.0, Y = 0.0, Z = 2070.0}
    BoostForce = {X = 1000.0, Y = 0.0, Z = 0.0}
    OffGroundForce = {X = 0.0, Y = 0.0, Z = -400.0}
    MaxThrustJuice = 0.600000024
    ThrustRegenerationFactor = 0.550000012
    ThrustFeedback = ThrustShakeFF0
    OnGroundJumpMultiplier = 1.0
    ForwardThrustBurnRate = 0.100000001
    VerticalThrustBurnRate = 1.0
    ThrustRegenerationDelay = 0.5
    BurnOutPercentage = 0.200000003
    SelfRepairDelay = 5.0
    SelfRepairRate = 100.0
    HitDamage = 350.0
    MaxPitchAngle = 32.0
    MiningPSC = MiningPSC_0
    LeftAfterburnerPSC = AfterburnerPSC_0
    RightAfterburnerPSC = AfterburnerPSC_1
    LightEnvironment = BioLightEnvComponent0
    RadarRange = 10000.0
    RadarFOV = 45.0
    bAudioXBoostEventStopped = TRUE
    bAudioZBoostEventStopped = TRUE
    bTurrentMovementSoundStopped = TRUE
    Wheels = (LFWheel, LRWheel, RRWheel, RFWheel)
    SimObj = SimObject
    StayUprightConstraintSetup = MyStayUprightSetup_0
    StayUprightConstraintInstance = MyStayUprightConstraintInstance_0
    Mesh = SVehicleMesh
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder, SVehicleMesh, SimObject, BioLightEnvComponent0, MiningPSC_0, AfterburnerPSC_0, AfterburnerPSC_1)
    CollisionComponent = SVehicleMesh
}