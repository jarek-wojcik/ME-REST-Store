Class SFXSeqAct_ForceCombatOn extends SequenceAction;

public function Activated()
{
    local SFXGame GameInfo;
    
    GameInfo = SFXGame(GetWorldInfo().Game);
    if (InputLinks[0].bHasImpulse)
    {
        GameInfo.ToggleCombatOverride(TRUE);
    }
    else if (InputLinks[1].bHasImpulse)
    {
        GameInfo.ToggleCombatOverride(FALSE);
    }
    else if (InputLinks[2].bHasImpulse)
    {
        GameInfo.ToggleCombatOverride(!SFXGRI(GetWorldInfo().GRI).bForceCombat);
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "On", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Off", 
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