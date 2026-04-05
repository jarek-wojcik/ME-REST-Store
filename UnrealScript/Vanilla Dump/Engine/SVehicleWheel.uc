Class SVehicleWheel extends Component
    native;

enum EWheelSide
{
    SIDE_None,
    SIDE_Left,
    SIDE_Right,
};

var const transient Pointer WheelShape;
var Class<ParticleSystemComponent> WheelPSCClass;
var(SVehicleWheel) Vector BoneOffset;
var Vector WheelPosition;
var Vector ContactNormal;
var Vector LongDirection;
var Vector LatDirection;
var(SVehicleWheel) Name SkelControlName;
var(SVehicleWheel) Name BoneName;
var Name SlipParticleParamName;
var(SVehicleWheel) float Steer;
var(SVehicleWheel) float MotorTorque;
var(SVehicleWheel) float BrakeTorque;
var(SVehicleWheel) float ChassisTorque;
var(SVehicleWheel) float SteerFactor;
var SkelControlWheel WheelControl;
var(SVehicleWheel) float WheelRadius;
var(SVehicleWheel) float SuspensionTravel;
var(SVehicleWheel) float SuspensionSpeed;
var(SVehicleWheel) ParticleSystem WheelParticleSystem;
var(SVehicleWheel) float LongSlipFactor;
var(SVehicleWheel) float LatSlipFactor;
var(SVehicleWheel) float HandbrakeLongSlipFactor;
var(SVehicleWheel) float HandbrakeLatSlipFactor;
var(SVehicleWheel) float ParkedSlipFactor;
var float SpinVel;
var float LongSlipRatio;
var float LatSlipAngle;
var float ContactForce;
var float LongImpulse;
var float LatImpulse;
var float DesiredSuspensionPosition;
var float SuspensionPosition;
var float CurrentRotation;
var const transient int WheelMaterialIndex;
var editinline export ParticleSystemComponent WheelParticleComp;
var(SVehicleWheel) bool bPoweredWheel;
var(SVehicleWheel) bool bHoverWheel;
var(SVehicleWheel) bool bCollidesVehicles;
var(SVehicleWheel) bool bCollidesPawns;
var bool bIsSquealing;
var bool bWheelOnGround;
var(SVehicleWheel) EWheelSide Side;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WheelPSCClass = Class'ParticleSystemComponent'
    SlipParticleParamName = 'WheelSlip'
    WheelRadius = 35.0
    SuspensionTravel = 30.0
    SuspensionSpeed = 50.0
    LongSlipFactor = 4000.0
    LatSlipFactor = 20000.0
    HandbrakeLongSlipFactor = 4000.0
    HandbrakeLatSlipFactor = 20000.0
    ParkedSlipFactor = 20000.0
    bCollidesVehicles = TRUE
}