Class SFXSeqAct_ToggleInjuredShepardMode extends SequenceAction;

public function Activated()
{
    local BioWorldInfo WorldInfo;
    local BioPlayerController PC;
    
    WorldInfo = BioWorldInfo(GetWorldInfo());
    if (WorldInfo == None)
    {
        return;
    }
    PC = WorldInfo.GetLocalPlayerController();
    if (PC == None || PC.GameModeManager2 == None)
    {
        return;
    }
    if (InputLinks[0].bHasImpulse && PC.GameModeManager2.IsActive(6) == FALSE)
    {
        PC.GameModeManager2.EnableMode(6);
    }
    else if (InputLinks[1].bHasImpulse && PC.GameModeManager2.IsActive(6))
    {
        PC.GameModeManager2.DisableMode(6);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Start", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}