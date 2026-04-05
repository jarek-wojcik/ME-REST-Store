Class MeshComponentFactory extends PrimitiveComponentFactory
    native
    abstract;

var(Rendering) array<MaterialInterface> Materials;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CastShadow = TRUE
}