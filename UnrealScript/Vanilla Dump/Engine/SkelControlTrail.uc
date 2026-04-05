Class SkelControlTrail extends SkelControlBase
    native;

var transient Matrix OldLocalToWorld;
var transient array<Vector> TrailBoneLocations;
var(Trail) Vector FakeVelocity;
var(Trail) int ChainLength;
var(Trail) float TrailRelaxation;
var(Trail) float StretchLimit;
var float ThisTimstep;
var(Trail) bool bInvertChainBoneAxis;
var(Trail) bool bLimitStretch;
var(Trail) bool bActorSpaceFakeVel;
var bool bHadValidStrength;
var(Trail) EAxis ChainBoneAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ChainLength = 2
    TrailRelaxation = 10.0
    ChainBoneAxis = EAxis.AXIS_X
}