Class SeqAct_AttachToActor extends SequenceAction;

var(SeqAct_AttachToActor) Vector RelativeOffset;
var(SeqAct_AttachToActor) Rotator RelativeRotation;
var(SeqAct_AttachToActor) Name BoneName;
var(SeqAct_AttachToActor) bool bDetach;
var(SeqAct_AttachToActor) bool bHardAttach;
var(SeqAct_AttachToActor) bool bUseRelativeOffset;
var(SeqAct_AttachToActor) bool bUseRelativeRotation;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bHardAttach = TRUE
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
                      LinkDesc = "Attachment", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}