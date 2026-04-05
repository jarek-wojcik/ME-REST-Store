Class DominantDirectionalLight extends DirectionalLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DominantDirectionalLightComponent Name=DominantDirectionalLightComponent0
        LightmassSettings = {LightSourceAngle = 0.200000003}
        bAllowPreShadow = TRUE
        LightAffectsClassification = ELightAffectsClassification.LAC_DYNAMIC_AND_STATIC_AFFECTING
    End Object
    LightComponent = DominantDirectionalLightComponent0
    Components = (None, None, DominantDirectionalLightComponent0)
    bStatic = FALSE
    bHardAttach = TRUE
}