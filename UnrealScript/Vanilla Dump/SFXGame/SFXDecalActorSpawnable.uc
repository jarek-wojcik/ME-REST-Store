Class SFXDecalActorSpawnable extends DecalActorMovable
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DecalComponent Name=NewDecalComponent
        bStaticDecal = FALSE
        ReplacementPrimitive = None
    End Template
    Decal = NewDecalComponent
    Components = (NewDecalComponent, None, None)
    bNoDelete = FALSE
}