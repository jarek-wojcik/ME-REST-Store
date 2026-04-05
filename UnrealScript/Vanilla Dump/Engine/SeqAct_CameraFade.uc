Class SeqAct_CameraFade extends SequenceAction
    native;

var transient array<PlayerController> CachedPCs;
var(SeqAct_CameraFade) Color FadeColor;
var(SeqAct_CameraFade) float FadeOpacity;
var(SeqAct_CameraFade) float FadeTime;
var float FadeTimeRemaining;
var(SeqAct_CameraFade) bool bPersistFade;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FadeOpacity = 1.0
    FadeTime = 1.0
    bPersistFade = TRUE
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
                   }
                  )
    bLatentExecution = TRUE
    bAutoActivateOutputLinks = FALSE
}