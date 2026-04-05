Class SFXSeqAct_ChangeBehaviour extends SequenceAction
    deprecated;

var(SFXSeqAct_ChangeBehaviour) Class<BioAiController> ControllerClass;
var Name nmBehaviour;
var(SFXSeqAct_ChangeBehaviour) Actor oPawn;
var(SFXSeqAct_ChangeBehaviour) EBioAutoSet eBehaviour;

public event function Activated();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Fail", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawn", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oPawn', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}