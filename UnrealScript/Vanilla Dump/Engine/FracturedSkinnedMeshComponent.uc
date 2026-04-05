Class FracturedSkinnedMeshComponent extends FracturedBaseComponent
    native
    editinlinenew;

var const transient array<Matrix> FragmentTransforms;
var const editinline transient export array<FracturedStaticMeshComponent> DependentComponents;
var const transient native Pointer ComponentSkinResources;
var const transient bool bBecameVisible;
var const transient bool bFragmentTransformsChanged;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bInitialVisibilityValue = FALSE
    ReplacementPrimitive = None
    bAllowCullDistanceVolume = FALSE
    bAllowApproximateOcclusion = TRUE
    bAcceptsDynamicDecals = FALSE
    bAcceptsFoliage = FALSE
    CastShadow = FALSE
    bCastDynamicShadow = FALSE
    CollideActors = FALSE
    BlockActors = FALSE
    BlockZeroExtent = FALSE
    BlockNonZeroExtent = FALSE
    BlockRigidBody = FALSE
}