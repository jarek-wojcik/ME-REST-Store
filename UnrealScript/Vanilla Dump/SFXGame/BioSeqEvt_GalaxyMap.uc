Class BioSeqEvt_GalaxyMap extends SequenceEvent
    native;

var(BioSeqEvt_GalaxyMap) string sEvent;
var Name EventParameter;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WhoTriggers = EWhoTriggers.WT_Everyone
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Parameter", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'EventParameter', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}