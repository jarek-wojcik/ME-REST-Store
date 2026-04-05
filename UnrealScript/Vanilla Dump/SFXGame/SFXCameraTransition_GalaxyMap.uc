Class SFXCameraTransition_GalaxyMap extends SFXCameraMode_Interpolate;

public function Tick(float TimeDelta)
{
    bComplete = TRUE;
    m_pov = To.m_pov;
}
public function InitializeTransition(SFXCameraMode FromMode, SFXCameraMode ToMode, float Time, bool PreserveTarget)
{
    Super.InitializeTransition(FromMode, ToMode, Time, PreserveTarget);
    if (BioCameraBehaviorGalaxy(From) == None && BioCameraBehaviorConversation(From) == None && BioCameraBehaviorGalaxy(To) == None && BioCameraBehaviorConversation(To) == None)
    {
        To.m_pov = From.m_pov;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Input = s_Input
    bCollisionEnabled = FALSE
}