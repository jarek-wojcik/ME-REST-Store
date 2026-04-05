Class SkyLightToggleable extends SkyLight
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SkyLightComponent Name=SkyLightComponent0
    End Template
    LightComponent = SkyLightComponent0
    Components = (None, SkyLightComponent0)
    bStatic = FALSE
    bHardAttach = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}