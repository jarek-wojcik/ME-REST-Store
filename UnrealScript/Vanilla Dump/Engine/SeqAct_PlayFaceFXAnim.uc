Class SeqAct_PlayFaceFXAnim extends SequenceAction
    native;

var(SeqAct_PlayFaceFXAnim) string FaceFXGroupName;
var(SeqAct_PlayFaceFXAnim) string FaceFXAnimName;
var(SeqAct_PlayFaceFXAnim) FaceFXAnimSet FaceFXAnimSetRef;
var(SeqAct_PlayFaceFXAnim) SoundCue SoundCueToPlay;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Play", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}