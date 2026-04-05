Class BioSeqAct_ShouldShowSplashSequence extends SequenceAction;

public function Activated()
{
    local string URLString;
    local string OptionsString;
    
    URLString = GetWorldInfo().GetLocalURL();
    OptionsString = Mid(URLString, InStr(URLString, "?", , , ), );
    if (Class'GameInfo'.static.HasOption(OptionsString, "nosplash") || Class'GameInfo'.static.HasOption(OptionsString, "failed"))
    {
        OutputLinks[1].bHasImpulse = TRUE;
    }
    else
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
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
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}