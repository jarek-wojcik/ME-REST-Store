Class SFXSeqCond_HasPlayerStart extends SequenceCondition;

public function Activated()
{
    local bool bHasPlayerStart;
    local SFXEngine Engine;
    
    bHasPlayerStart = FALSE;
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None)
    {
        if (Engine.m_DesiredStartPoint != 'None')
        {
            bHasPlayerStart = TRUE;
        }
    }
    if (bHasPlayerStart)
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    else
    {
        OutputLinks[1].bHasImpulse = TRUE;
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