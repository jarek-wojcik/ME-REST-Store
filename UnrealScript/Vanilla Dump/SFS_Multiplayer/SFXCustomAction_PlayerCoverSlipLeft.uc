Class SFXCustomAction_PlayerCoverSlipLeft extends SFXCustomAction_CoverSlipBase
    config(Game);

public function StartCustomAction()
{
    Super(SFXCustomAction_SingleAnim).StartCustomAction();
    m_oPawn.Velocity += Vector(m_oPawn.Rotation) * float(500);
}
public function EndThisCustomAction()
{
    m_oPawn.Velocity += Vector(m_oPawn.Rotation) * float(500);
    Super(BioCustomAction).EndThisCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Anim = {
               AnimName = ('CB_CovMid_SlipLeft')
              }
    fAnimPlayRate = 1.25
    bLockPawnRotation = FALSE
    bDisableMovement = FALSE
}