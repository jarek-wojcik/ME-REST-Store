Class SFXCustomAction_PlayerEvadeBase extends SFXCustomAction_SingleAnim
    config(Game);

public function StartCustomAction()
{
    Super.StartCustomAction();
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedDirection = m_oPawn.ReplicatedCustomActionInfo.TargetLocation / 100.0;
    }
    Super(BioCustomAction).ClientDoCustomAction(bForced);
}
public function Vector GetRollDirection()
{
    local Vector ToEnd2D;
    
    if (m_oPawn != None)
    {
        if (!m_oPawn.IsLocallyControlled())
        {
            ToEnd2D = m_oPawn.ReplicatedDirection;
        }
        else if (m_oPC != None && m_oPC.PlayerCamera != None && m_oPC.PlayerInput != None)
        {
            ToEnd2D = Vector(m_oPC.PlayerCamera.CameraCache.POV.Rotation + Rotator(BioPlayerInput(m_oPC.PlayerInput).MoveStick));
            ToEnd2D.Z = 0.0;
        }
    }
    return ToEnd2D;
}
public function Replicate()
{
    Super(BioCustomAction).Replicate();
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.TargetLocation = GetRollDirection() * 100.0;
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
            PC.ServerStartCustomActionWithDirection(NewAction, GetRollDirection() * 100.0, Sync, NewPowerAction);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAllowChargeHolding = TRUE
    bDisableUse = TRUE
}