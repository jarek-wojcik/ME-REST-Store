Class FracturedStaticMeshComponent extends FracturedBaseComponent
    native
    editinlinenew;

struct native FragmentGroup 
{
    var array<int> FragmentIndices;
    var bool bGroupIsRooted;
};

var const transient array<byte> FragmentNeighborsVisible;
var const Box VisibleBox;
var(FracturedStaticMeshComponent) float TopBottomFragmentDistThreshold;
var(FracturedStaticMeshComponent) MaterialInterface LoseChunkOutsideMaterialOverride;
var float FragmentBoundsMaxZ;
var float FragmentBoundsMinZ;
var editinline transient export FracturedSkinnedMeshComponent SkinnedComponent;
var const bool bUseSkinnedRendering;
var bool bUseVisibleVertsForBounds;
var(FracturedStaticMeshComponent) bool bTopFragmentsRootNonDestroyable;
var(FracturedStaticMeshComponent) bool bBottomFragmentsRootNonDestroyable;

public final native function array<int> GetBoundaryHiddenFragments(array<int> AdditionalVisibleFragments);

public final native function int GetCoreFragmentIndex();

public final native function PhysicalMaterial GetFracturedMeshPhysMaterial();

public final native function Vector GetFragmentAverageExteriorNormal(int FragmentIndex);

public final native function Box GetFragmentBox(int FragmentIndex);

public final native function array<FragmentGroup> GetFragmentGroups(array<int> IgnoreFragments, float MinConnectionArea);

public final native function bool IsFragmentDestroyable(int FragmentIndex);

public final native function bool IsNoPhysFragment(int FragmentIndex);

public final native function bool IsRootFragment(int FragmentIndex);

public final native function RecreatePhysState();

public final native function SetVisibleFragments(array<byte> VisibilityFactors);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TopBottomFragmentDistThreshold = 0.100000001
    ReplacementPrimitive = None
    bUsePrecomputedShadows = TRUE
}