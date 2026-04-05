Class AnimNotify_Sound extends AnimNotify
    native
    editinlinenew
    collapsecategories;

var(AnimNotify_Sound) Name BoneName;
var(AnimNotify_Sound) SoundCue SoundCue;
var(AnimNotify_Sound) float PercentToPlay;
var(AnimNotify_Sound) bool bFollowActor;
var(AnimNotify_Sound) bool bIgnoreIfActorHidden;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PercentToPlay = 1.0
    bFollowActor = TRUE
}