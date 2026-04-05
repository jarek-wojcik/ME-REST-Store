Class ModelComponent extends PrimitiveComponent
    native
    noexport;

var const transient native noexport Object Model;
var const transient native noexport int ZoneIndex;
var const transient native noexport int ComponentIndex;
var const transient native noexport array<Pointer> Nodes;
var const transient native noexport array<Pointer> Edges;
var const transient native noexport array<Pointer> Elements;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementPrimitive = None
    bUseAsOccluder = TRUE
    bAcceptsStaticDecals = TRUE
    CastShadow = TRUE
    bAcceptsLights = TRUE
    bUsePrecomputedShadows = TRUE
    bCullModulatedShadowOnBackfaces = TRUE
    bCullModulatedShadowOnEmissive = TRUE
    LightingChannels = {bInitialized = TRUE, BSP = TRUE}
    ComponentType = EComponentType.COMPONENT_StaticMesh
}