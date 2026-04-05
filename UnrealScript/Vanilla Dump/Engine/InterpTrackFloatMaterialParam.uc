Class InterpTrackFloatMaterialParam extends InterpTrackFloatBase
    native
    collapsecategories;

var const editinline array<MeshMaterialRef> AffectedMaterialRefs;
var(InterpTrackFloatMaterialParam) Name ParamName;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstFloatMaterialParam'
    TrackTitle = "Float Material Param"
}