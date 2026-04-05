Class SeqAct_PlaySound extends SeqAct_Latent
    native;

var(SeqAct_PlaySound) SoundCue PlaySound;
var(SeqAct_PlaySound) float ExtraDelay;
var transient float SoundDuration;
var(SeqAct_PlaySound) float FadeInTime;
var(SeqAct_PlaySound) float FadeOutTime;
var(SeqAct_PlaySound) float VolumeMultiplier;
var(SeqAct_PlaySound) float PitchMultiplier;
var(SeqAct_PlaySound) bool bSuppressSubtitles;
var transient bool bStopped;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VolumeMultiplier = 1.0
    PitchMultiplier = 1.0
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
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Stopped", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}