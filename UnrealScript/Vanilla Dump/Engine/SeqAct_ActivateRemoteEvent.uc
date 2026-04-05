Class SeqAct_ActivateRemoteEvent extends SequenceAction
    native;

var(SeqAct_ActivateRemoteEvent) array<RemoteEventParameter> Parameters;
var(SeqAct_ActivateRemoteEvent) Name EventName;
var(SeqAct_ActivateRemoteEvent) Actor Instigator;
var transient bool bStatusIsOk;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventName = 'DefaultEvent'
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Instigator', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}