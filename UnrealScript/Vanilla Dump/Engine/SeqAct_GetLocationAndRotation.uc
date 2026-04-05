Class SeqAct_GetLocationAndRotation extends SequenceAction
    native;

var(SeqAct_GetLocationAndRotation) editconst Vector location;
var(SeqAct_GetLocationAndRotation) editconst Vector RotationVector;
var(SeqAct_GetLocationAndRotation) Name SocketOrBoneName;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
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
                      PropertyName = 'location', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Rotation Vector", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'RotationVector', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}