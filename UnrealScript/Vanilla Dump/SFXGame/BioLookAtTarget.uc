Class BioLookAtTarget extends Actor
    placeable;

var(BioLookAtTarget) float m_fDelay;
var(BioLookAtTarget) float m_fConeDeg;
var(BioLookAtTarget) float m_fMinDistance;
var float m_fCODelayRemaining;
var float m_fNCODelayRemaining;
var float m_fConeCos;
var bool m_bCOSeen;
var bool m_bNCOSeen;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fDelay = 0.400000006
    m_fConeDeg = 30.0
    m_fMinDistance = 3000.0
    m_fCODelayRemaining = -1.0
    m_fNCODelayRemaining = -1.0
    m_fConeCos = 0.866025388
    Components = (None)
    bNoTick = TRUE
}