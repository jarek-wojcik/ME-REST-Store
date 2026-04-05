Class PointLightMovable extends PointLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=PointLightComponent Name=PointLightComponent0
        CastDynamicShadows = TRUE
        LightingChannels = {Dynamic = TRUE}
        LightAffectsClassification = ELightAffectsClassification.LAC_DYNAMIC_AND_STATIC_AFFECTING
    End Template
    LightComponent = PointLightComponent0
    Components = (None, None, None, PointLightComponent0)
    bStatic = FALSE
    bHardAttach = TRUE
    bMovable = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}