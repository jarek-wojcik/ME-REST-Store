Class SeqAct_ParticleEventGenerator extends SequenceAction
    native;

var RwVector3 EventLocation;
var RwVector3 EventDirection;
var RwVector3 EventVelocity;
var RwVector3 EventNormal;
var array<string> EventNames;
var Actor Instigator;
var float EventTime;
var(SeqAct_ParticleEventGenerator) bool bEnabled;
var(SeqAct_ParticleEventGenerator) bool bUseEmitterLocation;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    InputLinks = ({
                   LinkDesc = "Trigger Event", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Enable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Disable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Toggle", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "EventNames", 
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'EventNames', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "EventTime", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'EventTime', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Location", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'EventLocation', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Direction", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'EventDirection', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Velocity", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'EventVelocity', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Normal", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'EventNormal', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}