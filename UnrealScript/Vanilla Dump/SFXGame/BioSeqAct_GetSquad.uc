Class BioSeqAct_GetSquad extends SequenceAction;

var(BioSeqAct_GetSquad) Actor oPawn;
var Actor oSquad;

public function Activated()
{
    local BioPawn Pawn;
    
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = FALSE;
    if (Controller(oPawn) != None)
    {
        oPawn = Controller(oPawn).Pawn;
    }
    if (oPawn != None)
    {
        Pawn = BioPawn(oPawn);
        if (Pawn != None)
        {
            oSquad = Pawn.Squad;
            OutputLinks[0].bHasImpulse = TRUE;
            return;
        }
    }
    OutputLinks[1].bHasImpulse = TRUE;
}

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
                    LinkDesc = "Failed", 
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
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Squad", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oSquad', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}