Class BrushComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

struct KCachedConvexData_Mirror 
{
    var array<int> CachedConvexElements;
};

var const Model Brush;
var KAggregateGeom BrushAggGeom;
var const transient native noimport Pointer BrushPhysDesc;
var const transient native noimport KCachedConvexData_Mirror CachedPhysBrushData;
var const int CachedPhysBrushDataVersion;
var(BrushComponent) bool bBlockComplexCollisionTrace;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bBlockComplexCollisionTrace = TRUE
    ReplacementPrimitive = None
    HiddenGame = TRUE
    bUseAsOccluder = TRUE
    AlwaysLoadOnClient = FALSE
    AlwaysLoadOnServer = FALSE
}