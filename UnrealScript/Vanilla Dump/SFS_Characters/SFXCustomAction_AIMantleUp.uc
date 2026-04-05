Class SFXCustomAction_AIMantleUp extends SFXCustomAction_SimpleMoveBase
    config(Game);

var(SFXCustomAction_AIMantleUp) BodyStance BS_MantleUpOutOfCover;
var(SFXCustomAction_AIMantleUp) BodyStance BS_MantleUpInCover;
var transient bool bStartInCover;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_MantleUpOutOfCover, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_MantleUpInCover, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    bStartInCover = m_oPawn.IsInCover();
    Super.StartCustomAction();
}
public function BodyStance GetBodyStanceAnim()
{
    if (bStartInCover)
    {
        return BS_MantleUpInCover;
    }
    else
    {
        return BS_MantleUpOutOfCover;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_MantleUpOutOfCover = {
                             AnimName = ('CB_Mount_Up')
                            }
    BS_MantleUpInCover = {
                          AnimName = ('CB_Mount_Up_Cover')
                         }
    MoveDistance = 70.0
    RMM = ERootMotionMode.RMM_Translate
}