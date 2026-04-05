Class SFXCustomAction_BoostDownBase extends SFXCustomAction_ReachSpecMove
    native
    config(Game);

public function PreAlignPawnLocation()
{
    local float AlignRotYaw;
    local Rotator NewRotation;
    
    Super.PreAlignPawnLocation();
    AlignRotYaw = float(Rotator(Destination - m_oPawn.location).Yaw);
    NewRotation = m_oPawn.Rotation;
    NewRotation.Yaw = int(AlignRotYaw);
    SetFacePreciseRotation(NewRotation, 0.200000003);
}
public function SetMoveStage(EMoveStage NextStage)
{
    Super(SFXCustomAction_ProceduralMoveBase).SetMoveStage(NextStage);
    if (NextStage == EMoveStage.EMS_Start)
    {
        m_oPawn.LastPhysicsSetter = Outer;
        if (m_oPawn.Physics == EPhysics.PHYS_PathApproximation)
        {
            m_oPawn.ForceGroundConform();
        }
        m_oPawn.SetPhysics(4);
    }
}
public function StopCustomAction()
{
    if (m_oPawn.LastPhysicsSetter == Outer)
    {
        m_oPawn.SetPhysics(1);
    }
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAlignPawnBeforeMove = TRUE
    bLockRotationAfterPreciseRotation = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
}