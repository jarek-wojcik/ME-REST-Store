Class SeqEvent_ParticleEvent extends SequenceEvent
    native;

enum EParticleEventOutputType
{
    ePARTICLEOUT_Spawn,
    ePARTICLEOUT_Death,
    ePARTICLEOUT_Collision,
    ePARTICLEOUT_Kismet,
};

var Vector EventPosition;
var Vector EventVelocity;
var Vector EventNormal;
var float EventEmitterTime;
var float EventParticleTime;
var(SeqEvent_ParticleEvent) bool UseRelfectedImpactVector;
var EParticleEventOutputType EventType;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WhoTriggers = EWhoTriggers.WT_Everyone
    VariableLinks = ({
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
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Type", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'EventType', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Pos", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'EventPosition', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "ETime", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'EventEmitterTime', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Vel", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'EventVelocity', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "PTime", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'EventParticleTime', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
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
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}