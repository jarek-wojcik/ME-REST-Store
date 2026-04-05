Class ApexComponentBase extends MeshComponent
    native
    editinlinenew;

var const transient native Pointer ComponentBaseResources;
var const transient native RenderCommandFence_Mirror ReleaseResourcesFence;
var(ApexComponentBase) const ApexAsset Asset;
var(ApexComponentBase) Color WireframeColor;
var const bool bAssetChanged;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WireframeColor = {B = 64, G = 128, R = 255, A = 255}
    ReplacementPrimitive = None
    CollideActors = TRUE
    BlockActors = TRUE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
    BlockRigidBody = TRUE
    TickGroup = ETickingGroup.TG_PreAsyncWork
}