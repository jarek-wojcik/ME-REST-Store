Class FracturedBaseComponent extends StaticMeshComponent
    native
    editinlinenew
    abstract;

var const transient array<byte> VisibleFragments;
var const transient native Pointer ComponentBaseResources;
var const transient native RenderCommandFence_Mirror ReleaseResourcesFence;
var const int NumResourceIndices;
var const int ComponentIndexBufferSize;
var const transient int bResetStaticMesh;
var transient bool bVisibilityHasChanged;
var const transient bool bVisibilityReset;
var const bool bInitialVisibilityValue;
var const bool bUseDynamicIndexBuffer;
var const bool bUseDynamicIBWithHiddenFragments;

public native function int GetNumFragments();

public native function int GetNumVisibleFragments();

public simulated native function array<byte> GetVisibleFragments();

public simulated native function bool IsFragmentVisible(int FragmentIndex);

public simulated native function bool SetStaticMesh(StaticMesh NewMesh, optional bool bForce);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bInitialVisibilityValue = TRUE
    bUseDynamicIndexBuffer = TRUE
    ReplacementPrimitive = None
    bAcceptsStaticDecals = FALSE
}