Class SFXSeqEvt_LeaveWorld extends SequenceEvent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WhoTriggers = EWhoTriggers.WT_Everyone
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Player", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Originator', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}