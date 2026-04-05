Class AmbientSoundMovable extends AmbientSound
    native
    placeable
    transient;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bStatic = FALSE
    Physics = EPhysics.PHYS_Interpolating
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}