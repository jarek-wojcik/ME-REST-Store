Class DefaultPhysicsVolume extends PhysicsVolume
    native
    transient;

public event function Destroyed()
{
    assert(FALSE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = FALSE
    bNoDelete = FALSE
    bHiddenEd = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}