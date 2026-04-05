Class BioCameraUtility extends SFXCameraMode
    native
    abstract;

var float m_fCameraCollisionTestPointRange;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 38.0, Y = 65.0}
    End Template
    m_fCameraCollisionTestPointRange = 35.0
    Input = s_Input
    bIsCameraShakeEnabled = TRUE
}