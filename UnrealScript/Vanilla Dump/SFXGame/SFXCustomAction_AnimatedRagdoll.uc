Class SFXCustomAction_AnimatedRagdoll extends BioCustomAction
    abstract
    config(Game);

var(SFXCustomAction_AnimatedRagdoll) BodyStance BS_Start;
var(SFXCustomAction_AnimatedRagdoll) BodyStance BS_Loop;
var transient Vector impulse;
var SFXAnimSetCookSpec AnimInfo;
var float fLoopAnimPlayRate;
var transient float OldZVelocity;
var transient bool bFinishedStartAnim;
var(SFXCustomAction_AnimatedRagdoll) ERootMotionMode RootMotionMode;

public function AddImpulse(Vector ImpulseForce)
{
    if (m_oPawn.Mesh.RootMotionMode == ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Velocity += ImpulseForce;
    }
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    m_oPawn.RegisterTemporaryAnim(AnimInfo.AnimSet);
    bFinishedStartAnim = FALSE;
    if (m_oPawn.PlayBodyStance(BS_Start, 1.0, 0.25, 0.0) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, TRUE);
        m_oPawn.SetPhysics(4);
        m_oPawn.LastPhysicsSetter = Self;
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 2, 2, 2);
            m_oPawn.Mesh.RootMotionMode = RootMotionMode;
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        else
        {
            m_oPawn.Velocity = impulse;
        }
    }
    m_oPawn.SetTimer(0.100000001, TRUE, 'CheckBeginRecovery', Self);
    if (SFXGRI(m_oPawn.WorldInfo.GRI) != None)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(35, m_oPawn, m_oPawn, 0.0);
    }
}
public event function TickCustomAction(float DeltaTime)
{
    Super.TickCustomAction(DeltaTime);
    if (m_oPawn.Mesh.RootMotionMode == ERootMotionMode.RMM_Ignore)
    {
        OldZVelocity = m_oPawn.Velocity.Z;
        m_oPawn.Velocity.Z += m_oPawn.GetGravityZ() * DeltaTime;
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local float fDelay;
    
    bFinishedStartAnim = TRUE;
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 1, 1, 1);
    if (m_oPawn.WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        fDelay = FRand() * 0.5;
    }
    else
    {
        fDelay = 0.0;
    }
    m_oPawn.PlayBodyStance(BS_Loop, fLoopAnimPlayRate, 0.0, 0.0, TRUE, , , fDelay);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, FALSE);
    m_oPawn.Velocity += impulse;
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    return NewCustomAction == 1 || Super.CanOverrideMoveWith(OldCustomAction, NewCustomAction);
}
public function bool CheckBeginRecovery()
{
    local Vector StableVelocity;
    
    StableVelocity = m_oPawn.Velocity;
    StableVelocity.Z = OldZVelocity;
    if (bFinishedStartAnim && m_oPawn.m_nRemainInRagdoll <= 0 && (VSize(StableVelocity) < 15.0 || Abs(OldZVelocity) < 10.0))
    {
        m_oPawn.ClearTimer('CheckBeginRecovery', Self);
        m_oPawn.SetTimer(0.100000001, FALSE, 'CheckEndRecovery', Self);
        return TRUE;
    }
    return FALSE;
}
public function CheckEndRecovery()
{
    m_oPawn.StartCustomAction(1);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.UnregisterTemporaryAnim(AnimInfo.AnimSet);
    if (m_oPawn.LastPhysicsSetter == Self)
    {
        m_oPawn.SetPhysics(1);
    }
    if (bFinishedStartAnim)
    {
        m_oPawn.StopBodyStance(BS_Loop, 0.25);
    }
    else
    {
        m_oPawn.StopBodyStance(BS_Start, 0.25);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 1, 1, 1);
            m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        }
    }
    if (m_oPawn != None)
    {
        m_oPawn.ClearTimer('CheckBeginRecovery', Self);
        m_oPawn.ClearTimer('CheckEndRecovery', Self);
    }
    impulse = vect(0.0, 0.0, 0.0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fLoopAnimPlayRate = 1.0
    bBreakFromCover = TRUE
    bReplicateCustomAction = TRUE
}