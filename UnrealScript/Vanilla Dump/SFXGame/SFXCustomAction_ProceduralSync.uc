Class SFXCustomAction_ProceduralSync extends SFXCustomAction_SingleAnim
    config(Game);

var BioPawn SyncPartner;
var float MaxPartnerDistance;
var float SyncCone;
var(SyncInfo) float RotationTime;
var float DestinationOffset;
var bool bStopOnImpact;
var(SyncInfo) bool bHideTargetWeapon;
var(SyncInfo) bool bAffectsFriendlies;
var const bool bTryForceLocalSimulation;

public function StartCustomAction()
{
    if (m_oPawn.SyncPawn != None)
    {
        SyncPartner = BioPawn(m_oPawn.SyncPawn);
    }
    if (bTryForceLocalSimulation)
    {
        bForceLocalSimulation = FALSE;
        if (SyncPartner != None)
        {
            bForceLocalSimulation = TRUE;
        }
    }
    bStopOnImpact = FALSE;
    Super.StartCustomAction();
    if (m_oPawn.Role == ENetRole.ROLE_SimulatedProxy || CanInteractWithPawn(SyncPartner))
    {
        if (bHideTargetWeapon)
        {
            if (SyncPartner.Weapon != None)
            {
                SFXWeapon(SyncPartner.Weapon).SetWeaponHidden(TRUE);
            }
        }
        StartInteraction();
    }
    else
    {
        NonSyncedAction();
    }
}
public function StartInteraction();

public function TickCustomAction(float DeltaTime)
{
    local Vector VectToVictim;
    
    if (SyncPartner != None)
    {
        if (!bStopOnImpact)
        {
            if (Normal(SyncPartner.location - m_oPawn.location) Dot Vector(m_oPawn.Rotation) >= SyncCone)
            {
                VectToVictim = SyncPartner.location - m_oPawn.location;
                VectToVictim.Z = 0.0;
                VectToVictim = Normal(VectToVictim);
                SetReachPreciseDestination(SyncPartner.location - VectToVictim * DestinationOffset);
                SetFacePreciseRotation(Rotator(VectToVictim), RotationTime);
            }
        }
    }
}
public function bool CanInteractWithPawn(BioPawn OtherPawn)
{
    if (OtherPawn == None || OtherPawn.IsDead() || OtherPawn.Physics == EPhysics.PHYS_Falling || OtherPawn.Physics == EPhysics.PHYS_RigidBody || bAffectsFriendlies == FALSE && m_oPawn.IsHostile(OtherPawn) == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}
public function DebugSocketRelativeLocation(Name InSocketName)
{
    local Vector MarkerLoc;
    local Rotator MarkerRot;
    
    m_oPawn.Mesh.GetSocketWorldLocationAndRotation(InSocketName, MarkerLoc, MarkerRot);
    m_oPawn.DrawDebugSphere(MarkerLoc, 4.0, 8, 255, 0, 255, TRUE);
}
public function float GetPawnScore(BioPawn BP)
{
    if (SFXPlayerController(m_oPawn.Controller) != None)
    {
        if (SFXPlayerController(m_oPawn.Controller).m_oPlayerSelection.m_oCurrentSelectionTarget == BP)
        {
            return 1000.0;
        }
    }
    else
    {
        return Vector(m_oPawn.Rotation) Dot Normal(BP.location - m_oPawn.location) / FMax(1.0, VSize(m_oPawn.location - BP.location));
    }
    return 0.0;
}
public function BioPawn GetVictimPawn()
{
    local BioPawn FoundPawn;
    local bool bInteractionObstructed;
    local Actor HitA;
    local Vector HitLocation;
    local Vector HitNormal;
    local BioPawn BestSoFar;
    local Vector VectToFoundPawn;
    
    BestSoFar = None;
    foreach m_oPawn.VisibleCollidingActors(Class'BioPawn', FoundPawn, MaxPartnerDistance, m_oPawn.location, TRUE, , , , )
    {
        if (FoundPawn != m_oPawn && CanInteractWithPawn(FoundPawn))
        {
            VectToFoundPawn = FoundPawn.location - m_oPawn.location;
            if (Normal(VectToFoundPawn) Dot Vector(m_oPawn.Rotation) >= SyncCone)
            {
                if (Abs(VectToFoundPawn.Z) < m_oPawn.CylinderComponent.CollisionHeight * 0.800000012 || Abs(VectToFoundPawn.Z) < 200.0 && Abs(Normal(VectToFoundPawn).Z) < m_oPawn.WalkableFloorZ)
                {
                    bInteractionObstructed = FALSE;
                    foreach m_oPawn.TraceActors(Class'Actor', HitA, HitLocation, HitNormal, FoundPawn.location, m_oPawn.location, vect(0.0, 0.0, 0.0), , 1)
                    {
                        if (HitA != FoundPawn && HitA.bBlockActors)
                        {
                            if (!CanInteractWithPawn(BioPawn(HitA)))
                            {
                                bInteractionObstructed = TRUE;
                                break;
                            }
                        }
                        else if (HitA == FoundPawn)
                        {
                            break;
                        }
                    }
                    if (!bInteractionObstructed)
                    {
                        if (GetPawnScore(FoundPawn) > GetPawnScore(BestSoFar))
                        {
                            BestSoFar = FoundPawn;
                        }
                    }
                }
            }
        }
    }
    return BestSoFar;
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    return TRUE;
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
    return Super(BioCustomAction).MessageEvent(EventName, Sender);
}
public function NonSyncedAction();

public function OnPartnerLeavingCustomAction();

public function OnPartnerReachedDestination();

public function Replicate()
{
    if (m_oPawn != None)
    {
        Super(BioCustomAction).Replicate();
        m_oPawn.ReplicatedCustomActionInfo.Target = SyncPartner;
    }
}
public function StopCustomAction()
{
    if (bHideTargetWeapon)
    {
        if (SyncPartner != None && SyncPartner.Weapon != None)
        {
            SFXWeapon(SyncPartner.Weapon).SetWeaponHidden(FALSE);
        }
    }
    ResetReachPreciseDestination();
    ResetFacePreciseRotation();
    SyncPartner = None;
    if (m_oPawn.SyncPawnOwner == Self)
    {
        m_oPawn.SyncPawn = None;
    }
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPartnerDistance = 500.0
    RotationTime = 0.25
    DestinationOffset = 80.0
    MoveSpeed = 650.0
    bLockPawnRotation = TRUE
    bDisableLook = TRUE
    bProceduralMovement = TRUE
}