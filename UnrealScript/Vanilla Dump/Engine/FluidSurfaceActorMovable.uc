Class FluidSurfaceActorMovable extends FluidSurfaceActor
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=FluidSurfaceComponent Name=NewFluidComponent
        ReplacementPrimitive = None
    End Template
    FluidComponent = NewFluidComponent
    Components = (NewFluidComponent)
    bMovable = TRUE
    Physics = EPhysics.PHYS_Interpolating
}