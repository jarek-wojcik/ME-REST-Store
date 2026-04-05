Class BioCameraBehavior extends BioCameraUtility
    native
    abstract;

public function Tick(float TimeDelta);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 35.0, Y = 30.0}
    End Template
    Input = s_Input
}