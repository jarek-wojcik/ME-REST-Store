Class SFXSeqEvt_Ragdoll extends SequenceEvent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WhoTriggers = EWhoTriggers.WT_Everyone
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Entered", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Left", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}