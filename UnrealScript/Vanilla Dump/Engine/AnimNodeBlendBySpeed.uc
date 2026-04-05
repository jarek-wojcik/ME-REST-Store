Class AnimNodeBlendBySpeed extends AnimNodeBlendList
    native;

var(AnimNodeBlendBySpeed) array<float> Constraints;
var float Speed;
var int LastChannel;
var(AnimNodeBlendBySpeed) float BlendUpTime;
var(AnimNodeBlendBySpeed) float BlendDownTime;
var(AnimNodeBlendBySpeed) float BlendDownPerc;
var(AnimNodeBlendBySpeed) float BlendUpDelay;
var(AnimNodeBlendBySpeed) float BlendDownDelay;
var transient float BlendDelayRemaining;
var(AnimNodeBlendBySpeed) bool bUseAcceleration;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Constraints = (0.0, 180.0, 350.0, 900.0)
    BlendUpTime = 0.100000001
    BlendDownTime = 0.100000001
    BlendDownPerc = 0.200000003
    bSkipTickWhenZeroWeight = TRUE
}