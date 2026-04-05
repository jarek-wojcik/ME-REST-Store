Class SFXCustomAction_PrecisionMove extends BioCustomAction
    config(Game);

var Vector m_vDestinationLoc;
var Rotator m_rDestinationRot;
var float m_fRotationTime;

public event function ReachedPrecisePosition()
{
    if (m_oAI != None)
    {
        m_oAI.Focus = None;
        m_oAI.SetFocalPoint(m_vDestinationLoc + Vector(m_rDestinationRot) * 50.0);
    }
    EndThisCustomAction();
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    SetReachPreciseDestination(m_vDestinationLoc);
    SetFacePreciseRotation(m_rDestinationRot, m_fRotationTime);
}
public function SetDestination(Vector vLocation, Rotator rRotation, float fRotationTime)
{
    m_vDestinationLoc = vLocation;
    m_rDestinationRot = rRotation;
    m_fRotationTime = fRotationTime;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}