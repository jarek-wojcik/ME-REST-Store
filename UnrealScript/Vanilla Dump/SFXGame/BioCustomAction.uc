Class BioCustomAction
    native
    abstract
    config(Game);

enum ECustomActionPriority
{
    CA_Priority_None,
    CA_Priority_Low,
    CA_Priority_Medium,
    CA_Priority_High,
    CA_Priority_SuperHigh,
};

var array<Class<BioCustomAction>> OverrideList;
var Class<SFXAICmd_CustomAction> AICommand;
var Class<SFXCameraMode> PlayerCameraMode;
var const Vector PreciseDestination;
var const Rotator PreciseRotation;
var BioPawn m_oPawn;
var SFXPlayerController m_oPC;
var SFXAI_Core m_oAI;
var(Info) config float SpeedModifier;
var(Info) float GravityScale;
var float MoveSpeed;
var transient float LastCanDoCustomActionTime;
var transient float LastFinishedTime;
var const float MinTimeBetweenActions;
var const float PreciseRotationInterpolationTime;
var float DamageReductionLength;
var float DamageReductionAmount;
var transient SFXCameraMode oPlayerCamera;
var const float fCameraTransitionIn;
var const float fCameraTransitionOut;
var transient SFXTimelineData CurrentTimeline;
var const config float CheckMoveMaximumVelocitySq;
var(Info) export SFXTimelineData TimelineTemplate;
var(Info) export SFXTimelineData ImpactTimeline;
var const bool bLockPawnRotation;
var const bool bBreakFromCover;
var const bool bDisableMovement;
var const bool bDisableLook;
var const bool bDisableCollision;
var const bool bDisablePhysics;
var const bool bDisableLeftHandIK;
var const bool bIgnoreDamage;
var const bool bHideWeapon;
var const bool bNotifyKnockedOutOfCover;
var const bool bTurnOffZoom;
var const bool bTurnOffReticle;
var const bool bDisableShooting;
var const bool bAllowChargeHolding;
var const bool bDisableAiming;
var const bool bDisableCoverAdjust;
var const bool bDisableUse;
var const bool bDisableCustomActionQueuing;
var const bool bBlockingAction;
var const bool bProceduralMovement;
var bool bLockRotationAfterPreciseRotation;
var const bool bCameraFocusOnPawn;
var bool bLastCanDoCustomAction;
var bool bIgnoreInputForCustomAction;
var const bool bReachPreciseDestination;
var const bool bReachedPreciseDestination;
var const bool bReachPreciseRotation;
var const bool bReachedPreciseRotation;
var bool bStartedCustomAction;
var bool bAllowDamageReduction;
var const bool bPushAICommand;
var bool bReplicateCustomAction;
var bool bClientPredictCustomAction;
var bool bForceLocalSimulation;
var const bool bCreatesGibs;
var const ECustomActionPriority Priority;
var ESFXVocalizationEventID VocalizationEvent;
var ENetRole OriginalRole;
var ENetRole OriginalRemoteRole;
var transient byte RandomReactionRolled;

public function AnimNotify(AnimNodeSequence SeqNode, BioAnimNotify_CustomAction NotifyObject);

public final function bool CanDoCustomAction(optional Pawn SyncPawn, optional bool bForced)
{
    if (m_oPawn != None && (m_oPawn.WorldInfo.GameTimeSeconds - LastFinishedTime >= MinTimeBetweenActions || bForced))
    {
        if (m_oPawn.WorldInfo.GameTimeSeconds != LastCanDoCustomActionTime)
        {
            bLastCanDoCustomAction = InternalCanDoCustomAction(BioPawn(SyncPawn), bForced);
            LastCanDoCustomActionTime = m_oPawn.WorldInfo.GameTimeSeconds;
        }
        return bLastCanDoCustomAction;
    }
    return FALSE;
}
public final native function ForcePawnRotation(Pawn P, Rotator NewRotation);

public simulated native function Vector GetBasedPosition(out BasedPosition BP);

public native function bool GetFloorLocation(Vector vStartLocation, out Vector vFloorLocation);

public static event function GetUsedAnimNames(out array<Name> UsedAnims);

public function bool NotifyBump(Actor Other, Vector HitNormal);

public function bool NotifyHitWall(Vector HitNormal, Actor Wall);

