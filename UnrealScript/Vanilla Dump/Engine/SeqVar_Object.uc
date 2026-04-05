Class SeqVar_Object extends SequenceVariable
    native;

var const array<Class<Object>> SupportedClasses;
var transient Vector ActorLocation;
var(SeqVar_Object) Object ObjValue;
var(Conversation) bool m_bBioPauseAmbPerfOnStart;
var(Conversation) bool m_bBioUnpauseAmbPerfOnEnd;
var(Conversation) bool m_bBioRestoreInitialPoseOnEnd;
var(Conversation) bool m_bBioSkipInitialPlacement;
var(Conversation) bool m_bBioRestoreInitialLocationOnEnd;
var(Conversation) bool m_bBioDisableLookAt;

public function Object GetObjectValue()
{
    return ObjValue;
}
public function SetObjectValue(Object NewValue)
{
    ObjValue = NewValue;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SupportedClasses = (Class'Object')
    m_bBioPauseAmbPerfOnStart = TRUE
    m_bBioUnpauseAmbPerfOnEnd = TRUE
    m_bBioRestoreInitialPoseOnEnd = TRUE
}