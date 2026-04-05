Class SeqAct_PlayCameraAnim extends SequenceAction
    native;

var(SeqAct_PlayCameraAnim) CameraAnim CameraAnim;
var(SeqAct_PlayCameraAnim) float BlendInTime;
var(SeqAct_PlayCameraAnim) float BlendOutTime;
var(SeqAct_PlayCameraAnim) float Rate;
var(SeqAct_PlayCameraAnim) float IntensityScale;
var(SeqAct_PlayCameraAnim) Actor UserDefinedSpaceActor;
var(SeqAct_PlayCameraAnim) bool bLoop;
var(SeqAct_PlayCameraAnim) bool bRandomStartTime;
var(SeqAct_PlayCameraAnim) ECameraAnimPlaySpace PlaySpace;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    local int N;
    local int i;
    local int J;
    local int OutIdx;
    local bool Found;
    
    OutIdx = -1;
    if (OutputLinks.Length <= 1)
    {
        return;
    }
    for (N = 0; N < OutputLinks.Length; N++)
    {
        if (OutputLinks[N].LinkDesc == "Out")
        {
            OutIdx = N;
        }
    }
    for (N = 0; N < OutputLinks.Length; N++)
    {
        if (N != OutIdx)
        {
            for (i = 0; i < OutputLinks[N].Links.Length; i++)
            {
                Found = FALSE;
                for (J = 0; J < OutputLinks[OutIdx].Links.Length; J++)
                {
                    if (OutputLinks[OutIdx].Links[J].LinkedOp == OutputLinks[N].Links[i].LinkedOp && OutputLinks[OutIdx].Links[J].InputLinkIdx == OutputLinks[N].Links[i].InputLinkIdx)
                    {
                        Found = TRUE;
                        break;
                    }
                }
                if (!Found)
                {
                    OutputLinks[OutIdx].Links.AddItem(OutputLinks[N].Links[i]);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendInTime = 0.200000003
    BlendOutTime = 0.200000003
    Rate = 1.0
    IntensityScale = 1.0
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
                  }
                 )
}