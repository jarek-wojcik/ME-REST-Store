Class SpotLightMovable extends SpotLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SpotLightComponent Name=SpotLightComponent0
        CastDynamicShadows = TRUE
        LightingChannels = {Dynamic = TRUE}
        LightAffectsClassification = ELightAffectsClassification.LAC_DYNAMIC_AND_STATIC_AFFECTING
    End Template
    LightComponent = SpotLightComponent0
    Components = (None, None, None, None, None, SpotLightComponent0, None)
    bStatic = FALSE
    bNoDelete = FALSE
    bHardAttach = TRUE
    bMovable = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}