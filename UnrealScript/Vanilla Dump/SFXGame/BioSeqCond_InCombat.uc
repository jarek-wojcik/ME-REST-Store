Class BioSeqCond_InCombat extends SequenceCondition;

public function Activated()
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(GetWorldInfo().GRI);
    if (GRI != None)
    {
        if (GRI.InCombat())
        {
            OutputLinks[0].bHasImpulse = TRUE;
        }
        else
        {
            OutputLinks[1].bHasImpulse = TRUE;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
}