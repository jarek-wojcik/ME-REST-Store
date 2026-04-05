Class DominantPointLight extends PointLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DominantPointLightComponent Name=DominantPointLightComponent0
        bAllowPreShadow = TRUE
        LightAffectsClassification = ELightAffectsClassification.LAC_DYNAMIC_AND_STATIC_AFFECTING
    End Object
    LightComponent = DominantPointLightComponent0
    Components = (None, None, None, DominantPointLightComponent0)
    bStatic = FALSE
    bHardAttach = TRUE
}