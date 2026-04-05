Class BioSeqAct_EndGame extends SequenceAction;

var(BioSeqAct_EndGame) stringref srEndGameMessage;
var transient bool m_bGameOverSignalled;

public function Activated()
{
    if (!m_bGameOverSignalled)
    {
        SFXGame(GetWorldInfo().Game).SignalEndGame(srEndGameMessage);
        m_bGameOverSignalled = TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "EndGameMessage", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'srEndGameMessage', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}