public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Class'SFXModule_Timeline'.static.PrecacheVFX(ObjectPool, ClientEffects, default.TimelineTemplate);
    Class'SFXModule_Timeline'.static.PrecacheVFX(ObjectPool, ClientEffects, default.ImpactTimeline);
    ClientEffects.PrimeClass(default.Class);
}
public event function ReachedPrecisePosition();

public final native function Vector RelativeToWorldOffset(Rotator InRotation, Vector RelativeSpaceOffset);

public final native function ResetFacePreciseRotation();

public final native function ResetReachPreciseDestination();

public function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta);

public function RootMotionModeChanged(SkeletalMeshComponent SkelComp);

public simulated native function SetBasedPosition(out BasedPosition BP, Vector inLoc);

public final native function SetFacePreciseRotation(Rotator RotationToFace, float InterpolationTime);

public final native function SetReachPreciseDestination(Vector DestinationToReach);

public function StartCustomAction()
{
    local SFXModule_GameEffectManager GEManager;
    local Weapon Weap;
    
    if (m_oPawn == None)
    {
        return;
    }
    if (m_oPC != None)
    {
        if (bDisableMovement)
        {
            m_oPC.IgnoreMoveInput(TRUE);
        }
        if (bDisableLook)
        {
            m_oPC.IgnoreLookInput(TRUE);
        }
        if (bTurnOffZoom)
        {
            m_oPC.SetZoomed(FALSE);
        }
        if (bTurnOffReticle)
        {
            m_oPC.GameModeManager2.HideReticle();
        }
        if (bAllowDamageReduction)
        {
            GEManager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
            if (GEManager != None)
            {
                GEManager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', 'CADamageReduction', DamageReductionLength, 1, -DamageReductionAmount, m_oPawn.Controller);
            }
        }
    }
    if (bDisableCoverAdjust)
    {
        m_oPawn.bDisableCoverAdjust = TRUE;
    }
    if (bBreakFromCover)
    {
        if (m_oAI != None)
        {
            if (m_oPawn.IsInCover())
            {
                m_oAI.InvalidateCover();
                if (bNotifyKnockedOutOfCover)
                {
                    m_oAI.NotifyKnockedOutOfCover();
                }
            }
        }
        else if (m_oPC != None)
        {
            m_oPC.LeaveCover();
        }
        else if (bForceLocalSimulation)
        {
            m_oPawn.LeaveCover();
        }
        m_oPawn.SetCrouchStateInstantly(FALSE);
    }
    if (!m_oPawn.bIsAPlayer)
    {
        if (bLockPawnRotation)
        {
            m_oPawn.LockDesiredRotation(FALSE);
            m_oPawn.SetDesiredRotation(m_oPawn.Rotation, TRUE, FALSE, 0.0);
        }
    }
    if (bDisableMovement)
    {
        m_oPawn.Acceleration = vect(0.0, 0.0, 0.0);
    }
    if (bDisableCollision)
    {
        TogglePawnCollision(m_oPawn, FALSE);
    }
    if (bDisablePhysics)
    {
        m_oPawn.SetPhysics(0);
        m_oPawn.LastPhysicsSetter = Self;
    }
    if (bIgnoreDamage)
    {
        m_oPawn.bCanBeDamaged = FALSE;
    }
    if (bDisableShooting)
    {
        m_oPawn.bNoWeaponFiring = TRUE;
    }
    if (bHideWeapon && m_oPawn.Weapon != None)
    {
        if (SFXWeapon(m_oPawn.Weapon) != None)
        {
            SFXWeapon(m_oPawn.Weapon).SetWeaponHidden(TRUE);
        }
    }
    if (bDisableLeftHandIK)
    {
        m_oPawn.DisableLeftHandIK();
    }
    if (VocalizationEvent != ESFXVocalizationEventID.SFXVocalizationEvent_None && SFXGRI(m_oPawn.WorldInfo.GRI) != None)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(VocalizationEvent, m_oPawn, None, 0.0);
    }
    m_oPawn.bPortArmsEnabled = FALSE;
    if (ShouldReplicate() == TRUE)
    {
        Replicate();
    }
    if (bForceLocalSimulation)
    {
        if (OriginalRole == ENetRole.ROLE_None)
        {
            OriginalRole = m_oPawn.Role;
            OriginalRemoteRole = m_oPawn.RemoteRole;
            switch (OriginalRole)
            {
                case ENetRole.ROLE_Authority:
                    if (OriginalRemoteRole != ENetRole.ROLE_None)
                    {
                        m_oPawn.RemoteRole = ENetRole.ROLE_SimulatedProxy;
                        if (m_oPC != None)
                        {
                            m_oPC.ClearServerMoveExtrapolation();
                        }
                    }
                    m_oPawn.bReplicateMovement = FALSE;
                    m_oPawn.bSkipActorPropertyReplication = TRUE;
                    m_oPawn.bSkipPawnPropertyReplication = TRUE;
                    break;
                case ENetRole.ROLE_AutonomousProxy:
                    break;
                case ENetRole.ROLE_SimulatedProxy:
                    m_oPawn.Role = ENetRole.ROLE_AutonomousProxy;
                    m_oPawn.bRunPhysicsWithNoController = TRUE;
                    m_oPawn.SetDesiredSpeed(1.0);
                    m_oPawn.LockDesiredRotation(FALSE);
                    if (!bReachPreciseRotation)
                    {
                        m_oPawn.SetDesiredRotation(m_oPawn.Rotation);
                    }
                    Weap = m_oPawn.Weapon;
                    if (Weap != None)
                    {
                        Weap.StopFireEffects(Weap.CurrentFireMode);
                    }
                    break;
                default:
                    return;
            }
        }
    }
    bStartedCustomAction = TRUE;
}
public event function TickCustomAction(float DeltaTime);

