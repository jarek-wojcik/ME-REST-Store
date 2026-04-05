Class DecalActorBase extends Actor
    native
    abstract;

var(DecalActorBase) const editinline editconst export DecalComponent Decal;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DecalComponent Name=NewDecalComponent
        bStaticDecal = TRUE
        DecalTransform = EDecalTransform.DecalTransform_OwnerAbsolute
        ReplacementPrimitive = None
    End Object
    Decal = NewDecalComponent
    Components = (NewDecalComponent, None, None)
    bStatic = TRUE
    bMovable = FALSE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}