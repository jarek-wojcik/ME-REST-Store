Class BioLoadingMovie
    native;

var(BioLoadingMovie) string MovieName;
var(BioLoadingMovie) int LoopBackFrame;
var(BioLoadingMovie) WwiseEventPairObject LoadingMovieWwisePair;
var(BioLoadingMovie) float FadeInTime;
var(BioLoadingMovie) float FadeOutTime;
var(BioLoadingMovie) WwiseEvent FadeOutWwiseEvent;
var(BioLoadingMovie) float MinPlayTime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoopBackFrame = 1
}