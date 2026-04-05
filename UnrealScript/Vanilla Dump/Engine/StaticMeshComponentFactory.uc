Class StaticMeshComponentFactory extends MeshComponentFactory
    native
    editinlinenew
    collapsecategories;

var(StaticMeshComponentFactory) StaticMesh StaticMesh;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CollideActors = TRUE
    BlockActors = TRUE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
    BlockRigidBody = TRUE
}