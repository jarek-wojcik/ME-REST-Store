Class DirectionalLight extends Light
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DirectionalLightComponent Name=DirectionalLightComponent0
        LightAffectsClassification = ELightAffectsClassification.LAC_DYNAMIC_AND_STATIC_AFFECTING
    End Object
    LightComponent = DirectionalLightComponent0
    Components = (None, DirectionalLightComponent0, None)
    Rotation = {Pitch = -16384, Yaw = 0, Roll = 0}
}