Class SFXOutlineGlowActorBase extends Actor
    native;

var transient LinearColor CurrentColour;
var const LinearColor SeeThroughSmokeColour;
var const Vector SmokeLineOfSightOffset;
var const Name ColourParam;
var const Name MultiplierParam;
var transient BioPawn Source;
var transient MaterialInstanceConstant RenderMaterial;
var const float BlendTime;
var MaterialInterface GlowMaterial;
var const float PostDeathGlowDuration;
var transient float LastDiedTime;
var bool bSourceDied;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CurrentColour = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    SeeThroughSmokeColour = {R = 1.0, G = 0.200000003, B = 0.200000003, A = 0.5}
    SmokeLineOfSightOffset = {X = 0.0, Y = 0.0, Z = 20.0}
    ColourParam = 'GlowColor'
    MultiplierParam = 'Multiplier'
    BlendTime = 0.5
    bTearOff = TRUE
    bNoEncroachCheck = TRUE
}