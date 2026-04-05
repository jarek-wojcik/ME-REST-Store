Class SoundNodeDistanceCrossFade extends SoundNode
    native
    editinlinenew;

struct native DistanceDatum 
{
    var(DistanceDatum) float FadeInDistanceStart;
    var(DistanceDatum) float FadeInDistanceEnd;
    var(DistanceDatum) float FadeOutDistanceStart;
    var(DistanceDatum) float FadeOutDistanceEnd;
    var(DistanceDatum) float Volume;
    
    structdefaultproperties
    {
        Volume = 1.0
    }
};

var(SoundNodeDistanceCrossFade) editinline export editfixedsize array<DistanceDatum> CrossFadeInput;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}