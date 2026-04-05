Class SFXSeqAct_WheelController_NativeBase extends SeqAct_Latent
    native
    abstract;

struct native WheelInfo 
{
    var(WheelInfo) Vector LocationOffset;
    var(WheelInfo) Rotator RotationOffset;
    var Vector LastFramePosition;
    var Rotator TravelRotation;
    var Actor Wheel;
    var Actor GroundLevelIndicator;
    var(WheelInfo) float Radius;
    var(WheelInfo) bool bRightWheel;
    var(WheelInfo) bool bCanTurn;
};

var(SFXSeqAct_WheelController_NativeBase) array<WheelInfo> Wheels;
var(SFXSeqAct_WheelController_NativeBase) Actor Chassis;
var(SFXSeqAct_WheelController_NativeBase) Actor SteeringWheel;
var(SFXSeqAct_WheelController_NativeBase) float SteeringLimit;
var(SFXSeqAct_WheelController_NativeBase) float SuspensionVariance;

public final native function UpdateWheels(float LocalChassisVelocityX, Rotator WheelTargetFacing);

public function ProcessWheels()
{
    local Vector LocalChassisVelocity;
    local Rotator WheelTargetFacing;
    
    LocalChassisVelocity = Chassis.Velocity << Chassis.Rotation;
    if (SteeringWheel != None)
    {
        WheelTargetFacing.Yaw = ClampRotAxisFromBase(Rotator(SteeringWheel.location - Chassis.location).Yaw, Chassis.Rotation.Yaw, int(SteeringLimit * 182.044449)) - Chassis.Rotation.Yaw;
    }
    UpdateWheels(LocalChassisVelocity.X, WheelTargetFacing);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}