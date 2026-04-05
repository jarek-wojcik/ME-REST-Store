Class SeqAct_ControlMovieTexture extends SequenceAction;

enum EMovieControlType
{
    MCT_Play,
    MCT_Stop,
    MCT_Pause,
};

var(SeqAct_ControlMovieTexture) TextureMovie MovieTexture;

public event function Activated()
{
    local PlayerController PC;
    local EMovieControlType mode;
    
    if (MovieTexture != None)
    {
        if (InputLinks[0].bHasImpulse)
        {
            mode = EMovieControlType.MCT_Play;
        }
        else if (InputLinks[1].bHasImpulse)
        {
            mode = EMovieControlType.MCT_Stop;
        }
        else if (InputLinks[2].bHasImpulse)
        {
            mode = EMovieControlType.MCT_Pause;
        }
        foreach GetWorldInfo().AllControllers(Class'PlayerController', PC)
        {
            if (LocalPlayer(PC.Player) != None && PC.IsPrimaryPlayer() || NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None)
            {
                PC.ClientControlMovieTexture(MovieTexture, mode);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Play", 
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
                  }, 
                  {
                   LinkDesc = "Pause", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ()
}