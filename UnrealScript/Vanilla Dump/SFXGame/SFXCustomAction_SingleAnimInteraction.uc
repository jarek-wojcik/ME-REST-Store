Class SFXCustomAction_SingleAnimInteraction extends SFXCustomAction_InteractionPointAnim
    abstract
    config(Game);

var(SFXCustomAction_SingleAnimInteraction) BodyStance BS_InteractionAnim;
var float fBlendInTime;
var float fBlendOutTime;
var(SFXCustomAction_SingleAnimInteraction) bool bPauseAnimOnStart;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_InteractionAnim, UsedAnims);
    Super(BioCustomAction).GetUsedAnimNames(UsedAnims);
}
public function StartInteractionAnim()
{
    if (m_oPawn.PlayBodyStance(BS_InteractionAnim, 1.0, fBlendInTime, fBlendOutTime) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionAnim, TRUE);
        if (bPauseAnimOnStart)
        {
            m_oPawn.BS_SetPlayingFlag(BS_InteractionAnim, FALSE);
        }
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.StopBodyStance(BS_InteractionAnim, fBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionAnim, FALSE);
}
public function TriggerEnd()
{
    if (bPauseAnimOnStart)
    {
        m_oPawn.BS_SetPlayingFlag(BS_InteractionAnim, TRUE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fBlendInTime = 0.200000003
    fBlendOutTime = 0.200000003
}