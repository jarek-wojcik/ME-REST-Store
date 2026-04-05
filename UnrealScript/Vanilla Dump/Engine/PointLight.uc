Class PointLight extends Light
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=PointLightComponent Name=PointLightComponent0
        CastDynamicShadows = FALSE
        LightingChannels = {Dynamic = FALSE}
    End Object
    LightComponent = PointLightComponent0
    Components = (None, None, None, PointLightComponent0)
}