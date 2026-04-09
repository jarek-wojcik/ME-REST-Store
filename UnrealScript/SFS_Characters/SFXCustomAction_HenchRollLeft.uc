Class SFXCustomAction_HenchRollLeft extends SFXCustomAction_SingleAnim
    config(Game);

public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.StopMovement(FALSE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Anim = {
               AnimName = ('CB_EvadeLeft')
              }
    bResetPhysics = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Accel
    bLockPawnRotation = TRUE
}