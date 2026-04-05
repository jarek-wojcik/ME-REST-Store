Class AnimNotify_PlayFaceFXAnim extends AnimNotify_Scripted
    editinlinenew
    collapsecategories;

var(AnimNotify_PlayFaceFXAnim) string GroupName;
var(AnimNotify_PlayFaceFXAnim) string AnimName;
var(AnimNotify_PlayFaceFXAnim) FaceFXAnimSet FaceFXAnimSetRef;
var(AnimNotify_PlayFaceFXAnim) SoundCue SoundCueToPlay;
var(AnimNotify_PlayFaceFXAnim) float PlayFrequency;
var(AnimNotify_PlayFaceFXAnim) bool bOverridePlayingAnim;

public event function Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    if (PlayFrequency < 1.0)
    {
        if (FRand() > PlayFrequency)
        {
            return;
        }
    }
    else if (PlayFrequency > 1.0)
    {
    }
    if (Owner != None)
    {
        if (Owner.CanActorPlayFaceFXAnim())
        {
            if (bOverridePlayingAnim || !Owner.IsActorPlayingFaceFXAnim())
            {
                Owner.PlayActorFaceFXAnim(FaceFXAnimSetRef, GroupName, AnimName, SoundCueToPlay);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayFrequency = 1.0
    bOverridePlayingAnim = TRUE
}