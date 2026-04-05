Class SFXCustomAction_Frozen extends BioCustomAction
    config(Game);

var(SFXCustomAction_Frozen) bool bWelded;

public function StartCustomAction()
{
    m_oPawn.SnapshotNode.CaptureAnimFrame();
    SFXGRI(m_oPawn.WorldInfo.GRI).VocManager.AddToIgnoreList(m_oPawn);
    Super.StartCustomAction();
    m_oPawn.SetTimer(0.00999999978, FALSE, 'HackFreeze', Self);
}
public function UnWeldPhysicsAssetInstance()
{
    bWelded = FALSE;
    if (m_oPawn.SnapshotNode != None)
    {
        m_oPawn.SnapshotNode.CaptureAnimFrame();
    }
    m_oPawn.UnWeldPhysicsAssetInstance();
    SFXGRI(m_oPawn.WorldInfo.GRI).VocManager.RemoveFromIgnoreList(m_oPawn);
    if (m_oPawn.IsDead())
    {
        EndThisCustomAction();
        return;
    }
    m_oPawn.SetTimer(2.0, FALSE, 'StartRagdollPhase', Self);
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    return NewCustomAction == 1 || NewCustomAction == 8;
}
public function CheckBeginRecovery()
{
    if (m_oPawn.IsInState('Downed', ) || m_oPawn.IsDead() || m_oPawn.bIsInRagdollRecovery || m_oPawn.Role > ENetRole.ROLE_SimulatedProxy && VSize(m_oPawn.Velocity) < m_oPawn.m_fPhysicsRecoverSpeedThreshold)
    {
        m_oPawn.ClearTimer('CheckBeginRecovery', Self);
        m_oPawn.DecrementRagdollCount();
        if (m_oPawn.Role != ENetRole.ROLE_Authority)
        {
            while (m_oPawn.m_nRemainInRagdoll > 0)
            {
                m_oPawn.DecrementRagdollCount();
            }
        }
        m_oPawn.SetTimer(0.100000001, TRUE, 'CheckEndRecovery', Self);
    }
}
public function CheckEndRecovery()
{
    if (!m_oPawn.IsInState('InRagdoll', ) && !m_oPawn.IsInState('RagdollRecovery', ))
    {
        m_oPawn.ClearTimer('CheckEndRecovery', Self);
        EndThisCustomAction();
    }
}
public function HackFreeze()
{
    m_oPawn.IncrementRagdollCount();
    m_oPawn.InitRagdoll();
    m_oPawn.WeldPhysicsAssetInstance();
    m_oPawn.bIsFrozen = TRUE;
    bWelded = TRUE;
}
public function StartRagdollPhase()
{
    m_oPawn.SetTimer(0.100000001, TRUE, 'CheckBeginRecovery', Self);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    if (bWelded)
    {
        UnWeldPhysicsAssetInstance();
    }
    m_oPawn.bIsFrozen = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}