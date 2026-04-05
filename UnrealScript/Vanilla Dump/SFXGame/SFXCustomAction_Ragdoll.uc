Class SFXCustomAction_Ragdoll extends BioCustomAction
    config(Game);

var transient Vector impulse;
var transient Vector HitLocation;
var transient Vector LastRecoveryLocation;
var transient Name HitBone;
var transient float LastRecoveryAttemptTime;
var transient bool bHeldInRagdoll;
var bool bVelocityChange;

public function StartCustomAction()
{
    Super.StartCustomAction();
    m_oPawn.SetTimer(0.100000001, TRUE, 'CheckBeginRecovery', Self);
    if (SFXGRI(m_oPawn.WorldInfo.GRI) != None)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(35, m_oPawn, m_oPawn, 0.0);
    }
    m_oPawn.RegisterRBCallback(OnRagdollPhysicsImpact);
    m_oPawn.SetTimer(0.25, TRUE, 'PlayScream', Self);
    bHeldInRagdoll = TRUE;
    m_oPawn.IncrementRagdollCount();
    m_oPawn.InitRagdoll();
    if (m_oPawn.Mesh != None)
    {
        m_oPawn.Mesh.AddImpulse(impulse, HitLocation, HitBone, bVelocityChange);
    }
    LastRecoveryLocation = m_oPawn.location;
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    return NewCustomAction == 1 || NewCustomAction == 8;
}
public function bool CheckBeginRecovery()
{
    local bool bCanRecoverFromRagdoll;
    local Vector TraceEnd;
    local Vector TraceExtent;
    
    bCanRecoverFromRagdoll = FALSE;
    if (m_oPawn.IsInState('Downed', ) || m_oPawn.IsDead() || m_oPawn.bIsInRagdollRecovery)
    {
        bCanRecoverFromRagdoll = TRUE;
    }
    else if (m_oPawn.Role > ENetRole.ROLE_SimulatedProxy && VSize(m_oPawn.Velocity) < m_oPawn.m_fPhysicsRecoverSpeedThreshold)
    {
        TraceExtent = m_oPawn.GetCollisionExtent();
        TraceEnd = m_oPawn.location;
        TraceEnd.Z -= TraceExtent.Z + m_oPawn.MaxStepHeight;
        TraceExtent.Z = 1.0;
        if (m_oPawn.FastTrace(TraceEnd, m_oPawn.location, TraceExtent, FALSE))
        {
            if (VSizeSq(LastRecoveryLocation - m_oPawn.location) > 10000.0)
            {
                LastRecoveryLocation = m_oPawn.location;
                LastRecoveryAttemptTime = m_oPawn.WorldInfo.GameTimeSeconds;
            }
            else if (m_oPawn.WorldInfo.GameTimeSeconds - LastRecoveryAttemptTime > 1.0)
            {
                bCanRecoverFromRagdoll = TRUE;
            }
        }
        else
        {
            bCanRecoverFromRagdoll = TRUE;
        }
    }
    if (bCanRecoverFromRagdoll)
    {
        m_oPawn.StopVocalization();
        bHeldInRagdoll = FALSE;
        m_oPawn.ClearTimer('CheckBeginRecovery', Self);
        m_oPawn.ClearTimer('PlayScream', Self);
        m_oPawn.ClearTimer('RestartScream', Self);
        m_oPawn.ClearTimer('RegisterRagdollVocCallback', Self);
        m_oPawn.ClearRBCallbacks();
        m_oPawn.DecrementRagdollCount();
        if (m_oPawn.Role != ENetRole.ROLE_Authority)
        {
            while (m_oPawn.m_nRemainInRagdoll > 0)
            {
                m_oPawn.DecrementRagdollCount();
            }
        }
        m_oPawn.SetTimer(0.100000001, TRUE, 'CheckEndRecovery', Self);
        return TRUE;
    }
    return FALSE;
}
public function CheckEndRecovery()
{
    if (!m_oPawn.IsInState('InRagdoll', ) && !m_oPawn.IsInState('RagdollRecovery', ))
    {
        m_oPawn.ClearTimer('CheckEndRecovery', Self);
        EndThisCustomAction();
    }
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        if (!m_oPawn.IsPlayerPawn() && bPushAICommand)
        {
            impulse = m_oPawn.ReplicatedCustomActionInfo.TargetLocation;
        }
        Super.ClientDoCustomAction(bForced);
    }
}
public function OnRagdollPhysicsImpact(Pawn Pawn, Actor oImpactActor, Vector vImpactDir)
{
    SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(35, m_oPawn, m_oPawn, 0.0);
    m_oPawn.ClearTimer('PlayScream', Self);
    m_oPawn.SetTimer(1.0, FALSE, 'RestartScream', Self);
    m_oPawn.SetTimer(0.100000001, FALSE, 'RegisterRagdollVocCallback', Self);
}
public function PlayScream()
{
    if (m_oPawn.CurrentCustomAction != 1 || m_oPawn.Physics != EPhysics.PHYS_RigidBody)
    {
        m_oPawn.ClearTimer('PlayScream', Self);
        m_oPawn.ClearTimer('RestartScream', Self);
        m_oPawn.ClearRBCallbacks();
        return;
    }
    if (SFXGRI(m_oPawn.WorldInfo.GRI) != None)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(36, m_oPawn, m_oPawn, 0.0);
    }
    m_oPawn.SetTimer(3.0, TRUE, 'PlayScream', Self);
}
public function RegisterRagdollVocCallback()
{
    m_oPawn.RegisterRBCallback(OnRagdollPhysicsImpact);
}
public function Replicate()
{
    Super.Replicate();
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.TargetLocation = impulse;
    }
}
public function RestartScream()
{
    m_oPawn.SetTimer(1.0, TRUE, 'PlayScream', Self);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    if (m_oPawn != None)
    {
        if (bHeldInRagdoll)
        {
            m_oPawn.ClearTimer('CheckBeginRecovery', Self);
            m_oPawn.ClearTimer('PlayScream', Self);
            m_oPawn.ClearTimer('RestartScream', Self);
            m_oPawn.ClearTimer('RegisterRagdollVocCallback', Self);
            m_oPawn.ClearRBCallbacks();
            m_oPawn.DecrementRagdollCount();
            if (m_oPawn.Role != ENetRole.ROLE_Authority)
            {
                while (m_oPawn.m_nRemainInRagdoll > 0)
                {
                    m_oPawn.DecrementRagdollCount();
                }
            }
        }
        else
        {
            m_oPawn.ClearTimer('CheckEndRecovery', Self);
        }
    }
    impulse = vect(0.0, 0.0, 0.0);
    HitLocation = vect(0.0, 0.0, 0.0);
    HitBone = 'None';
    bVelocityChange = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bBreakFromCover = TRUE
    bReplicateCustomAction = TRUE
}