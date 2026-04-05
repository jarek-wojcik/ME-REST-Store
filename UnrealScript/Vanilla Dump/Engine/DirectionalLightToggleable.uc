Class DirectionalLightToggleable extends DirectionalLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DirectionalLightComponent Name=DirectionalLightComponent0
        LightmassSettings = {IndirectLightingScale = 0.0}
    End Template
    LightComponent = DirectionalLightComponent0
    Components = (None, DirectionalLightComponent0, None)
    bStatic = FALSE
    bHardAttach = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}