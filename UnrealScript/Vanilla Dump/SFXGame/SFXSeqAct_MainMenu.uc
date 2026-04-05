Class SFXSeqAct_MainMenu extends SequenceAction;

public function Activated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local BioSFHandler_MainMenu oMainMenuHandler;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    if (oController != None)
    {
        oMainMenuHandler = Class'SFXGUIInteraction'.static.GetInstance().GetMainMenuHandler(oController);
    }
    if (oMainMenuHandler != None)
    {
        if (InputLinks[0].bHasImpulse)
        {
        }
        else if (InputLinks[1].bHasImpulse)
        {
        }
    }
    Super(SequenceOp).Activated();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Show", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Hide", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ()
}