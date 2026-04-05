Class SFXSeqEvt_AmbientPerformance extends SequenceEvent
    native;

enum ESFXAmbPerfEventGestureEnum
{
    SFXAPEGesture_Unset,
};
enum ESFXAmbPerfEventPoseEnum
{
    SFXAPEPose_Unset,
};
enum ESFXAmbPerfEventType
{
    AmbPerf_UNSET,
    AmbPerf_PerformanceStart,
    AmbPerf_PerformanceEnd,
    AmbPerf_PoseStart,
    AmbPerf_PoseEnd,
    AmbPerf_GestureStart,
    AmbPerf_GestureEnd,
    AmbPerf_PoseEnterTransDone,
};

var Name m_nmLinkedPerfName;
var Name m_nmPoseSetName;
var Name m_nmPoseAnimName;
var Name m_nmGestureSetName;
var Name m_nmGestureAnimName;
var(SFXSeqEvt_AmbientPerformance) ESFXAmbPerfEventType m_eEventType;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WhoTriggers = EWhoTriggers.WT_Everyone
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Actors", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}