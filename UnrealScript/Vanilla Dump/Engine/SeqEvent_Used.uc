Class SeqEvent_Used extends SequenceEvent
    native;

var(SeqEvent_Used) string InteractText;
var(TouchTypes) array<Class<Actor>> ClassProximityTypes;
var(TouchTypes) array<Class<Actor>> IgnoredClassProximityTypes;
var(SeqEvent_Used) float InteractDistance;
var(SeqEvent_Used) Texture2D InteractIcon;
var(SeqEvent_Used) bool bAimToInteract;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    if (OutputLinks[0].LinkDesc == "Out")
    {
        OutputLinks[0].LinkDesc = "Used";
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InteractText = "Use"
    InteractDistance = 512.0
    bAimToInteract = TRUE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Used", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Unused", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
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
                      LinkDesc = "Distance", 
                      ExpectedType = Class'SeqVar_Float', 
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