public final native function Vector WorldToRelativeOffset(Rotator InRotation, Vector WorldSpaceOffset);

public function ApplyTimeline(SFXTimelineData Timeline, optional Actor Source, optional Actor Target)
{
    local SFXModule_Timeline TimeMod;
    
    TimeMod = m_oPawn.GetModule(Class'SFXModule_Timeline');
    if (TimeMod != None && Timeline != None)
    {
        if (CurrentTimeline != None)
        {
            CurrentTimeline = None;
        }
        CurrentTimeline = TimeMod.SpawnTimeline(Timeline, Self, Source, Target);
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    EndThisCustomAction();
}
public function bool CanBeInterrupted()
{
    return TRUE;
}
public function bool CanInteractWithPawn(BioPawn OtherPawn)
{
    return FALSE;
}
public function bool CanOverrideCustomAction(int OldCustomAction, int InCustomAction)
{
    return FALSE;
}
public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    local int idx;
    local Class<BioCustomAction> NewClass;
    local Class<BioCustomAction> OldClass;
    
    OldClass = GetCustomActionClass(OldCustomAction);
    NewClass = GetCustomActionClass(NewCustomAction);
    if (NewClass != None && OldClass != None)
    {
        if (NewClass.default.Priority != ECustomActionPriority.CA_Priority_None && int(NewClass.default.Priority) > int(OldClass.default.Priority))
        {
            return TRUE;
        }
        for (idx = 0; idx < OverrideList.Length; idx++)
        {
            if (ClassIsChildOf(NewClass, OverrideList[idx]))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function CheckMoving()
{
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(m_oPawn.WorldInfo);
    if (BWI != None && BWI.GetAutoBotsEnabled() == TRUE)
    {
        if (BioCheatManagerNonNative(BWI.GetLocalPlayerController().CheatManager) != None)
        {
            if (BioCheatManagerNonNative(BWI.GetLocalPlayerController().CheatManager).MPBotsGetUsedLastPawn() == m_oPawn)
            {
                return;
            }
        }
    }
    if (VSizeSq(m_oPawn.Velocity) > CheckMoveMaximumVelocitySq)
    {
        m_oPawn.ClearTimer('CheckMoving', Self);
        InterruptThisCustomAction();
    }
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        m_oPawn.StartCustomAction(m_oPawn.ReplicatedCustomActionInfo.CustomActionType, BioPawn(m_oPawn.ReplicatedCustomActionInfo.Target), bForced, m_oPawn.ReplicatedCustomActionInfo.PowerCustomActionType);
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType);

public function ContinueCustomAction();

public function EndThisCustomAction()
{
    if (m_oPawn != None)
    {
        m_oPawn.EndCustomAction();
    }
}
public static final function GetAnimsUsedByBodyStance(BodyStance Stance, out array<Name> UsedAnims)
{
    local Name CurrentName;
    
    foreach Stance.AnimName(CurrentName, )
    {
        if (CurrentName != 'None' && UsedAnims.Find(CurrentName) == -1)
        {
            UsedAnims.AddItem(CurrentName);
        }
    }
}
public function bool GetCustomActionCamera(out SFXCameraMode oNewCameraMode, out float fTransitionIn, out float fTransitionOut)
{
    if (m_oPC != None && PlayerCameraMode != None)
    {
        if (oPlayerCamera == None)
        {
            oPlayerCamera = new (m_oPC.GetGameModeDefault()) PlayerCameraMode;
        }
        oNewCameraMode = oPlayerCamera;
        fTransitionIn = fCameraTransitionIn;
        fTransitionOut = fCameraTransitionOut;
        return TRUE;
    }
    return FALSE;
}
public function Class<BioCustomAction> GetCustomActionClass(int CustomAction)
{
    if (CustomAction == 0 || m_oPawn == None)
    {
        return None;
    }
    if (CustomAction == 132)
    {
        return Class'SFXPowerCustomAction';
    }
    if (CustomAction < m_oPawn.CustomActionClasses.Length)
    {
        return m_oPawn.CustomActionClasses[CustomAction];
    }
    return None;
}
public function BioPawn GetVictimPawn()
{
    return None;
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    return TRUE;
}
public function InterruptThisCustomAction()
{
    if (m_oPawn != None && m_oPawn.IsLocallyControlled() && m_oPawn.Role == ENetRole.ROLE_AutonomousProxy)
    {
        m_oPawn.ServerInterruptCustomAction(m_oPawn.CurrentCustomAction, m_oPawn.CurrentPowerCustomAction);
    }
    else if (ShouldReplicate())
    {
        ReplicateInterrupt();
    }
    EndThisCustomAction();
}
public function bool MessageEvent(Name EventName, Object Sender)
{
    return FALSE;
}
public function MoveToOffset(out Vector MoveOffset)
{
    local Vector OffsetWorldLocation;
    
    OffsetWorldLocation = m_oPawn.location + RelativeToWorldOffset(m_oPawn.Rotation, MoveOffset);
    SetReachPreciseDestination(OffsetWorldLocation);
}
public function OnTimelineImpact(Actor Target)
{
    if (ShouldReplicate())
    {
        ReplicateImpact(BioPawn(Target));
    }
}
public function PauseCustomAction();

public function PawnLeftCover();

public function RemoveTimeline()
{
    local SFXModule_Timeline TimeMod;
    
    TimeMod = m_oPawn.GetModule(Class'SFXModule_Timeline');
    if (TimeMod != None)
    {
        if (CurrentTimeline != None)
        {
            TimeMod.RemoveTimeline(CurrentTimeline);
            CurrentTimeline = None;
        }
    }
}
public function Replicate()
{
    if (m_oPawn != None)
    {
        if (m_oPawn.PreviousCustomAction == 0)
        {
            m_oPawn.ReplicatedCustomActionInfo.Cmd = EReplicatedCustomActionCmd.eRCACmd_Start;
        }
        else
        {
            m_oPawn.ReplicatedCustomActionInfo.Cmd = EReplicatedCustomActionCmd.eRCACmd_Override;
        }
        m_oPawn.ReplicatedCustomActionInfo.TriggerCounter++;
        m_oPawn.ReplicatedCustomActionInfo.CustomActionType = m_oPawn.CurrentCustomAction;
        m_oPawn.ReplicatedCustomActionInfo.Target = None;
        m_oPawn.ReplicatedCustomActionInfo.PowerCustomActionType = m_oPawn.CurrentPowerCustomAction;
        m_oPawn.bReplicateCustomActionInfoToOwner = !bClientPredictCustomAction;
        m_oPawn.bForceNetUpdate = TRUE;
    }
}
public function ReplicateImpact(BioPawn Target, optional int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    if (Target != None && m_oPawn != None)
    {
        Target.AcquireReplicatedCustomActionImpact();
        Target.ReplicatedCustomActionImpactInfo.TriggerCounter++;
        Target.ReplicatedCustomActionImpactInfo.CustomActionType = m_oPawn.CurrentCustomAction;
        Target.ReplicatedCustomActionImpactInfo.Instigator = m_oPawn;
        Target.ReplicatedCustomActionImpactInfo.ImpactCount = ImpactCount;
        Target.ReplicatedCustomActionImpactInfo.bFirstTarget = bFirstTarget;
        Target.ReplicatedCustomActionImpactInfo.HitLocation = HitLocation;
        Target.ReplicatedCustomActionImpactInfo.HitNormal = HitNormal;
        Target.ReplicatedCustomActionImpactInfo.CustomActionReactionType = CustomActionReactionType;
        Target.ReplicatedCustomActionImpactInfo.PowerCustomActionType = m_oPawn.CurrentPowerCustomAction;
        Target.ReleaseReplicatedCustomActionImpact();
    }
}
public function ReplicateInterrupt()
{
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.Cmd = EReplicatedCustomActionCmd.eRCACmd_Interrupt;
        m_oPawn.ReplicatedCustomActionInfo.TriggerCounter++;
        m_oPawn.ReplicatedCustomActionInfo.CustomActionType = m_oPawn.CurrentCustomAction;
        m_oPawn.ReplicatedCustomActionInfo.Target = None;
        m_oPawn.ReplicatedCustomActionInfo.PowerCustomActionType = m_oPawn.CurrentPowerCustomAction;
        m_oPawn.bReplicateCustomActionInfoToOwner = !bClientPredictCustomAction;
        m_oPawn.bForceNetUpdate = TRUE;
    }
}
public final function RotatePlayerCamToFace(Vector AimPoint, float fTimeToRotate)
{
    local SFXPlayerCamera PlayerCam;
    local SFXCameraTransition_FaceTarget FaceTarget;
    
    if (m_oPC != None)
    {
        PlayerCam = SFXPlayerCamera(m_oPC.PlayerCamera);
        if (PlayerCam != None)
        {
            FaceTarget = new (m_oPC.GetGameModeDefault()) Class'SFXCameraTransition_FaceTarget';
            FaceTarget.TargetLocation = AimPoint;
            PlayerCam.PlayCameraTransition(FaceTarget, fTimeToRotate);
        }
    }
}
public final function RotatePlayerCamToFutureDirection(Vector DestPawnLoc, Vector DesiredRotation, float TimeToRotate)
{
    local SFXPlayerCamera Cam;
    local Vector CamOffset;
    local Vector NewCamLoc;
    local SFXCameraMode_Interpolate NewCamTransition;
    local Rotator NewRotation;
    
    if (m_oPC != None)
    {
        Cam = SFXPlayerCamera(m_oPC.PlayerCamera);
        if (Cam != None && Cam.CurrentCameraMode.GetActorCameraHook(CamOffset))
        {
            CamOffset = CamOffset - m_oPawn.location;
            NewCamLoc = DestPawnLoc + CamOffset;
            Cam.FaceTargetTransition.TargetLocation = NewCamLoc + DesiredRotation * 1000.0;
            Cam.CurrentCameraMode.LastHookPos = NewCamLoc;
            NewCamTransition = Cam.SetBehavior(Cam.CurrentCameraMode, Cam.FaceTargetTransition, TimeToRotate, FALSE);
            NewRotation = Rotator(DesiredRotation);
            m_oPC.SetRotation(NewRotation);
            NewCamTransition.To.m_pov.Rotation = NewRotation;
            Cam.bCurrentTransitionIsModal = TRUE;
        }
    }
}
public function ServerStartCustomAction(int NewAction, optional BioPawn Sync, optional int NewPowerAction)
{
    local BioPlayerController PC;
    
    if (m_oPawn != None)
    {
        PC = BioPlayerController(m_oPawn.Controller);
        if (PC != None)
        {
            PC.ServerStartCustomAction(NewAction, Sync, NewPowerAction);
        }
    }
}
public function bool ShouldReplicate()
{
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        return bReplicateCustomAction;
    }
    return FALSE;
}
public function StopCustomAction()
{
    local SFXModule_GameEffectManager GEManager;
    
    if (m_oPawn == None)
    {
        return;
    }
    if (m_oPC != None)
    {
        if (bDisableMovement)
        {
            m_oPC.IgnoreMoveInput(FALSE);
        }
        if (bDisableLook)
        {
            m_oPC.IgnoreLookInput(FALSE);
        }
        if (bTurnOffReticle)
        {
            m_oPC.GameModeManager2.ResetReticles();
        }
    }
    else if (!m_oPawn.bIsAPlayer)
    {
        if (bLockPawnRotation || bLockRotationAfterPreciseRotation)
        {
            m_oPawn.LockDesiredRotation(FALSE);
        }
    }
    if (bDisableCoverAdjust)
    {
        m_oPawn.bDisableCoverAdjust = FALSE;
    }
    if (bDisableCollision)
    {
        TogglePawnCollision(m_oPawn, TRUE);
    }
    if (bDisablePhysics && m_oPawn.LastPhysicsSetter == Self)
    {
        m_oPawn.SetPhysics(2);
    }
    if (bIgnoreDamage)
    {
        m_oPawn.bCanBeDamaged = TRUE;
    }
    if (bHideWeapon && m_oPawn.Weapon != None)
    {
        if (SFXWeapon(m_oPawn.Weapon) != None)
        {
            SFXWeapon(m_oPawn.Weapon).SetWeaponHidden(FALSE);
        }
    }
    if (bDisableLeftHandIK)
    {
        m_oPawn.EnableLeftHandIK();
    }
    if (bDisableShooting)
    {
        m_oPawn.bNoWeaponFiring = m_oPawn.default.bNoWeaponFiring;
    }
    if (bAllowDamageReduction)
    {
        GEManager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (GEManager != None)
        {
            GEManager.RemoveEffectsByCategory('CADamageReduction');
        }
    }
    m_oPawn.bPortArmsEnabled = TRUE;
    m_oPawn.DelayedPortArmsTimeAccumulator = 0.0;
    LastFinishedTime = m_oPawn.WorldInfo.GameTimeSeconds;
    if (bForceLocalSimulation)
    {
        if (OriginalRole != ENetRole.ROLE_None)
        {
            switch (OriginalRole)
            {
                case ENetRole.ROLE_Authority:
                    if (!m_oPawn.bUseDeltaReplication)
                    {
                        m_oPawn.bReplicateMovement = m_oPawn.default.bReplicateMovement;
                    }
                    else
                    {
                        m_oPawn.bReplicateMovement = FALSE;
                    }
                    m_oPawn.bSkipActorPropertyReplication = m_oPawn.default.bSkipActorPropertyReplication;
                    m_oPawn.bSkipPawnPropertyReplication = m_oPawn.default.bSkipPawnPropertyReplication;
                    m_oPawn.RemoteRole = OriginalRemoteRole;
                    break;
                case ENetRole.ROLE_AutonomousProxy:
                    break;
                case ENetRole.ROLE_SimulatedProxy:
                    m_oPawn.bRunPhysicsWithNoController = m_oPawn.default.bRunPhysicsWithNoController;
                    if (m_oPawn.Role == ENetRole.ROLE_AutonomousProxy)
                    {
                        m_oPawn.Role = OriginalRole;
                    }
                    break;
                default:
                    break;
            }
            OriginalRole = ENetRole.ROLE_None;
            OriginalRemoteRole = ENetRole.ROLE_None;
        }
    }
    bForceLocalSimulation = default.bForceLocalSimulation;
    bStartedCustomAction = FALSE;
}
public function TickInput(BioPlayerInput Input, float DeltaTime);

public final function TogglePawnCollision(BioPawn aPawn, bool bToggleOn)
{
    if (bToggleOn)
    {
        if (aPawn.bCollideWorld != aPawn.default.bCollideWorld || aPawn.bBlockActors != aPawn.default.bBlockActors)
        {
            aPawn.SetCollision(aPawn.bCollideActors, aPawn.default.bBlockActors, );
            aPawn.bCollideWorld = aPawn.default.bCollideWorld;
            aPawn.FitCollision();
        }
    }
    else
    {
        aPawn.SetCollision(aPawn.bCollideActors, FALSE, );
        aPawn.bCollideWorld = FALSE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen')
    AICommand = Class'SFXAICmd_CustomAction'
    GravityScale = 1.0
    CheckMoveMaximumVelocitySq = 1000.0
    bDisableShooting = TRUE
    bDisableAiming = TRUE
    bBlockingAction = TRUE
    bPushAICommand = TRUE
}