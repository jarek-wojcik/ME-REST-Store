Class SFXCustomAction_InteractionPointAnim extends BioCustomAction
    abstract
    config(Game);

var transient SFXNav_InteractionPoint InteractionPoint;
var transient AnimSet TemporaryAnim;
var float UnawareVisionCone;
var float UnawareAlertness;
var bool bUnawareAI;

public event function ReachedPrecisePosition()
{
    StartInteractionAnim();
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    ApplyTimeline(TimelineTemplate, m_oPawn);
    InteractionPoint = SFXNav_InteractionPoint(m_oPawn.Anchor);
    if (InteractionPoint != None)
    {
        if (bUnawareAI && m_oAI != None && InteractionPoint.bModifyPerception)
        {
            m_oAI.SetCombatMood(1);
            m_oAI.UnawarePeripheralVision = UnawareVisionCone;
            m_oPawn.Alertness = UnawareAlertness;
        }
        if (InteractionPoint.PistolAnimInfo != None && InteractionPoint.PistolAnimInfo.AnimSet != None && SFXWeapon(m_oPawn.Weapon) != None && SFXWeapon(m_oPawn.Weapon).IsAnimTypePistol())
        {
            TemporaryAnim = InteractionPoint.PistolAnimInfo.AnimSet;
        }
        else if (InteractionPoint.AnimInfo != None)
        {
            TemporaryAnim = InteractionPoint.AnimInfo.AnimSet;
        }
        if (TemporaryAnim != None)
        {
            m_oPawn.RegisterTemporaryAnim(TemporaryAnim);
        }
        if (InteractionPoint.bPreciseLocation || InteractionPoint.bPreciseRotation)
        {
            bLockRotationAfterPreciseRotation = InteractionPoint.bPreciseRotation;
            if (InteractionPoint.bPreciseLocation)
            {
                SetReachPreciseDestination(InteractionPoint.location);
            }
            if (InteractionPoint.bPreciseRotation)
            {
                SetFacePreciseRotation(InteractionPoint.Rotation, 0.5);
            }
        }
        else
        {
            StartInteractionAnim();
        }
    }
    else
    {
        EndThisCustomAction();
    }
}
public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    return TRUE;
}
public function StartInteractionAnim();

public function StopCustomAction()
{
    Super.StopCustomAction();
    RemoveTimeline();
    if (InteractionPoint != None)
    {
        if (bUnawareAI && m_oAI != None && InteractionPoint.bModifyPerception)
        {
            m_oAI.SetCombatMood(3);
            m_oAI.UnawarePeripheralVision = m_oPawn.PeripheralVision;
            m_oPawn.Alertness = m_oPawn.default.Alertness;
        }
        if (TemporaryAnim != None)
        {
            m_oPawn.UnregisterTemporaryAnim(TemporaryAnim, 5.0);
        }
    }
}
public function TriggerEnd();

public function TriggerStart();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AICommand = Class'SFXAICmd_InteractionAnim'
    bBreakFromCover = TRUE
    bNotifyKnockedOutOfCover = TRUE
}