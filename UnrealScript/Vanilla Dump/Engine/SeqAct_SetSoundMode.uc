Class SeqAct_SetSoundMode extends SequenceAction;

var(SeqAct_SetSoundMode) SoundMode SoundMode;
var(SeqAct_SetSoundMode) bool bTopPriority;

public event function Activated()
{
    local PlayerController PC;
    
    PC = GetWorldInfo().GetALocalPlayerController();
    if (PC != None)
    {
        PC.OnSetSoundMode(Self);
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
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
    VariableLinks = ()
}