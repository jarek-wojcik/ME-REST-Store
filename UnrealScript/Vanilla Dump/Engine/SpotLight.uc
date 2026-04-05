Class SpotLight extends Light
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SpotLightComponent Name=SpotLightComponent0
        CastDynamicShadows = FALSE
        LightingChannels = {Dynamic = FALSE, CompositeDynamic = FALSE}
    End Object
    LightComponent = SpotLightComponent0
    Components = (None, None, None, None, None, SpotLightComponent0, None)
    Rotation = {Pitch = -16384, Yaw = 0, Roll = 0}
}