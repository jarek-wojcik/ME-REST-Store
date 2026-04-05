Class SeqAct_DrawText extends SequenceAction
    native;

var(SeqAct_DrawText) KismetDrawTextInfo DrawTextInfo;
var(SeqAct_DrawText) float DisplayTimeSeconds;
var(SeqAct_DrawText) bool bDisplayOnObject;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DrawTextInfo = {
                    MessageText = "", 
                    MessageFontScale = {X = 1.0, Y = 1.0}, 
                    MessageOffset = {X = 0.0, Y = 0.0}, 
                    MessageFont = Font'EngineFonts.SmallFont', 
                    MessageColor = {B = 255, G = 255, R = 255, A = 255}, 
                    MessageEndTime = -1.0
                   }
    DisplayTimeSeconds = -1.0
    InputLinks = ({
                   LinkDesc = "Show", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Hide", 
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
                      LinkDesc = "String", 
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 0, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bLatentExecution = TRUE
    bAutoActivateOutputLinks = FALSE
}