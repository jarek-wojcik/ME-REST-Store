Class DominantSpotLight extends SpotLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DominantSpotLightComponent Name=DominantSpotLightComponent0
        bAllowPreShadow = TRUE
        LightAffectsClassification = ELightAffectsClassification.LAC_DYNAMIC_AND_STATIC_AFFECTING
    End Object
    LightComponent = DominantSpotLightComponent0
    Components = (None, None, None, None, None, None, DominantSpotLightComponent0)
    bStatic = FALSE
    bHardAttach = TRUE
}