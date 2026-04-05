Class SkyLight extends Light
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SkyLightComponent Name=SkyLightComponent0
        bCanAffectDynamicPrimitivesOutsideDynamicChannel = TRUE
        LightingChannels = {Static = FALSE, CompositeDynamic = FALSE, Skybox = TRUE}
    End Object
    LightComponent = SkyLightComponent0
    Components = (None, SkyLightComponent0)
}