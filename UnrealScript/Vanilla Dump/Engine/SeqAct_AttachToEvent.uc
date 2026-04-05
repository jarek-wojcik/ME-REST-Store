Class SeqAct_AttachToEvent extends SequenceAction
    native;

var(SeqAct_AttachToEvent) bool bPreferController;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Attachee", 
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
    EventLinks = ({
                   LinkedEvents = (), 
                   LinkDesc = "Event", 
                   ExpectedType = Class'SequenceEvent'
                  }
                 )
}