Class SFXSeqAct_InitLoadingMovies extends SequenceAction
    native;

var transient BioBinkAsyncPreloader Preloader;
var(SFXSeqAct_InitLoadingMovies) array<BioLoadingMovie> Movies;
var(SFXSeqAct_InitLoadingMovies) BioSFScreenTip ScreenTip;
var(SFXSeqAct_InitLoadingMovies) bool HideScaleform;
var(SFXSeqAct_InitLoadingMovies) bool RequiresExplicitStop;
var(SFXSeqAct_InitLoadingMovies) bool PlayToCompletion;
var(SFXSeqAct_InitLoadingMovies) bool StreamFromDisc;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HideScaleform = TRUE
    InputLinks = ({
                   LinkDesc = "In", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Prime Movie", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unprime Movie", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
}