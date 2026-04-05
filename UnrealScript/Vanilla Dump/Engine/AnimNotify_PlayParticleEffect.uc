Class AnimNotify_PlayParticleEffect extends AnimNotify
    native
    editinlinenew
    collapsecategories;

var(AnimNotify_PlayParticleEffect) Name SocketName;
var(AnimNotify_PlayParticleEffect) Name BoneName;
var(AnimNotify_PlayParticleEffect) ParticleSystem PSTemplate;
var(AnimNotify_PlayParticleEffect) bool bIsExtremeContent;
var(AnimNotify_PlayParticleEffect) bool bAttach;
var(AnimNotify_PlayParticleEffect) bool bSkipIfOwnerIsHidden;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bSkipIfOwnerIsHidden = TRUE
}