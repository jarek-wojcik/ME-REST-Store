Class DecalActor extends DecalActorBase
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DecalComponent Name=NewDecalComponent
        ReplacementPrimitive = None
    End Template
    Decal = NewDecalComponent
    Components = (NewDecalComponent, None, None)
}