Class SFXCustomAction_SyncPawnInstigator_Base extends BioCustomAction
    native
    abstract
    config(Game);

var(SyncInfo) Vector MarkerOffset;
var const Name SyncActionName;
var float InteractionStartTimeOut;
var BioPawn SyncPartner;
var int PartnerCustomAction;
var float MaxPartnerDistance;
var float SyncCone;
var(SyncInfo) float RotationTime;
var bool bFinishedCustomAction;
var transient bool bHasStartedInteraction;
var(SyncInfo) bool bMoveSyncPawn;
var(SyncInfo) bool bHideTargetWeapon;
var(SyncInfo) bool bAffectsFriendlies;
var(SyncInfo) bool bLockTargetRotation;
var(SyncInfo) bool bDisablePartnerCollisionOnMove;
var(SyncInfo) bool bIgnoreCameraHiding;

public final native function bool CanMoveToMarker(BioPawn SyncPartnerPawn);

public function StartCustomAction()
{
    bFinishedCustomAction = FALSE;
    if (m_oPawn.SyncPawn != None)
    {
        SyncPartner = BioPawn(m_oPawn.SyncPawn);
    }
    Super.StartCustomAction();
    if (SyncPartner != None)
    {
        m_oPawn.SetTimer(InteractionStartTimeOut, FALSE, 'InteractionStartTimedOut', Self);
        CheckReadyToStartInteraction();
    }
    else
    {
        NonSyncedAction();
    }
    if (bDisablePhysics)
    {
        if (SyncPartner != None)
        {
            SyncPartner.SetPhysics(0);
            SyncPartner.LastPhysicsSetter = Self;
        }
    }
    if (bHideTargetWeapon)
    {
        if (SyncPartner != None && SyncPartner.Weapon != None)
        {
            SFXWeapon(SyncPartner.Weapon).SetWeaponHidden(TRUE);
        }
    }
    if (bIgnoreCameraHiding)
    {
        m_oPawn.m_bHideWithCameraCollision = FALSE;
        if (SyncPartner != None)
        {
            SyncPartner.m_bHideWithCameraCollision = FALSE;
        }
    }
}
public function StartInteraction()
{
    bHasStartedInteraction = TRUE;
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function bool CanInteractWithPawn(BioPawn OtherPawn)
{
    local BioCustomAction OtherCustomAction;
    
    if (OtherPawn == None || m_oPawn.CanSyncTarget(OtherPawn, SyncActionName) == FALSE || OtherPawn.IsDead() || OtherPawn.Physics == EPhysics.PHYS_Falling || OtherPawn.Physics == EPhysics.PHYS_RigidBody || bAffectsFriendlies == FALSE && m_oPawn.IsHostile(OtherPawn) == FALSE || OtherPawn.CurrentCustomAction == 3 || OtherPawn.CustomActionClasses[PartnerCustomAction] == None || OtherPawn.GetCurrentCustomAction(OtherCustomAction) && !OtherCustomAction.CanBeInterrupted() || CanMoveToMarker(OtherPawn) == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}
public final function CheckReadyToStartInteraction()
{
    local BioCustomAction oAction;
    
    if (SyncPartner != None)
    {
        if (SyncPartner.CurrentCustomAction != PartnerCustomAction)
        {
            if (bForceLocalSimulation)
            {
                if (SyncPartner.VerifyCAHasBeenInstanced(PartnerCustomAction))
                {
                    oAction = SyncPartner.CustomActions[PartnerCustomAction];
                    oAction.bForceLocalSimulation = TRUE;
                }
                if (bMoveSyncPawn)
                {
                    SyncPartner.SetDesiredSpeed(1.0);
                }
                else
                {
                    m_oPawn.SetDesiredSpeed(1.0);
                }
            }
            SyncPartner.StartCustomAction(PartnerCustomAction, m_oPawn, m_oPawn.Role != ENetRole.ROLE_Authority);
        }
    }
    if (!IsReadyToStartInteraction())
    {
        if (SyncPartner == None)
        {
        }
        m_oPawn.SetTimer(m_oPawn.WorldInfo.DeltaSeconds, FALSE, 'CheckReadyToStartInteraction', Self);
    }
    else
    {
        m_oPawn.ClearTimer('CheckReadyToStartInteraction', Self);
        m_oPawn.ClearTimer('InteractionStartTimedOut', Self);
        SyncPartner.CustomActionMessageEvent('InteractionStarted', m_oPawn);
        StartInteraction();
    }
}
public function ClientMoveToMarkersAllowedDelay()
{
    local BioCustomAction oVictimCustomAction;
    local bool bMustTeleport;
    
    if (SyncPartner != None)
    {
        if (!bMoveSyncPawn)
        {
            bMustTeleport = bReachPreciseDestination && !bReachedPreciseDestination || bReachPreciseRotation && !bReachedPreciseRotation;
        }
        SyncPartner.GetCurrentCustomAction(oVictimCustomAction);
        if (oVictimCustomAction != None)
        {
            if (bMoveSyncPawn)
            {
                bMustTeleport = oVictimCustomAction.bReachPreciseDestination && !oVictimCustomAction.bReachedPreciseDestination || oVictimCustomAction.bReachPreciseRotation && !oVictimCustomAction.bReachedPreciseRotation;
            }
        }
    }
    if (bMustTeleport)
    {
        ClientTeleportToMarkers();
    }
}
public function ClientTeleportToMarkers()
{
    local BioCustomAction oVictimCustomAction;
    
    if (SyncPartner != None)
    {
        if (!bMoveSyncPawn)
        {
            m_oPawn.SafeSetLocation(PreciseDestination);
            m_oPawn.SetRotation(PreciseRotation);
            ReachedPrecisePosition();
            ResetReachPreciseDestination();
            ResetFacePreciseRotation();
        }
        SyncPartner.GetCurrentCustomAction(oVictimCustomAction);
        if (oVictimCustomAction != None)
        {
            SyncPartner.LockDesiredRotation(bLockTargetRotation);
            if (bMoveSyncPawn)
            {
                SyncPartner.SafeSetLocation(oVictimCustomAction.PreciseDestination);
                SyncPartner.SetRotation(oVictimCustomAction.PreciseRotation);
                oVictimCustomAction.ReachedPrecisePosition();
                oVictimCustomAction.ResetReachPreciseDestination();
                oVictimCustomAction.ResetFacePreciseRotation();
            }
        }
    }
}
public function DebugSocketRelativeLocation(Name InSocketName)
{
    local Vector MarkerLoc;
    local Rotator MarkerRot;
    
    m_oPawn.Mesh.GetSocketWorldLocationAndRotation(InSocketName, MarkerLoc, MarkerRot);
    m_oPawn.DrawDebugSphere(MarkerLoc, 4.0, 8, 255, 0, 255, TRUE);
}
public function BioPawn GetVictimPawn()
{
    local BioPawn FoundPawn;
    local bool bInteractionObstructed;
    local Actor HitA;
    local Vector HitLocation;
    local Vector HitNormal;
    
    foreach m_oPawn.VisibleCollidingActors(Class'BioPawn', FoundPawn, MaxPartnerDistance, m_oPawn.location, TRUE, , , , )
    {
        if (FoundPawn != m_oPawn && CanInteractWithPawn(FoundPawn))
        {
            if (Normal(FoundPawn.location - m_oPawn.location) Dot Vector(m_oPawn.Rotation) >= SyncCone)
            {
                if (Abs(FoundPawn.location.Z - m_oPawn.location.Z) < m_oPawn.CylinderComponent.CollisionHeight * 0.800000012 || AIController(m_oPawn.Controller) != None && m_oPawn.ReachedDestination(FoundPawn))
                {
                    bInteractionObstructed = FALSE;
                    foreach m_oPawn.TraceActors(Class'Actor', HitA, HitLocation, HitNormal, FoundPawn.location, m_oPawn.location, vect(32.0, 32.0, 32.0), , )
                    {
                        if (HitA != FoundPawn && HitA.bBlockActors)
                        {
                            bInteractionObstructed = TRUE;
                            break;
                        }
                        else if (HitA == FoundPawn)
                        {
                            break;
                        }
                    }
                    if (!bInteractionObstructed)
                    {
                        return FoundPawn;
                    }
                }
            }
        }
    }
    return None;
}
public function InteractionStartTimedOut()
{
    InterruptThisCustomAction();
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    if (CanInteractWithPawn(SyncPawn) || bForced)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool IsReadyToStartInteraction()
{
    local BioCustomAction pAction;
    
    if (SyncPartner != None && SyncPartner.CurrentCustomAction == PartnerCustomAction)
    {
        SyncPartner.GetCurrentCustomAction(pAction);
        if (pAction != None)
        {
            return pAction.bStartedCustomAction && SFXCustomAction_SyncPawnPartner_Base(pAction).Instigator == m_oPawn;
        }
    }
    return FALSE;
}
public function bool MessageEvent(Name EventName, Object Sender)
{
    if (EventName == 'PartnerLeavingCustomAction')
    {
        OnPartnerLeavingCustomAction();
        return TRUE;
    }
    else if (EventName == 'PartnerReachedDestination')
    {
        OnPartnerReachedDestination();
        return TRUE;
    }
    return Super.MessageEvent(EventName, Sender);
}
public function MoveToMarkers()
{
    local Vector InstigatorDestination;
    local Vector SyncPawnDestination;
    local Vector VectToVictim;
    local BioCustomAction oVictimCustomAction;
    
    if (m_oPawn != None && m_oPawn.Role != ENetRole.ROLE_Authority)
    {
        m_oPawn.SetTimer(InteractionStartTimeOut, FALSE, 'ClientMoveToMarkersAllowedDelay', Self);
    }
    if (SyncPartner != None)
    {
        if (bDisablePartnerCollisionOnMove)
        {
            SyncPartner.SetCollision(SyncPartner.bCollideActors, FALSE, );
        }
        VectToVictim = SyncPartner.location - m_oPawn.location;
        VectToVictim.Z = 0.0;
        VectToVictim = Normal(VectToVictim);
        InstigatorDestination = m_oPawn.location;
        if (!bMoveSyncPawn)
        {
            InstigatorDestination = SyncPartner.location + RelativeToWorldOffset(Rotator(-VectToVictim), MarkerOffset);
            SetReachPreciseDestination(InstigatorDestination);
            m_oPawn.LockDesiredRotation(FALSE);
            SetFacePreciseRotation(Rotator(VectToVictim), RotationTime);
            RotatePlayerCamToFutureDirection(InstigatorDestination, VectToVictim, RotationTime);
        }
        SyncPartner.GetCurrentCustomAction(oVictimCustomAction);
        if (oVictimCustomAction != None)
        {
            oVictimCustomAction.bLockRotationAfterPreciseRotation = bLockTargetRotation;
            if (bMoveSyncPawn)
            {
                SyncPawnDestination = m_oPawn.location + RelativeToWorldOffset(m_oPawn.Rotation, MarkerOffset);
                oVictimCustomAction.SetReachPreciseDestination(SyncPawnDestination);
                SyncPartner.LockDesiredRotation(FALSE);
                oVictimCustomAction.SetFacePreciseRotation(Rotator(-Vector(m_oPawn.Rotation)), RotationTime);
                RotatePlayerCamToFutureDirection(InstigatorDestination, SyncPawnDestination - m_oPawn.location, RotationTime);
                oVictimCustomAction.RotatePlayerCamToFutureDirection(SyncPawnDestination, -Vector(m_oPawn.Rotation), RotationTime);
                oVictimCustomAction.MessageEvent('RequestReachedDestinationEvent', m_oPawn);
            }
            else
            {
                SyncPawnDestination = SyncPartner.location;
                SyncPartner.LockDesiredRotation(FALSE);
                oVictimCustomAction.SetFacePreciseRotation(Rotator(-VectToVictim), RotationTime);
                oVictimCustomAction.RotatePlayerCamToFutureDirection(SyncPawnDestination, -VectToVictim, RotationTime);
            }
        }
    }
}
public function NonSyncedAction()
{
    EndThisCustomAction();
}
public function OnPartnerLeavingCustomAction()
{
    if (!bFinishedCustomAction)
    {
        InterruptThisCustomAction();
    }
}
public function OnPartnerReachedDestination();

public function Replicate()
{
    if (m_oPawn != None)
    {
        Super.Replicate();
        m_oPawn.ReplicatedCustomActionInfo.Target = SyncPartner;
    }
}
public function StopCustomAction()
{
    bFinishedCustomAction = TRUE;
    m_oPawn.ClearTimer('CheckReadyToStartInteraction', Self);
    m_oPawn.ClearTimer('InteractionStartTimedOut', Self);
    if (SyncPartner != None && !SyncPartner.bDeleteMe)
    {
        if (bDisablePartnerCollisionOnMove)
        {
            if (SyncPartner.bCollideWorld != SyncPartner.default.bCollideWorld || SyncPartner.bBlockActors != SyncPartner.default.bBlockActors)
            {
                SyncPartner.SetCollision(SyncPartner.bCollideActors, SyncPartner.default.bBlockActors, );
                SyncPartner.FitCollision();
            }
        }
        if (SyncPartner.CurrentCustomAction == PartnerCustomAction)
        {
            SyncPartner.EndCustomAction();
        }
    }
    if (bDisablePhysics && SyncPartner != None && SyncPartner.LastPhysicsSetter == Self)
    {
        SyncPartner.SetPhysics(2);
    }
    if (bHideTargetWeapon)
    {
        if (SyncPartner != None && SyncPartner.Weapon != None)
        {
            SFXWeapon(SyncPartner.Weapon).SetWeaponHidden(FALSE);
        }
    }
    if (bIgnoreCameraHiding)
    {
        m_oPawn.m_bHideWithCameraCollision = m_oPawn.default.m_bHideWithCameraCollision;
        if (SyncPartner != None)
        {
            SyncPartner.m_bHideWithCameraCollision = SyncPartner.default.m_bHideWithCameraCollision;
        }
    }
    SyncPartner = None;
    if (m_oPawn.SyncPawnOwner == Self)
    {
        m_oPawn.SyncPawn = None;
    }
    Super.StopCustomAction();
    bHasStartedInteraction = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InteractionStartTimeOut = 1.5
    MaxPartnerDistance = 128.0
    SyncCone = 0.5
    RotationTime = 0.449999988
    bIgnoreCameraHiding = TRUE
    bLockPawnRotation = TRUE
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bDisableLook = TRUE
}