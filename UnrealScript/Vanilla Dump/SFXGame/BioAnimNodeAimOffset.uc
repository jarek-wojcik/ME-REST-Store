Class BioAnimNodeAimOffset extends AnimNodeAimOffset
    native;

enum EAimInputType
{
    AimInput_Pawn,
    AimInput_Vehicle,
    AimInput_Kismet,
    AimInput_PawnMotion,
};

var transient array<byte> BoneToAimMap;
var const transient Vector2D LastAimOffset;
var const transient Vector2D LastPostProcessedAimOffset;
var transient Vector2D MotionAimOffset;
var const transient Actor OwningActor;
var(BioAnimNodeAimOffset) const transient float TurnInPlaceOffset;
var const transient float TurnAroundTimeToGo;
var(BioAnimNodeAimOffset) float TurnAroundBlendTime;
var(BioAnimNodeAimOffset) float AngVelAimOffsetChangeSpeed;
var(BioAnimNodeAimOffset) float AngVelAimOffsetScale;
var(BioAnimNodeAimOffset) EAimInputType AimInput;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TurnAroundBlendTime = 0.419999987
    AngVelAimOffsetChangeSpeed = 3.0
    AngVelAimOffsetScale = 1.0
}