Class SFXCameraInput within SFXCameraMode
    native;

var(Tweak) Vector2D CameraSensitivity;
var(Tweak) float TimeToReachFullSpeed;
var(Tweak) float MaxCameraRotationSpeed;
var(Tweak) float StickDeadZone;
var(SFXCameraInput) float MouseClampMax;
var bool m_bUseExplorationSensitivity;
var(Tweak) bool bSwitchSticks;
var(SFXCameraInput) bool bClampMouse;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TimeToReachFullSpeed = 0.200000003
    MaxCameraRotationSpeed = 1.0
    StickDeadZone = 0.00100000005
}