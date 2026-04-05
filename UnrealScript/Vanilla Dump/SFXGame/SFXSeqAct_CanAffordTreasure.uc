Class SFXSeqAct_CanAffordTreasure extends SequenceAction;

var(SFXSeqAct_CanAffordTreasure) int nState;

public function Activated()
{
    local BioWorldInfo oWorldInfo;
    local bool bQualifies;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    bQualifies = oWorldInfo.GetGlobalVariables().GetBool(nState) == FALSE;
    OutputLinks[0].bHasImpulse = bQualifies;
    OutputLinks[1].bHasImpulse = !OutputLinks[0].bHasImpulse;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "True", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "False", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Treasure", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nState', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}