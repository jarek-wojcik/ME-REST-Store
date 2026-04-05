Class InterpTrackVectorMaterialParam extends InterpTrackVectorBase
    native
    collapsecategories;

var const editinline array<MeshMaterialRef> AffectedMaterialRefs;
var(InterpTrackVectorMaterialParam) Name ParamName;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstVectorMaterialParam'
    TrackTitle = "Vector Material Param"
}