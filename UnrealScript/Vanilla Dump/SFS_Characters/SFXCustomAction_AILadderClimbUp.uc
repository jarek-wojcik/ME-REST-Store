Class SFXCustomAction_AILadderClimbUp extends SFXCustomAction_ClimbUpBase
    config(Game);

var transient AnimSet LadderAnimSet;

public function StartCustomAction()
{
    local SFXNav_LadderNode LadderNode;
    
    LadderNode = SFXNav_LadderNode(MovementPath.Start);
    if (LadderNode != None)
    {
        LadderAnimSet = LadderNode.AnimInfo.AnimSet;
        m_oPawn.RegisterTemporaryAnim(LadderAnimSet);
    }
    Super(SFXCustomAction_ReachSpecMove).StartCustomAction();
}
public function StopCustomAction()
{
    if (LadderAnimSet != None)
    {
        m_oPawn.UnregisterTemporaryAnim(LadderAnimSet);
        LadderAnimSet = None;
    }
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Start = {
                AnimName = ('EX_LadderUp_Enter')
               }
    BS_Loop = {
               AnimName = ('EX_LadderUp_Loop')
              }
    BS_End = {
              AnimName = ('EX_LadderUp_Exit')
             }
    fEndBlendOutTime = 0.0500000007
    StartRMM = ERootMotionMode.RMM_Accel
    bBreakFromCover = TRUE
}