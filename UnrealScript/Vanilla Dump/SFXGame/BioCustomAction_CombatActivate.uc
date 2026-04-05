Class BioCustomAction_CombatActivate extends BioCustomAction
    deprecated
    config(Game);

var(BioCustomAction_CombatActivate) BodyStance BS_CombatActivate;

public function StartCustomAction()
{
    Super.StartCustomAction();
    if (m_oPawn.PlayBodyStance(BS_CombatActivate, 1.0, 0.0, 0.0) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_CombatActivate, TRUE);
        m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    EndThisCustomAction();
}
public function ContinueCustomAction()
{
    m_oPawn.BS_SetPlayingFlag(BS_CombatActivate, TRUE);
}
public function PauseCustomAction()
{
    m_oPawn.BS_SetPlayingFlag(BS_CombatActivate, FALSE);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.StopBodyStance(BS_CombatActivate, 0.200000003);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_CombatActivate, FALSE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_CombatActivate = {
                         AnimName = ('CB_CombatActivate')
                        }
    AICommand = Class'SFXAICmd_CombatActivate'
}