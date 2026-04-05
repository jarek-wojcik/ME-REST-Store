Class SFXSeqAct_ToggleAutoHints extends SequenceAction;

public function Activated()
{
    local BioPlayerController oPC;
    
    oPC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oPC != None)
    {
        if (InputLinks[0].bHasImpulse)
        {
            oPC.HintSystem.m_bDisabledForTutorial = FALSE;
        }
        else if (InputLinks[1].bHasImpulse)
        {
            oPC.HintSystem.m_bDisabledForTutorial = TRUE;
        }
        else if (InputLinks[2].bHasImpulse)
        {
            oPC.HintSystem.m_bDisabledForTutorial = !oPC.HintSystem.m_bDisabledForTutorial;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Enable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Disable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Toggle", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}