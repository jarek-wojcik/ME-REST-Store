Class BioCustomAction_CoverClimb extends BioCustomAction_CoverClimbMantleBase
    config(Game);

public function StartCustomAction()
{
    Super.StartCustomAction();
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    Super.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_BS_StanceFromExplore = {
                              AnimName = ('EX_Mount_Up')
                             }
    m_BS_StanceFromCombat = {
                             AnimName = ('CB_Mount_Up')
                            }
    m_BS_StanceFromCover = {
                            AnimName = ('CB_Mount_Up_Cover')
                           }
}