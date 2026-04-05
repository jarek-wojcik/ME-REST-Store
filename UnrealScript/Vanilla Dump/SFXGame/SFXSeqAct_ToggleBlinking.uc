Class SFXSeqAct_ToggleBlinking extends SequenceAction;

public function Activated()
{
    local Object pCurObject;
    local Actor pCurActor;
    local SFXModule_Gestures pGestMod;
    
    foreach Targets(pCurObject, )
    {
        pCurActor = Actor(pCurObject);
        if (pCurActor != None)
        {
            pGestMod = pCurActor.GetModule(Class'SFXModule_Gestures');
            if (pGestMod != None)
            {
                if (InputLinks[0].bHasImpulse)
                {
                    pGestMod.m_bDisableBlinksAndNoise = FALSE;
                }
                else if (InputLinks[1].bHasImpulse)
                {
                    pGestMod.m_bDisableBlinksAndNoise = TRUE;
                }
                else if (InputLinks[2].bHasImpulse)
                {
                    pGestMod.m_bDisableBlinksAndNoise = !pGestMod.m_bDisableBlinksAndNoise;
                }
            }
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